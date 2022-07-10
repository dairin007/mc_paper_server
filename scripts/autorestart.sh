#!/bin/bash

export PATH=/usr/local/bin:$PATH

# log func
function log() {
   LOG=$LOG_PATH/$LOG_NAME
   time=$(date '+%Y/%m/%d %T')
   echo -e "$time" "$1" | tee -a $LOG
   if [[ $2 != "" ]]; then
       echo -e "$2" | tee -a $LOG
   fi
}

cd /home/ubuntu/docker/mc_server

WAIT=120
LOG_PATH="/home/ubuntu/docker/mc_server/scripts/reboot_log"
LOG_NAME="$(basename $0 | sed -e 's/.sh//g').log"

echo "--------------------------------------------------------------------"
log "start"

log "rcon-cli say The server will reboot ${WAIT} seconds"
result="$(docker-compose exec -T production_minecraft_server rcon-cli "say test")"
if [[ $(echo $?) -ne 0 ]]; then
    log "say command 失敗" "$result"
    exit 1
fi

log "sleep ${WAIT}"
result="$(sleep ${WAIT})"

log "rcon-cli say Reboot the server now"

result="$(docker-compose exec -T production_minecraft_server rcon-cli "say Reboot the server now")"
if [[ $(echo $?) -ne 0 ]]; then
    log "say command 失敗" "$result"
    exit 1
fi

log "rcon-cli server stop"
result="$(docker-compose exec -T production_minecraft_server rcon-cli stop)"
if [[ $(echo $?) -ne 0 ]]; then
    log "docker-compose up -d 失敗" "$result"
    exit 1
fi

log "sleep 15"
result="$(sleep 15)"

log "docker-compose stop minecraft server"
result="$(docker-compose down)"
if [[ $(echo $?) -ne 0 ]]; then
    log "docker-compose down 失敗" "$result"
    exit 1
fi

log "socker-compose start"
result="$(bash ./start_prod.sh)"
if [[ $(echo $?) -ne 0 ]]; then
    log "docker-compose up -d 失敗" "$result"
    exit 1
fi

log "end"
echo "--------------------------------------------------------------------"

exit 0

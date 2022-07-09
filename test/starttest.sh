#!/bin/bash
set -e

MINECRAFT_VERSION=1.19
mkdir -p data

echo "download plugin"
bash ./download_plugin.sh

echo "start server"

# TODO: download plugin

docker-compose up -d
sleep 20
docker-compose ps

if [ ! -z "$(docker-compose ps | grep 'Exit 1')" ]; then
  echo "error: service is down"
  exit 1
fi

# wait start loop
SECONDS=0
while true
do
	sleep 1
	MCSTATUS_JSON=$(mcstatus localhost:${export_port_tcp} json)
	MCSTATUS_ONLINE=$(echo ${MCSTATUS_JSON} | jq .online)
	if [ "${MCSTATUS_ONLINE}" == 'true' ]; then
		break
	fi
	echo "waiting...${SECONDS}"
	if [ $SECONDS -gt 60 ]; then
		echo "timeout"
		break
	fi
done

docker-compose logs
echo "${MCSTATUS_JSON}"
MCSTATUS_VERSION=$(echo ${MCSTATUS_JSON} | jq .version)

if [ "${MCSTATUS_VERSION}" != "\"Paper ${MINECRAFT_VERSION}\"" ]; then
  echo "Minecraft version mismatch: ${MCSTATUS_VERSION}"
  exit 1
fi

docker-compose down

exit 0

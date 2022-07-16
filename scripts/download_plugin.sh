#!/bin/bash
set -e

# plugin_org/plugin_repo plugin_version source name_prefix version_prefix opencollab_prefix
# opencollab's release is kasu
PLUGINS=(
  "PlayPro/CoreProtect v21.2 github-releases CoreProtect- no_v none"
  "DiscordSRV/DiscordSRV v1.25.1 github-releases DiscordSRV-Build- no_v none"
  "Camotoy/GeyserSkinManager 1.6 github-releases GeyserSkinManager-Spigot no_version none"
  "sladkoff/minecraft-prometheus-exporter v2.5.0 github-releases minecraft-prometheus-exporter- no_v none"
  "ViaVersion/ViaBackwards 4.3.1 github-releases ViaBackwards- none none"
  "ViaVersion/ViaVersion 4.3.1 github-releases ViaVersion- none none"
  "GeyserMC/Floodgate 70 opencollab floodgate-spigot no_version spigot/build/libs"
  "GeyserMC/Geyser 1148 opencollab Geyser-Spigot no_version bootstrap/spigot/target"
)

function verify_version_prefix(){
  VERSION_PREFIX_LIST=("no_v" "no_version" "none")
  for value in "${VERSION_PREFIX_LIST[@]}"; do
    if [ "$value" == "$1" ]; then
      return 0
    fi
  done
  echo "Invalid version prefix: $1"
  exit 1
}

function download(){
  echo "${ORG}/${REPO} URL:${URL}"

  # make file name
  LOCAL_FILE_NAME=${FILE_NAME_PREFIX%-}-${VERSION}.jar

  rm -rf "${FILE_NAME_PREFIX%-}"*.jar

  wget -qO "$LOCAL_FILE_NAME" "$URL"
  if [ $? -eq 0 ]; then
    echo "SUCCESS:downloaded as ${LOCAL_FILE_NAME}"
  else
    echo "FAILED:${ORG}/${REPO} is faild."
    exit 1
  fi
}

function download_plugin(){
  verify_version_prefix "$FILE_VERSION_PREFIX"

  if [ "${SOURCE}" == "github-releases" ]; then
    if [ "${FILE_VERSION_PREFIX}" == "no_v" ]; then
      FILE_VER=${VERSION#v}
      FILE_NAME=${FILE_NAME_PREFIX}${FILE_VER}
    elif [ "${FILE_VERSION_PREFIX}" == "no_version" ]; then
      FILE_NAME=${FILE_NAME_PREFIX}
    elif [ "${FILE_VERSION_PREFIX}" == "none" ]; then
      FILE_NAME=${FILE_NAME_PREFIX}${VERSION}
    fi
    URL="https://github.com/${ORG}/${REPO}/releases/download/${VERSION}/${FILE_NAME}.jar"
    download
  elif [ "${SOURCE}" == "opencollab" ]; then
      if [ "${FILE_VERSION_PREFIX}" == "no_version" ]; then
        FILE_NAME=${FILE_NAME_PREFIX}
      else
        echo "not impl, please implement"
        exit 1
      fi
      URL="https://ci.opencollab.dev/job/${ORG}/job/${REPO}/job/master/lastSuccessfulBuild/artifact/${OPENCOLLAB_PREFIX}/${FILE_NAME}.jar"
      download
    if [ ! $? -eq 0 ]; then
      echo "FAILED: lastSuccess ${ORG}/${REPO} from openlab."
      echo "retry fixed version"
      URL="https://ci.opencollab.dev/job/${ORG}/job/${REPO}/job/master/${VERSION}/artifact/${OPENCOLLAB_PREFIX}/${FILE_NAME}.jar"
      download
    fi
  fi
}

echo "goto data/plugins"
cd ./data/plugins
pwd

for item in "${PLUGINS[@]}"; do
  set -- $item
  ORG_REPO=$1
  VERSION=$2
  SOURCE=$3
  FILE_NAME_PREFIX=$4
  FILE_VERSION_PREFIX=$5
  OPENCOLLAB_PREFIX=$6

  ORG=${ORG_REPO%/*}
  REPO=${ORG_REPO#*/}
  echo "---------------------------------------------------------------"
  echo "org_repo=$ORG_REPO, org=$ORG, repo=$REPO, ver=$VERSION, source=$SOURCE"
  download_plugin
  if [ ! $? -eq 0 ]; then
    echo "download failed"
    exit 1
  fi
done

cd ../../
echo "exit data/plugins"

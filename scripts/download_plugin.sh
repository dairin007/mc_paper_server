#!/bin/bash
set -e

# Plugin Tuple
# "plugin_org plugin_repo plugin_version source name_prefix version_prefix opencollab_prefix"
PLUGINS=(
  "PlayPro CoreProtect v21.2 github CoreProtect- no_v"
  "DiscordSRV DiscordSRV v1.25.1 github DiscordSRV-Build- no_v"
  "Camotoy GeyserSkinManager 1.6 github GeyserSkinManager-Spigot no_version"
  "sladkoff minecraft-prometheus-exporter v2.5.0 github minecraft-prometheus-exporter- no_v"
  "ViaVersion ViaBackwards 4.3.0 github ViaBackwards- none"
  "ViaVersion ViaVersion 4.3.1 github ViaVersion- none"
  "GeyserMC Floodgate 70 opencollab floodgate-spigot no_version spigot/build/libs" # opencollab's versionning is kasu
  "GeyserMC Geyser 1133 opencollab Geyser-Spigot no_version bootstrap/spigot/target"
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

function download_plugin(){
  verify_version_prefix "$FILE_VERSION_PREFIX"

  if [ "${SOURCE}" == "github" ]; then
    if [ "${FILE_VERSION_PREFIX}" == "no_v" ]; then
      FILE_VER=${VERSION#v}
      FILE_NAME=${FILE_NAME_PREFIX}${FILE_VER}
    elif [ "${FILE_VERSION_PREFIX}" == "no_version" ]; then
       FILE_NAME=${FILE_NAME_PREFIX}
    elif [ "${FILE_VERSION_PREFIX}" == "none" ]; then
      FILE_NAME=${FILE_NAME_PREFIX}${VERSION}
    fi
    URL="https://github.com/${ORG}/${REPO}/releases/download/${VERSION}/${FILE_NAME}.jar"

  elif [ "${SOURCE}" == "opencollab" ]; then
      if [ "${FILE_VERSION_PREFIX}" == "no_version" ]; then
        FILE_NAME=${FILE_NAME_PREFIX}
      else
        echo "not impl, please implement"
        exit 1
      fi
      URL="https://ci.opencollab.dev/job/${ORG}/job/${REPO}/job/master/${VERSION}/artifact/${OPENCOLLAB_PREFIX}/${FILE_NAME}.jar"
  fi

  echo "${ORG}/${REPO} URL:${URL}"

  # make file name
  LOCAL_FILE_NAME=${FILE_NAME_PREFIX%-}-${VERSION}.jar

  rm -rf "${FILE_NAME_PREFIX%-}"*.jar

  wget -qO "$LOCAL_FILE_NAME" "$URL"
  if [ $? -eq 0 ]; then
    echo "${ORG}/${REPO} is downloaded as ${LOCAL_FILE_NAME}"
  else
    echo "${ORG}/${REPO} is download faild. (URL is ${URL})"
    exit 1
  fi
}

echo "goto data/plugins"
cd ./data/plugins
pwd

for item in "${PLUGINS[@]}"; do
  set -- $item
  ORG=$1
  REPO=$2
  VERSION=$3
  SOURCE=$4
  FILE_NAME_PREFIX=$5
  FILE_VERSION_PREFIX=$6
  OPENCOLLAB_PREFIX=$7
  echo "---------------------------------------------------------------"
  echo "org=$ORG, repo=$REPO, ver=$VERSION, source=$SOURCE"
  download_plugin
  if [ ! $? -eq 0 ]; then
    echo "download failed"
    exit 1
  fi
done

cd ../../
echo "exit data/plugins"

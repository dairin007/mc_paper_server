#!/bin/bash
set -e

bash ./download_plugin.sh
docker-compose -f docker-compose.yml -f docker-compose.pro.yml up -d

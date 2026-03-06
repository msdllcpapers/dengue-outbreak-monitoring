#!/usr/bin/env bash

set -euo pipefail

CURRENT_PATH=$(dirname $0)

captionColor=`tput setaf 6`
reset=`tput sgr0`

echo "${captionColor}Stop local environment${reset}"
docker-compose -f "${CURRENT_PATH}/"docker-compose-dengue.yml -p dengue-outbreak down

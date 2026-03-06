#!/usr/bin/env bash

set -euo pipefail

CURRENT_PATH=$(dirname $0)

captionColor=`tput setaf 6`
reset=`tput sgr0`

"${CURRENT_PATH}"/stop-env.sh

# Delete images from the previous builds
echo "${captionColor}Delete images from the previous builds${reset}"

# Many conditions below to avoid warnings from commands, that argument list is empty.
if [[ $(docker images -f "dangling=true" -q) ]]; then
    docker rmi $(docker images -f "dangling=true" -q)
fi

if [[ $(docker ps --no-trunc -aqf "status=exited") ]]; then
    docker ps --no-trunc -aqf "status=exited" | xargs docker rm
fi

if [[ $(docker images --no-trunc -aqf "dangling=true") ]]; then
    docker images --no-trunc -aqf "dangling=true" | xargs docker rmi
fi

if [[ $(docker volume ls -qf "dangling=true") ]]; then
    docker volume ls -qf "dangling=true" | xargs docker volume rm
fi

echo "${captionColor}Starting local environment${reset}"

docker-compose -f "${CURRENT_PATH}"/docker-compose-dengue.yml -p dengue-outbreak up --build

currently_waited_in_seconds=0
wait_in_seconds=40

db_health_status=""
while [[ "${db_health_status}" != "healthy" && $currently_waited_in_seconds -lt $wait_in_seconds ]] ; do
  db_health_status=$(docker inspect -f {{.State.Health.Status}}  dengue_db)
  echo "Wait when local database is up..."
  currently_waited_in_seconds=$((currently_waited_in_seconds + 1))
  sleep 1
done

if [ "${db_health_status}" != "healthy" ]; then
  echo "ERROR: Local database is unhealthy"
  exit 1;
fi

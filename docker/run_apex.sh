#!/bin/bash

source $HOME/Workspace/toolbox/utils/colors.sh


# Usage info.
usage() {
  printf "\n Usage: $0 -name <container-name> -1521 <db-port-mappin> -8080 <apex-port-mapping> -5500 <5500-mapping> -22 <22-mapping> -8443 <8443-mapping> \n" 1>&2
  exit 1
}


# Default values
CONTAINER_NAME=23cfree
_DB_PORT=1521
_APEX_PORT=8080
_5500_PORT=5500
_22_PORT=22
_8443_PORT=8443

# Parse options.
while [[ $# -gt 0 ]]; do
    case "$1" in
        -name)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        -1521)
            _DB_PORT="$2"
            shift 2
            ;;
        -8080)
            _APEX_PORT="$2"
            shift 2
            ;;
         -5500)
            _5500_PORT="$2"
            shift 2
            ;;
         -22)
            _22_PORT="$2"
            shift 2
            ;;
        -8443)
            _8443_PORT="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

check_port_in_use() {
  local port=$1

  # Check if the port number was provided
  if [ -z "$port" ]; then
    error "Error: No port number provided."
    exit 1
  fi

  # Check if the port is in use using lsof
  if lsof -i :$port > /dev/null; then
    error "Error: Port $port is already in use."
    exit 1
  else
    info "Port $port is available."
  fi
}

run_apex_container() {

    check_port_in_use $_DB_PORT
    check_port_in_use $_APEX_PORT
    check_port_in_use $_5500_PORT
    check_port_in_use $_22_PORT
    check_port_in_use $_8443_PORT

    docker create -it --name $CONTAINER_NAME -p $_DB_PORT:1521 -p $_5500_PORT:5500 -p $_APEX_PORT:8080 -p $_8443_PORT:8443 -p $_22_PORT:22 -e ORACLE_PWD=E container-registry.oracle.com/database/free:latest
    curl -o unattended_apex_install_23c.sh https://raw.githubusercontent.com/Pretius/pretius-23cfree-unattended-apex-installer/main/src/unattended_apex_install_23c.sh
    curl -o 00_start_apex_ords_installer.sh https://raw.githubusercontent.com/Pretius/pretius-23cfree-unattended-apex-installer/main/src/00_start_apex_ords_installer.sh
    docker cp unattended_apex_install_23c.sh $CONTAINER_NAME:/home/oracle
    docker cp 00_start_apex_ords_installer.sh $CONTAINER_NAME:/opt/oracle/scripts/startup
    docker start $CONTAINER_NAME
}

run_apex_container
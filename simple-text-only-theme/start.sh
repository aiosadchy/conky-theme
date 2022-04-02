#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

cd "${SCRIPT_DIR}"

sleep 5
env $(cat config/configuration.env | xargs) conky -c "./memory.conkyrc"     &
env $(cat config/configuration.env | xargs) conky -c "./cpu.conkyrc"        &
env $(cat config/configuration.env | xargs) conky -c "./network.conkyrc"    &
env $(cat config/configuration.env | xargs) conky -c "./disks.conkyrc"      &
env $(cat config/configuration.env | xargs) conky -c "./clock.conkyrc"      &
env $(cat config/configuration.env | xargs) conky -c "./weather.conkyrc"    &

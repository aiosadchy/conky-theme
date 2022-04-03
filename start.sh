#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
readonly SLEEP_TIME=${1:-"10"}

cd "${SCRIPT_DIR}"

sleep "${SLEEP_TIME}"
env $(cat configuration.env | xargs) conky -c "./memory.conkyrc"     &
env $(cat configuration.env | xargs) conky -c "./cpu.conkyrc"        &
env $(cat configuration.env | xargs) conky -c "./network.conkyrc"    &
env $(cat configuration.env | xargs) conky -c "./disks.conkyrc"      &
env $(cat configuration.env | xargs) conky -c "./clock.conkyrc"      &
env $(cat configuration.env | xargs) conky -c "./weather.conkyrc"    &

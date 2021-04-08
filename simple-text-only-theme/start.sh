#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

cd "${SCRIPT_DIR}"

sleep 20
conky -c "./memory.conkyrc"     &
sleep 1
conky -c "./cpu.conkyrc"        &
sleep 1
conky -c "./network.conkyrc"    &
sleep 1
conky -c "./disks.conkyrc"      &
sleep 1
conky -c "./clock.conkyrc"      &
sleep 1
conky -c "./weather.conkyrc"    &

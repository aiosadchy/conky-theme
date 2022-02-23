#!/bin/bash

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

cd "${SCRIPT_DIR}"

sleep 10
conky -c "./memory.conkyrc"     &
conky -c "./cpu.conkyrc"        &
conky -c "./network.conkyrc"    &
conky -c "./disks.conkyrc"      &
conky -c "./clock.conkyrc"      &
conky -c "./weather.conkyrc"    &

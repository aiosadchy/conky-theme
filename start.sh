#!/usr/bin/env bash

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
readonly SLEEP_TIME="${1:-"10"}"

cd "${SCRIPT_DIR}"

sleep "${SLEEP_TIME}"

set -a
. configuration.sh
set +a

conky --daemonize --quiet -c "./memory.conkyrc"
conky --daemonize --quiet -c "./cpu.conkyrc"
conky --daemonize --quiet -c "./network.conkyrc"
conky --daemonize --quiet -c "./disks.conkyrc"
conky --daemonize --quiet -c "./clock.conkyrc"
conky --daemonize --quiet -c "./weather.conkyrc"

#!/bin/bash
export UID
# export GID="$(id -g)"
# docker run -ti -v ${PWD}:/work --user $(id -u):$(id -g) verilator/verilator:latest --cc test.v

echo "${UID}:${GID}"

GID="$(id -g)" docker compose up -d
GID="$(id -g)" docker compose exec verilator bash
# docker compose down

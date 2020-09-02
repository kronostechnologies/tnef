#!/bin/bash

CHECKOUT="${1:-1.4.18}"

docker build -t tnef-builder docker

mkdir -p bin

docker run -it --rm --name tnef-builder -v "$(pwd)/bin":/dist -- tnef-builder "${CHECKOUT}" "/dist"

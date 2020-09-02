#!/bin/bash

set -e

CHECKOUT="${1:-}"
DESTINATION="${2:-.}"

if [[ "$(ls -Uba1 | wc -l)" -le 2 ]]; then
  echo "Cloning tnef repository"
  git clone -q -- https://github.com/verdammelt/tnef /code
  if [[ -n "${CHECKOUT}" ]]; then
    echo "Checking out ${CHECKOUT}"
    git checkout -q "${CHECKOUT}"
  fi
fi

autoreconf
./configure
make --quiet check

if [[ -d "${DESTINATION}" ]]; then
  DESTFILE="${DESTINATION}/tnef-$(git describe --dirty --tags)-$(lsb_release -sc)-$(dpkg --print-architecture)"
  echo "Result in $(readlink -f ${DESTFILE})"
  cp -- src/tnef "${DESTFILE}"
fi

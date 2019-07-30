#!/bin/bash
set -e

CHROME_FLAGS=${CHROME_FLAGS:-"--headless --disable--gpu --no-sandbox"}

# first arg is `-f` or `--some-option`
if [ "${1#http}" != "$1" ]; then
    set -- lighthouse --chrome-flags="${CHROME_FLAGS}" "$@"
fi

exec "$@"

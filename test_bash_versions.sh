#!/bin/bash

if [[ -z `which docker` ]]; then
    echo "ERROR: Docker is not installed."
    exit 1
fi

for v in 3 4 5; do
    docker run -v "$PWD:/mnt" "bash:$v" \
    bash /mnt/tst
done

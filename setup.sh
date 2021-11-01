#!/bin/bash

if [ -d "oojs-ui" ]; then
    cd oojs-ui
    git reset --hard
    git clean -fd
else
    git clone https://github.com/wikimedia/oojs-ui.git
    cd oojs-ui
fi

latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
tag=${1:-$latestTag}

# Use only the latest tag.
git checkout $tag

npm install
composer install

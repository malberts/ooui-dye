#!/bin/bash

if [ -d "oojs-ui" ]; then
    cd oojs-ui
    git reset --hard
    git clean -fd
else
    git clone https://github.com/wikimedia/oojs-ui.git
    cd oojs-ui
fi

# Use only the latest tag.
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

npm install
composer install

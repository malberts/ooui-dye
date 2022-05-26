#!/bin/bash

if [ -d "oojs-ui" ]; then
    cd oojs-ui
    git reset --hard
    git clean -fd
    git checkout master
    git pull
else
    git clone https://github.com/wikimedia/oojs-ui.git
    cd oojs-ui
fi

latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
echo "Latest tag: $latestTag"
tag=${1:-$latestTag}

# Use only the latest tag.
git checkout $tag

npm install
php8.0 $(which composer) install

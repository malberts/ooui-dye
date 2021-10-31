#!/bin/bash

if [ -d "oojs-ui" ]; then
    cd oojs-ui
    git reset --hard
    git clean -fd
else
    git clone https://github.com/wikimedia/oojs-ui.git
    cd oojs-ui
fi

npm install

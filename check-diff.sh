#!/bin/bash

# If all changes are dates, reset the changes.
all=$(git diff -U0 | grep "^+ " | wc -l)
dates=$(git diff -U0 | grep "^+.*Date:" | wc -l)

if [ "$all" = "$dates" ]; then
    echo "No changes"
    git reset --hard
fi

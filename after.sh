#!/bin/bash

## 1
# 1px and 2px are probably intentional.
# Replace larger sizes with ratio:
# @ooui-font-size-browser / @ooui-font-size-base = 14

## 2
# Remove box-sizing

find dist -name *.css \
  -exec sed -Ei 's#\b([3-9]|[1-9][0-9]+)px#calc(\1 / 14 * var(--step-0))#g' {} \; \
  -exec sed -i '/box-sizing: border-box/d' {} \;

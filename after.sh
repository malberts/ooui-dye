#!/bin/bash

## 1
# 1px and 2px are probably intentional.
# Replace larger sizes with ratio:
# @ooui-font-size-browser / @ooui-font-size-base = 14

## 2
# Remove box-sizing

find oojs-ui/dist -name *.css \
  -exec echo "{}" \; \
  -exec sed -Ei 's#\b([3-9]|[1-9][0-9]+)px#calc(\1 / 14 * var(--font-size-base))#g' {} \; \
  -exec sed -i '/box-sizing: border-box/d' {} \;

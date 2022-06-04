#!/bin/bash

find oojs-ui/dist -name *.css \
  -exec echo "{}" \; \
  `# Pixel values > 2px` \
  `# Replace larger sizes with ratio = (x / @ooui-font-size-browser) / @ooui-font-size-base = 14` \
  -exec sed -Ei 's#-\b([3-9]|[1-9][0-9]+)px#calc(-\1 / 14 * var(--font-size-base))#g' {} \; \
  -exec sed -Ei 's#\b([3-9]|[1-9][0-9]+)px#calc(\1 / 14 * var(--font-size-base))#g' {} \; \
  `# Remove box-sizing` \
  -exec sed -i '/box-sizing: border-box/d' {} \;

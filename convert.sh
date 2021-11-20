#!/bin/bash

##
# Disable Apex to save time.
##
sed -Ei "s|^(\s+wikimediaui: 'WikimediaUI'),|\1|g" oojs-ui/Gruntfile.js
sed -Ei "s|^(\s+apex: 'Apex')|//\1|g" oojs-ui/Gruntfile.js

##
# Convert the WikimediaUI theme to use CSS custom properties for colors.
##

base=oojs-ui/src/themes/dye

# Copy base variables
cp oojs-ui/node_modules/wikimedia-ui-base/wikimedia-ui-base.less $base/variables.less

# Replace variables with CSS Properties
sed -Ei 's|^@(color-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less
sed -Ei 's|^@(background-color-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less
sed -Ei 's|^@(border-color-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less

sed -Ei 's|^@(color-[^:]+):(\s*).*@wmui[^;]*;|@\1:\2var( --\1 );|g' $base/common.less
sed -Ei 's|^@(background-color-[^:]+):(\s*).*@wmui[^;]*;|@\1:\2var( --\1 );|g' $base/common.less
sed -Ei 's|^@(border-color-[^:]+):(\s*).*@wmui[^;]*;|@\1:\2var( --\1 );|g' $base/common.less

# Hardcoded use of colors
# v0.39.3
sed -Ei 's|^(.*:.*)@wmui-color-yellow50|\1var( --border-color-warning )|g' $base/variables.less
# v0.40.0
sed -Ei 's|^(.*:.*)@wmui-color-accent50|\1var( --color-primary )|g' $base/variables.less
sed -Ei 's|^(@border-)([^:]*)(:.*)@wmui-color-[a-z0-9]+|\1\2\3var( --border-color-\2 )|g' $base/common.less

# Fonts
sed -Ei 's|^@(font-family-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less

# Comment unused variables
sed -Ei 's|^@(wmui\|width-breakpoint)|// @\1|g' $base/variables.less

##
# Specific variables
##
sed -Ei 's|^@(border-radius-base):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less

##
# Unusable mixins
##
# mix()
# v0.39.3
sed -i 's|mix( @color-progressive--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/elements.less
sed -i 's|mix( @color-progressive--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/tools.less
# v0.40.0
sed -i 's|mix( @color-primary--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/elements.less
sed -i 's|mix( @color-primary--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/tools.less

# lighten()
# - function
sed -Ei 's|(.mw-framed-button-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
sed -Ei 's|(.mw-tool-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
# - function content
sed -i 's|lighten( @active, 60% )|@active-bg|g' $base/common.less
# - function calls
sed -Ei 's|(.mw-framed-button-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/elements.less
sed -Ei 's|(.mw-tool-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/tools.less

# darken()
sed -i 's|darken( @border-color-base, 14% )|@border-color-base--active|g' $base/widgets.less;

# Replace import
sed -Ei "s|'.*wikimedia-ui-base.less'|'variables.less'|g" $base/common.less

# Convert all images to black, except the white variants
find $base -type f -name '*.json' -exec sed -Ei '/"#fff"/! s|color": "#[^"]*"|color": "#000"|g' {} \;

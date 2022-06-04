#!/bin/bash

##
# Disable Apex to save time.
##
sed -Ei "s|^(\s+wikimediaui: 'WikimediaUI'),|//\1|g" oojs-ui/Gruntfile.js
sed -Ei "s|^(\s+apex: 'Apex')|//\1|g" oojs-ui/Gruntfile.js

##
# Convert the WikimediaUI theme to use CSS custom properties for colors.
##

base=oojs-ui/src/themes/dye

# Copy base variables
cp oojs-ui/node_modules/wikimedia-ui-base/wikimedia-ui-base.less $base/variables.less


##
# Variables
##
# Convert all Less variables to CSS properties.
sed -Ei 's|^@([^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less
# Undo some variables used in calculations.
sed -Ei 's|^@(min-size-base):(\s*).*;|@\1:\2/* no var */ 32px;|g' $base/variables.less
sed -Ei 's|^@(min-size-icon):(\s*).*;|@\1:\2/* no var */ 20px;|g' $base/variables.less
sed -Ei 's|^@(padding-horizontal-base):(\s*).*;|@\1:\2/* no var */ 12px;|g' $base/variables.less


##
# Common
##

# Replace import
sed -Ei "s|'.*wikimedia-ui-base.less'|'variables.less'|g" $base/common.less


##
# Layouts
##
sed -i 's|@size-base + @start-frameless-icon|calc( @size-base + @start-frameless-icon )|g' $base/layouts.less
sed -Ei 's|-(@border-width-base)|calc( -1 * \1 )|g' $base/layouts.less
sed -Ei 's|(@border-width-base \* 2)|calc( \1 )|g' $base/layouts.less
sed -Ei 's|(box-sizing: border-box)|//\1|g' $base/layouts.less


##
# Widgets
##
sed -Ei 's|-(@border-width-base)|calc( -1 * \1 )|g' $base/widgets.less
sed -Ei 's|(@border-width-base \* 2)|calc( \1 )|g' $base/widgets.less
sed -Ei "s|\( (2 \* @border-width-base) \)|calc( \1 )|g" $base/widgets.less
sed -Ei 's|(@padding-horizontal-input-text \+ @border-width-base)|calc( \1 )|g' $base/widgets.less
sed -Ei 's|(@min-size-indicator \+ 2 \* @padding-horizontal-input-text)|calc( \1 )|g' $base/widgets.less
sed -Ei 's|(@margin-tagitem - @border-width-base)|calc( \1 )|g' $base/widgets.less
sed -Ei "s|\( (@padding-vertical-base - 2 \* @border-width-base) \)|calc( \1 )|g" $base/widgets.less
sed -Ei 's|(box-sizing: border-box)|//\1|g' $base/widgets.less


##
# Tools
##
sed -Ei 's|-(@border-width-base) \* 2|calc(\1 * -2)|g' $base/tools.less
sed -Ei 's|-(@border-width-base)|calc(-1 * \1)|g' $base/tools.less
sed -Ei 's|(box-sizing: border-box)|//\1|g' $base/tools.less


##
# Unusable mixins
##

# lighten()
# - function
sed -Ei 's|(.mw-framed-button-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
sed -Ei 's|(.mw-tool-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
# - function content
sed -i 's|lighten( @active, 60% )|@active-bg|g' $base/common.less

# mix()
# v0.39.3
sed -i 's|mix( @color-progressive--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/elements.less
sed -i 's|mix( @color-progressive--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/tools.less
# v0.40.0
sed -i 's|mix( @color-primary--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/elements.less
sed -i 's|mix( @color-primary--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/tools.less

# - function calls
sed -Ei 's|(.mw-framed-button-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/elements.less
sed -Ei 's|(.mw-tool-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/tools.less

# darken()
sed -i 's|darken( @border-color-base, 14% )|@border-color-base--active|g' $base/widgets.less;

##
# Icons
##
# Convert all images to black, except the white variants
find $base -type f -name '*.json' -exec sed -Ei '/"#fff"/! s|color": "#[^"]*"|color": "#000"|g' {} \;

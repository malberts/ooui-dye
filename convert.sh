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


##
# Variables
##
# Convert all Less variables to CSS properties.
sed -Ei 's|^@([^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less


##
# Common
##

# Replace import
sed -Ei "s|'.*wikimedia-ui-base.less'|'variables.less'|g" $base/common.less

# lighten()
# - function
sed -Ei 's|(.mw-framed-button-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
sed -Ei 's|(.mw-tool-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
# - function content
sed -i 's|lighten( @active, 60% )|@active-bg|g' $base/common.less

# Calculations
sed -i 's|@size-base + @start-frameless-icon|calc( @size-base + @start-frameless-icon )|g' $base/layouts.less

sed -Ei 's|^@(ooui-font-size-browser):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/common.less
sed -Ei 's|^@(ooui-font-size-base):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/common.less

# Remove unit()
sed -Ei 's|unit\(([^)]+)\)|\1|g' $base/common.less
sed -i 's|, @ooui-unit||g' $base/common.less
sed -Ei "s|^(@.*):\s*\((.*)\);|\1: calc(\2);|g" $base/common.less
sed -Ei "s|^(@.*):\s*\-\((.*)\);|\1: calc( -1 *\2);|g" $base/common.less
sed -Ei "s|(@size-indicator \* 2)|calc( \1 )|g" $base/common.less

sed -Ei "s|^(.*:.*@ooui-font-size-base)|\1 * 1em|g" $base/common.less
# Fix duplicate 1em
sed -Ei "s|(@padding-start-fieldset-header-iconized:.*) \* 1em|\1|g" $base/common.less;
sed -Ei "s|(calc\(.*) \((.*) \);|\1\2;|g" $base/common.less;

##
# Other calculations
##
for file in elements layouts tools widgets windows; do
  echo "$file"
  # 3 terms
  sed -Ei 's|(: +)([^ ]+ [+*/-] [^ ]+ [+*/-] [^ ]+);|\1calc( \2 );|g' $base/$file.less
  # 2 terms
  sed -Ei 's|(: +)([^ ]+ [+*/-] [^ ]+);|\1calc( \2 );|g' $base/$file.less
  # Negative var
  sed -Ei 's|( +)\-(@[a-z-]+)|\1calc( -1 * \2 )|g' $base/$file.less
  # Negative parantheses
  sed -Ei 's|( +)\-\(([^()]*)\)|\1calc( -1 * \2 )|g' $base/$file.less
  # Unit
  sed -i 's|unit(|(|g' $base/$file.less
  # Duplicate calc
  sed -Ei 's|(calc\(.*)calc\( ([^)]+) \)|\1\2|g' $base/$file.less
done

# Manual fixes
sed -Ei 's|(@size-indicator \+ \( 2 \* \( @padding-horizontal-base \) / @ooui-font-size-browser / @ooui-font-size-base)|calc( \1 )|g' $base/widgets.less
sed -Ei "s|\( (2 \* @border-width-base) \)|calc( \1 )|g" $base/widgets.less
sed -Ei "s|\( (@padding-vertical-base - 2 \* @border-width-base) \)|calc( \1 )|g" $base/widgets.less
sed -Ei "s|(@size-base - 2 \* \( @size-modifier-border \))|calc( \1 )|g" $base/widgets.less
sed -Ei "s|(@start-tool-icon - \( @size-toolbar-narrow-modifier / 2 \))|calc( \1 )|g" $base/tools.less
sed -Ei "s|0 \( (@padding-horizontal-base-iconized - @size-toolbar-narrow-modifier) \)|0 calc( \1 )|g" $base/tools.less
sed -Ei "s|(\( @padding-horizontal-base-iconized \* 1.5 \) - @size-toolbar-narrow-modifier)|calc( \1 )|g" $base/tools.less
sed -Ei "s|\( (@size-dialog-bar--desktop / \( @font-size-dialog-process-title \)) \)|calc( \1 )|g" $base/windows.less
sed -Ei "s|\( (@size-dialog-bar--mobile / \( @font-size-dialog-process-title \)) \)|calc( \1 )|g" $base/windows.less


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

# - function calls
sed -Ei 's|(.mw-framed-button-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/elements.less
sed -Ei 's|(.mw-tool-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/tools.less

# darken()
sed -i 's|darken( @border-color-base, 14% )|@border-color-base--active|g' $base/widgets.less;

# Convert all images to black, except the white variants
find $base -type f -name '*.json' -exec sed -Ei '/"#fff"/! s|color": "#[^"]*"|color": "#000"|g' {} \;

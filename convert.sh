#!/bin/bash

##
# Convert the WikimediaUI theme to use CSS custom properties for colors.
##

base=oojs-ui/src/themes/dye

# Create theme
rm -rf $base
cd oojs-ui
grunt add-theme --name=Dye --template=WikimediaUI
cd ..

# Copy base variables
cp oojs-ui/node_modules/wikimedia-ui-base/wikimedia-ui-base.less $base/dye-ui-base.less

# wmui color variables
sed -Ei 's|@wmui([^:]*):(\s+).*|@wmui\1:\2var( --ooui\1 );|g' $base/dye-ui-base.less

# rgba colors
sed -Ei 's|@([^:]*):(\s*)rgba[^;]*;|@\1:\2var( --ooui-\1 );|g' $base/dye-ui-base.less

# hex colors
sed -Ei 's|@([^:]*):(\s*)#([a-z0-9]+);|@\1:\2var( --\1 );|g' $base/common.less

# Unusable: mix()
sed -i 's|mix( @color-primary--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/elements.less
sed -i 's|mix( @color-primary--active, @background-color-filled--disabled, 35% )|var( --color-primary--active--disabled )|g' $base/tools.less

# Unusable: lighten()
# - function
sed -Ei 's|(.mw-framed-button-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
sed -Ei 's|(.mw-tool-colored.*, @active,)|\1 @active-bg,|g' $base/common.less
# - function content
sed -i 's|lighten( @active, 60% )|@active-bg|g' $base/common.less
# - function calls
sed -Ei 's|(.mw-framed-button-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/elements.less
sed -Ei 's|(.mw-tool-colored.*@color-)(.*)(--active,)|\1\2\3 @background-color-\2,|g' $base/tools.less


# unusable: darken()
sed -i 's|darken( @border-color-base, 14% )|@border-color-base--active|g' $base/widgets.less;

# Replace import
sed -Ei "s|'.*wikimedia-ui-base.less'|'dye-ui-base.less'|g" $base/common.less

# Convert all images to black, except the white variants
find $base -type f -name '*.json' -exec sed -Ei '/"#fff"/! s|color": "#[^"]*"|color": "#000"|g' {} \;

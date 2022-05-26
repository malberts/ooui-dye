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
# CSS properties
##

# Colors
sed -Ei 's|^@(color-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less
sed -Ei 's|^@(background-color-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less
sed -Ei 's|^@(border-color-[^:]+):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/variables.less

sed -Ei 's|^@(color-[^:]+):(\s*).*@wmui[^;]*;|@\1:\2var( --\1 );|g' $base/common.less
sed -Ei 's|^@(background-color-[^:]+):(\s*).*@wmui[^;]*;|@\1:\2var( --\1 );|g' $base/common.less
sed -Ei 's|^@(border-color-[^:]+):(\s*).*@wmui[^;]*;|@\1:\2var( --\1 );|g' $base/common.less

# Sizes
sed -Ei 's|^@([^:]+):(\s*)[^;]*px;|@\1:\2var( --\1 );|g' $base/variables.less

# Calculations
sed -Ei 's|^@([^:]+):(\s+)(.*\+.*);|@\1:\2calc( \3 );|g' $base/variables.less

##
# Hardcoded colors
##
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

# TODO: Replicate calculations
sed -Ei 's|^@(size-base):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/common.less
sed -Ei 's|^@(size-icon):(\s*)[^;]*;|@\1:\2var( --\1 );|g' $base/common.less

##
# Elements
##
sed -i 's|-( @size-icon / 2 )|calc( @size-icon / -2 )|g' $base/elements.less
sed -i 's|-@size-icon 0|calc( -1 * @size-icon ) 0|g' $base/elements.less

##
# Layouts
##
sed -i 's|@size-base + @start-frameless-icon|calc( @size-base + @start-frameless-icon )|g' $base/layouts.less
sed -i 's|-( @size-base + @size-modifier-border )|calc( -1 * ( @size-base + @size-modifier-border ) )|g' $base/layouts.less
sed -i 's|-@border-width-base|calc( -1 * @border-width-base )|g' $base/layouts.less

##
# Widgets
##
# src/styles/widgets/MessageWidget.less
sed -i 's|@size-icon + @padding-start-messages|calc( @size-icon + @padding-start-messages )|g' $base/widgets.less
sed -i 's|@min-size-base + @padding-horizontal-message-block|calc( @min-size-base + @padding-horizontal-message-block )|g' $base/widgets.less
# src/styles/widgets/ButtonGroupWidget.less
sed -i 's|-@border-width-base|calc( -1 * @border-width-base )|g' $base/widgets.less
# src/styles/widgets/CheckboxInputWidget.less
sed -i 's|@border-width-base \* 2|calc( @border-width-base * 2 )|g' $base/widgets.less
# src/styles/widgets/TextInputWidget.less
sed -i 's|@padding-horizontal-input-text + @border-width-base|calc( @padding-horizontal-input-text + @border-width-base )|g' $base/widgets.less
sed -i 's|@min-size-indicator + 2 \* @padding-horizontal-input-text|calc( @min-size-indicator + 2 * @padding-horizontal-input-text )|g' $base/widgets.less
# src/styles/widgets/MenuSectionOptionWidget.less
sed -i 's|2 \* @padding-horizontal-base;|calc( 2 * @padding-horizontal-base );|g' $base/widgets.less
# src/styles/widgets/DropdownWidget.less
sed -i 's|@padding-horizontal-base - @size-indicator-inner-distance|calc( @padding-horizontal-base - @size-indicator-inner-distance )|g' $base/widgets.less
sed -i 's|@size-indicator + ( 2 \* unit( @padding-horizontal-base ) / @ooui-font-size-browser / @ooui-font-size-base )|calc( @size-indicator + 2 * @padding-horizontal-base / 16 / 0.875 )|g' $base/widgets.less
# src/styles/widgets/TabOptionWidget.less
sed -i 's|( 2 \* @border-width-base )|calc( 2 * @border-width-base )|g' $base/widgets.less
sed -i 's|( @padding-vertical-base - 2 \* @border-width-base )|calc( @padding-vertical-base - 2 * @border-width-base )|g' $base/widgets.less
# src/styles/widgets/TagMultiselectWidget.less
sed -i 's|@size-base - 2 \* ( @size-modifier-border )|calc( @size-base - 2 * @size-modifier-border )|g' $base/widgets.less
sed -i 's|@size-icon + 2 \* 0.3em|calc( @size-icon + 2 * 0.3em )|g' $base/widgets.less
sed -i 's|@size-indicator + 2 \* 0.775em|calc( @size-indicator + 2 * 0.775em )|g' $base/widgets.less
# src/styles/widgets/TagItemWidget.less
sed -i 's|@margin-tagitem - @border-width-base|calc( @margin-tagitem - @border-width-base )|g' $base/widgets.less

##
# Tools
##
# src/styles/toolgroups/BarToolGroup.less
sed -i 's|-@border-width-base \* 2|calc( @border-width-base * -2 )|g' $base/tools.less
# src/styles/toolgroups/PopupToolGroup.less
sed -i 's|@size-tool - @size-toolbar-narrow-modifier|calc( @size-tool - @size-toolbar-narrow-modifier )|g' $base/tools.less
sed -i 's|-@border-width-base|calc( -1 * @border-width-base )|g' $base/tools.less

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

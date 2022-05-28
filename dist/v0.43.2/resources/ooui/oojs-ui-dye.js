/*!
 * OOUI v0.43.2
 * https://www.mediawiki.org/wiki/OOUI
 *
 * Copyright 2011–2022 OOUI Team and other contributors.
 * Released under the MIT license
 * http://oojs.mit-license.org
 *
 * Date: 2022-05-28T01:43:45Z
 */
( function ( OO ) {

'use strict';

/**
 * @class
 * @extends OO.ui.Theme
 *
 * @constructor
 */
OO.ui.DyeTheme = function OoUiWikimediaUITheme() {
	// Parent constructor
	OO.ui.DyeTheme.super.call( this );
};

/* Setup */

OO.inheritClass( OO.ui.DyeTheme, OO.ui.Theme );

/* Methods */

/**
 * @inheritdoc
 */
OO.ui.DyeTheme.prototype.getElementClasses = function ( element ) {
	var variant, isFramed, isActive, isToolOrGroup,
		variants = {
			invert: false,
			progressive: false,
			destructive: false,
			error: false,
			warning: false,
			success: false
		},
		// Parent method
		classes = OO.ui.DyeTheme.super.prototype.getElementClasses.call( this, element );

	if (
		element instanceof OO.ui.IconWidget &&
		// eslint-disable-next-line no-jquery/no-class-state
		element.$element.hasClass( 'oo-ui-checkboxInputWidget-checkIcon' )
	) {
		// Icon on CheckboxInputWidget
		variants.invert = true;
	} else if ( element.supports( 'hasFlag' ) ) {
		isFramed = element.supports( 'isFramed' ) && element.isFramed();
		isActive = element.supports( 'isActive' ) && element.isActive();
		isToolOrGroup =
			// Check if the class exists, as classes that are not in the 'core' module may
			// not be loaded.
			( OO.ui.Tool && element instanceof OO.ui.Tool ) ||
			( OO.ui.ToolGroup && element instanceof OO.ui.ToolGroup );
		if (
			// Button with a dark background.
			isFramed && ( isActive || element.isDisabled() || element.hasFlag( 'primary' ) ) ||
			// Toolbar with a dark background.
			isToolOrGroup && element.hasFlag( 'primary' )
		) {
			// … use white icon / indicator, regardless of other flags
			variants.invert = true;
		} else if ( !isFramed && element.isDisabled() && !element.hasFlag( 'invert' ) ) {
			// Frameless disabled button, always use black icon / indicator regardless of
			// other flags.
			variants.invert = false;
		} else if ( !element.isDisabled() ) {
			// Any other kind of button, use the right colored icon / indicator if available.
			variants.progressive = element.hasFlag( 'progressive' ) ||
				// Active tools/toolgroups
				( isToolOrGroup && isActive ) ||
				// Pressed or selected outline/menu option widgets
				(
					(
						element instanceof OO.ui.MenuOptionWidget ||
						// Check if the class exists, as classes that are not in the 'core' module
						// may not be loaded.
						(
							OO.ui.OutlineOptionWidget &&
							element instanceof OO.ui.OutlineOptionWidget
						)
					) &&
					( element.isPressed() || element.isSelected() )
				);

			variants.destructive = element.hasFlag( 'destructive' );
			variants.invert = element.hasFlag( 'invert' );
			variants.error = element.hasFlag( 'error' );
			variants.warning = element.hasFlag( 'warning' );
			variants.success = element.hasFlag( 'success' );
		}
	}

	for ( variant in variants ) {
		classes[ variants[ variant ] ? 'on' : 'off' ].push( 'oo-ui-image-' + variant );
	}

	return classes;
};

/**
 * @inheritdoc
 */
OO.ui.DyeTheme.prototype.getDialogTransitionDuration = function () {
	return 250;
};

/* Instantiation */

OO.ui.theme = new OO.ui.DyeTheme();

}( OO ) );

//# sourceMappingURL=oojs-ui-dye.js.map.json
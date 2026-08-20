<?php

/**
 * @file plugins/themes/unza/UnzaThemePlugin.inc.php
 *
 * @class UnzaThemePlugin
 * @ingroup plugins_themes_unza
 *
 * @brief UNZA Journals theme.
 *
 * A child theme of the stock OJS "default" theme. It inherits all of the
 * default theme's LESS/layout machinery and only supplies:
 *   - the UNZA green palette + component styles (styles/unza-theme.css)
 *   - template overrides for the pages/components that were customized
 *     (see templates/ in this plugin directory)
 *
 * Template overrides work automatically: OJS's theme/plugin system checks
 * for a matching file at the same relative path inside this plugin's own
 * templates/ directory before falling back to core (see
 * Plugin::_overridePluginTemplates()). No extra registration code is
 * needed for that part -- placing the file is enough.
 *
 * This plugin intentionally does NOT touch any backend search/query logic,
 * routes, or handlers -- see plugins/generic/unza for the small amount of
 * PHP data-fetching this design needs (homepage stats, Browse stats).
 */

import('lib.pkp.classes.plugins.ThemePlugin');

class UnzaThemePlugin extends ThemePlugin {

	/**
	 * @copydoc Plugin::getName()
	 */
	function getName() {
		return 'unza';
	}

	/**
	 * @copydoc Plugin::getDisplayName()
	 */
	function getDisplayName() {
		return __('plugins.themes.unza.name');
	}

	/**
	 * @copydoc Plugin::getDescription()
	 */
	function getDescription() {
		return __('plugins.themes.unza.description');
	}

	/**
	 * @copydoc ThemePlugin::init()
	 */
	public function init() {
		// Inherit all layout/LESS machinery from the stock default theme.
		$this->setParent('default');

		// UNZA palette + component styles (buttons, journal list rows,
		// browse groups, search page, etc). Loaded after the parent
		// theme's own stylesheet so it can safely override colors/spacing.
		$this->addStyle('unzaTheme', 'styles/unza-theme.css');
	}
}

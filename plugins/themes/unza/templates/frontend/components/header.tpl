{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
{strip}
	{* Determine whether a logo or title string is being displayed *}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<style>
	.pkp_structure_page {
		display: block !important;
		width: 100% !important;
		max-width: none !important;
		margin: 0 !important;
		grid-template-columns: none !important;
	}
	.pkp_structure_content,
	.pkp_structure_main {
		display: block !important;
		width: 100% !important;
		max-width: none !important;
		flex-basis: auto !important;
		margin: 0 !important;
	}
	.pkp_structure_main::before,
	.pkp_structure_main::after {
		content: none !important;
		display: none !important;
	}
	.pkp_structure_sidebar { display: none !important; width: 0 !important; float: none !important; }
.pkp_structure_head,
#headerNavigationContainer {
	width: 100% !important;
	max-width: none !important;
	margin: 0 !important;
	background: var(--unza-primary, #2D6A36) !important;
}
body { background: #fff; }
/* On desktop the nav sits inline inside the green header bar, so its rows
   stay transparent and blend in. On mobile the same elements become the
   dropdown PANEL when opened, so they need their own opaque background --
   scoping this to desktop only fixes the mobile menu rendering see-through
   / invisible over page content (see mobile block further below). */
@media (min-width: 769px) {
	.pkp_site_nav_menu,
	.pkp_navigation_primary_row,
	.pkp_navigation_primary_wrapper,
	.pkp_navigation_user_wrapper { background: transparent !important; }
}
	.pkp_site_name img { max-height: 38px !important; width: auto !important; height: auto !important; }
	.unza_logo_with_title { display: flex !important; align-items: center !important; gap: 0.9rem; }
	.unza_site_title { color: #fff; font-size: 1.2rem; font-weight: 700; white-space: nowrap; }
	@media (max-width: 600px) {
		.unza_site_title { font-size: 1rem; white-space: normal; }
	}
	.pkp_site_nav_toggle { display: none !important; }
	@media (max-width: 768px) {
		.pkp_site_nav_toggle { display: inline-flex !important; }
	}
	.pkp_navigation_primary_row { padding: 0.35rem 0 !important; }

	/* The site-name block ships as position:absolute in the base theme
	   (designed to sit beside a fixed-size hamburger square). Our header is a
	   flex row instead, so keep it in normal flow -- the leftover absolute
	   positioning was fighting the flex layout and could inflate the header's
	   effective height on mobile. */
	.pkp_site_name_wrapper { height: auto !important; }
	.pkp_site_name {
		position: static !important;
		left: auto !important;
		right: auto !important;
		padding-left: 0 !important;
		margin-top: 0 !important;
		margin-bottom: 0 !important;
	}
</style>

<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		{* Header *}
		<header class="pkp_structure_head" id="headerNavigationContainer" role="banner">
			{* Skip to content nav links *}
			{include file="frontend/components/skipLinks.tpl"}

			<div class="pkp_head_wrapper">

				<div class="pkp_site_name_wrapper">
					<button class="pkp_site_nav_toggle">
						<span>Open Menu</span>
					</button>
					{if !$requestedPage || $requestedPage === 'index'}
						<h1 class="pkp_screen_reader">
							{if $currentContext}
								{$displayPageHeaderTitle|escape}
							{else}
								{$siteTitle|escape}
							{/if}
						</h1>
					{/if}
					<div class="pkp_site_name">
					{capture assign="homeUrl"}
						{url page="index" router=$smarty.const.ROUTE_PAGE}
					{/capture}
					{if $displayPageHeaderLogo}
						<a href="{$homeUrl}" class="is_img unza_logo_with_title">
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if} />
							{if $displayPageHeaderTitle}
								<span class="unza_site_title">{$displayPageHeaderTitle|escape}</span>
							{elseif $siteTitle}
								<span class="unza_site_title">{$siteTitle|escape}</span>
							{/if}
						</a>
					{elseif $displayPageHeaderTitle}
						<a href="{$homeUrl}" class="is_text">{$displayPageHeaderTitle|escape}</a>
					{else}
						<a href="{$homeUrl}" class="is_img">
							<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" width="180" height="90" />
						</a>
					{/if}
					</div>	
				</div>

				{capture assign="primaryMenu"}
					{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
				{/capture}

				<nav class="pkp_site_nav_menu" aria-label="{translate|escape key="common.navigation.site"}">
					<a id="siteNav"></a>
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">

							{* Primary navigation menu for current application *}
							
							{$primaryMenu}


							{if !$currentJournal}
								<a href="{url page="search"}" class="pkp_nav_search_link">
									<span class="fa fa-search" aria-hidden="true"></span>
									{translate key="common.search"}
								</a>
							{/if}

							{* Search icon for individual journals *}
							{if $currentContext && $requestedPage !== 'search'}
								<div class="pkp_navigation_search_wrapper">
									<a href="{url page="search"}" class="pkp_search pkp_search_desktop">
										<span class="fa fa-search" aria-hidden="true"></span>
										{translate key="common.search"}
									</a>
								</div>
							{/if}
						</div>
					</div>
					<div class="pkp_navigation_user_wrapper" id="navigationUserWrapper">
						{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
					</div>
				</nav>
			</div><!-- .pkp_head_wrapper -->
		<style>
			.pkp_head_wrapper {
				display: flex !important;
				flex-direction: row !important;
				align-items: center !important;
				flex-wrap: wrap !important;
				padding: 0.4rem 1.5rem !important;
				row-gap: 0.25rem;
			}
			.pkp_site_name_wrapper { padding: 0 !important; margin-right: 1.5rem !important; display: flex !important; align-items: center !important; flex-shrink: 1; min-width: 0; }
			.pkp_site_name_wrapper a { display: flex; align-items: center; min-width: 0; }
			.unza_site_title { overflow: hidden; text-overflow: ellipsis; }
			@media (min-width: 769px) {
				.pkp_site_nav_menu { flex: 1 1 auto; flex-basis: auto !important; display: block !important; min-width: 0; }
			}
			@media (min-width: 769px) {
				.pkp_navigation_primary_row {
					padding: 0 !important;
					display: flex !important;
					align-items: center !important;
					justify-content: space-between;
					flex-wrap: wrap;
				}
			}
			.pkp_navigation_primary_wrapper {
				display: flex;
				flex-direction: row;
				align-items: center;
				width: auto;
				gap: 0.25rem;
			}
			.pkp_navigation_primary_wrapper ul.pkp_navigation_primary {
				display: flex;
				flex-direction: row;
				align-items: center;
				margin: 0;
				padding: 0;
				flex-shrink: 0;
			}
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li { position: relative; }
			/* Top-level items (Home, Browse, ...). Explicit color/z-index here so
			   the label can never be swallowed by its own dropdown panel opening
			   underneath it -- the anchor always paints above the panel and
			   always stays the brand white regardless of hover/open state. */
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > a {
				position: relative;
				z-index: 301;
				color: #fff !important;
			}
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li:hover > a,
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li:focus-within > a,
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li.menu_open > a {
				color: #fff !important;
				background: rgba(255,255,255,0.16);
				border-radius: 4px 4px 0 0;
			}
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul {
				display: none;
				position: absolute;
				top: 100%;
				left: 0;
				margin: 0;
				padding: 0.5rem 0 0.4rem;
				list-style: none;
				min-width: 200px;
				background: #fff;
				border: 1px solid #e2e2e2;
				border-radius: 8px;
				box-shadow: 0 10px 28px rgba(0,0,0,0.14);
				z-index: 300;
			}
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li:hover > ul,
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li:focus-within > ul {
				display: block;
			}
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li > a,
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li > a:link,
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li > a:visited {
				display: block;
				padding: 0.55rem 1.2rem;
				color: var(--unza-text, #1e2b20) !important;
				font-weight: 500;
				font-size: 0.88rem;
				white-space: nowrap;
				text-decoration: none !important;
			}
			.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li > a:hover {
				background: var(--unza-tint, #E6F4E8);
				color: var(--unza-primary, #2D6A36) !important;
			}

			/* Account/user dropdown menu */
			.pkp_navigation_user_wrapper { position: relative; }
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li { position: relative; }
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul {
				display: none;
				position: absolute;
				top: 100%;
				right: 0;
				margin: 0;
				padding: 0.5rem 0 0.4rem;
				list-style: none;
				min-width: 180px;
				background: #fff;
				border: 1px solid #e2e2e2;
				border-radius: 8px;
				box-shadow: 0 10px 28px rgba(0,0,0,0.14);
				z-index: 300;
			}
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li:hover > ul,
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li:focus-within > ul {
				display: block;
			}
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul > li > a,
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul > li > a:link,
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul > li > a:visited {
				display: block;
				padding: 0.5rem 1.1rem;
				color: var(--unza-text, #1e2b20) !important;
				font-weight: 500;
				font-size: 0.85rem;
				white-space: nowrap;
				text-decoration: none !important;
			}
			.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul > li > a:hover {
				background: var(--unza-tint, #E6F4E8);
				color: var(--unza-primary, #2D6A36) !important;
			}
			.pkp_nav_search_link {
				display: inline-flex;
				align-items: center;
				gap: 0.4rem;
				color: #fff !important;
				font-weight: 600;
				font-size: 0.88rem;
				text-decoration: none !important;
				padding: 0.4rem 0.6rem;
				margin-left: 1.5rem;
				border-radius: 6px;
				transition: background 150ms ease;
			}
			.pkp_nav_search_link:hover { background: rgba(255,255,255,0.15); }
			@media (max-width: 768px) {
				/* The mobile menu is a dropdown PANEL (position:absolute, opens
				   below the header), not an inline bar like on desktop -- it
				   needs its own opaque background or it renders see-through
				   over the page content underneath, which is why the hamburger
				   previously looked like it "did nothing" even though the menu
				   was technically open. */
				.pkp_site_nav_menu {
					background: var(--unza-primary, #2D6A36) !important;
					box-shadow: 0 10px 24px rgba(0,0,0,0.25);
					max-height: calc(100vh - 60px);
					overflow-y: auto;
					z-index: 9999;
				}
				.pkp_head_wrapper { flex-direction: column !important; flex-wrap: wrap !important; align-items: stretch; }
				.pkp_navigation_primary_wrapper {
					flex-direction: column;
					align-items: stretch;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary {
					flex-direction: column;
					align-items: stretch;
					width: 100%;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li {
					display: block;
					width: 100%;
				}
				#navigationPrimary.pkp_navigation_primary > li > a,
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > a {
					display: flex;
					align-items: center;
					justify-content: space-between;
					text-align: left !important;
					padding: 0.35rem 0;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li.has_children > a::after {
					content: '\25BE';
					font-size: 0.7rem;
					margin-left: 0.5rem;
					transition: transform 0.15s;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li.has_children.menu_open > a::after {
					transform: rotate(180deg);
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul {
					display: none;
					position: static;
					box-shadow: none;
					border: none;
					list-style: none;
					margin: 0 0 0.5rem;
					padding: 0;
					background: transparent;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li.menu_open > ul {
					display: block;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li {
					display: block;
					padding-left: 1rem;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li > a {
					display: block;
					padding: 0.45rem 0;
					font-size: 0.9em;
					/* Overrides the desktop dropdown's dark-on-white color rule --
					   on mobile the panel background is now the green brand color,
					   so submenu text (Category/Subject Area/... under Browse)
					   needs to be light to stay readable. */
					color: #fff !important;
				}
				.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li > ul > li > a:hover {
					background: rgba(255,255,255,0.12);
					color: #fff !important;
				}
				/* Top-level links keep the same white treatment as desktop; the
				   "open" highlight still applies via the shared rule above. */
				.pkp_nav_search_link { padding: 0.4rem 0; }
				.pkp_navigation_user_wrapper {
					margin-top: 0.75rem;
					padding-top: 0.75rem;
					border-top: 1px solid rgba(255,255,255,0.25);
				}
				.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul {
					position: static;
					box-shadow: none;
					border: none;
					background: transparent;
					padding: 0;
				}
				.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul > li > a {
					color: #fff !important;
					padding: 0.4rem 0;
				}
				.pkp_navigation_user_wrapper ul.pkp_navigation_user > li > ul > li > a:hover {
					background: rgba(255,255,255,0.12);
					color: #fff !important;
				}
			}
		</style>
		<script>
			document.addEventListener('DOMContentLoaded', function() {
				var topItems = document.querySelectorAll('.pkp_navigation_primary_wrapper > ul.pkp_navigation_primary > li');
				topItems.forEach(function(li) {
					var childUl = li.querySelector(':scope > ul');
					if (!childUl) return;
					li.classList.add('has_children');
					var link = li.querySelector(':scope > a');
					link.addEventListener('click', function(e) {
						if (window.innerWidth <= 768) {
							e.preventDefault();
							li.classList.toggle('menu_open');
						}
					});
				});
			});
		</script>
		</header><!-- .pkp_structure_head -->

		{* Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>

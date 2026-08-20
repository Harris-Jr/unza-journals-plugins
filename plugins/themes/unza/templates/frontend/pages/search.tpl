{**
 * templates/frontend/pages/search.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to search and view search results.
 *
 * @uses $query Value of the primary search query
 * @uses $authors Value of the authors search filter
 * @uses $dateFrom Value of the date from search filter (published after).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $dateTo Value of the date to search filter (published before).
 *  Value is a single string: YYYY-MM-DD HH:MM:SS
 * @uses $yearStart Earliest year that can be used in from/to filters
 * @uses $yearEnd Latest year that can be used in from/to filters
 *
 * NOTE: This template serves BOTH the site-wide/global search page ($currentJournal
 * is empty) and an individual journal's own search page ($currentJournal is set).
 * The UNZA redesign below applies ONLY when !$currentJournal. The journal-context
 * branch is the original, unmodified OJS markup -- left alone on purpose so that
 * per-journal search behavior/appearance is not affected by this change.
 *}
{include file="frontend/components/header.tpl" pageTitle="common.search"}

{if !$heading}
	{assign var="heading" value="h2"}
{/if}

{if !$currentJournal}
{* ======================================================================
   SITE-WIDE / GLOBAL SEARCH — UNZA redesign (AJOL-style layout)
   ====================================================================== *}
<style>
/* Scoped to .page_search_sitewide only -- never touches journal search. */
.page_search_sitewide {
	max-width: 1100px;
	margin: 0 auto;
	padding: 0.75rem 1.5rem 3rem;
	color: #1c1c1c;
}
.page_search_sitewide h1 {
	font-size: 1.55rem;
	font-weight: normal;
	letter-spacing: 0.02em;
	color: var(--unza-primary);
	margin: 0 0 1rem;
}
.page_search_sitewide .search-card {
	border: 1px solid #ddd;
	background: #fff;
	padding: 1.75rem 1.75rem 1.5rem;
	margin-bottom: 1.5rem;
}

/* Primary query field -- the dominant visual element on the page */
.page_search_sitewide .search_input { margin-bottom: 1.25rem; }
.page_search_sitewide .search_input input.query {
	width: 100%;
	box-sizing: border-box;
	padding: 0.85rem 1.25rem;
	font-size: 1.05rem;
	border: 1px solid #ccc;
	border-radius: 999px;
	color: #333;
	font-family: inherit;
}
.page_search_sitewide .search_input input.query:focus {
	outline: none;
	border-color: var(--unza-accent, #439E52);
	box-shadow: 0 0 0 3px rgba(67, 158, 82, 0.15);
}

/* Advanced filters */
.page_search_sitewide fieldset.search_advanced {
	border: none;
	margin: 0 0 1.25rem;
	padding: 0;
}
.page_search_sitewide fieldset.search_advanced legend {
	font-size: 0.78rem;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	color: #444;
	padding: 0;
	width: 100%;
}
.page_search_sitewide fieldset.search_advanced legend::after {
	content: "";
	display: block;
	border-bottom: 1px solid #ddd;
	margin-top: 0.6rem;
	margin-bottom: 1.1rem;
}
.page_search_sitewide .filters-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	gap: 1.25rem 1.5rem;
}
.page_search_sitewide .filters-grid .field label {
	display: block;
	font-size: 0.82rem;
	font-weight: 600;
	color: #444;
	margin-bottom: 0.4rem;
}
.page_search_sitewide .filters-grid .field input[type="text"] {
	width: 100%;
	box-sizing: border-box;
	padding: 0.55rem 0.9rem;
	font-size: 0.9rem;
	border: 1px solid #ccc;
	border-radius: 999px;
	color: #333;
	font-family: inherit;
}
.page_search_sitewide .filters-grid .field input[type="text"]:focus {
	outline: none;
	border-color: var(--unza-accent, #439E52);
	box-shadow: 0 0 0 3px rgba(67, 158, 82, 0.15);
}
.page_search_sitewide .date_range { display: flex; gap: 1.5rem; flex-wrap: wrap; }
.page_search_sitewide .date_range .from,
.page_search_sitewide .date_range .to { flex: 1 1 200px; }
.page_search_sitewide .date_range legend { font-size: 0.82rem; font-weight: 600; color: #444; padding: 0; }
.page_search_sitewide .date_range select {
	font-size: 0.85rem;
	padding: 0.4rem 0.5rem;
	border: 1px solid #ccc;
	border-radius: 4px;
	color: #333;
	font-family: inherit;
	margin: 0.3rem 0.3rem 0 0;
}

/* Search button -- professional, no emoji/icon-font glyphs; a plain inline
   SVG magnifier + label, in the UNZA green. */
.page_search_sitewide .submit {
	display: flex;
	justify-content: flex-end;
	margin-top: 1.5rem;
}
.page_search_sitewide .submit button.submit {
	display: inline-flex;
	align-items: center;
	gap: 0.55rem;
	background: var(--unza-primary);
	color: #fff;
	border: none;
	font-weight: 700;
	font-size: 0.85rem;
	letter-spacing: 0.04em;
	text-transform: uppercase;
	padding: 0.75rem 2rem;
	border-radius: 6px;
	cursor: pointer;
	transition: background 180ms ease;
	font-family: inherit;
}
.page_search_sitewide .submit button.submit:hover { background: var(--unza-accent, #439E52); }
.page_search_sitewide .submit button.submit svg { width: 16px; height: 16px; flex-shrink: 0; }
/* The base theme's .cmp_button_icon_left mixin (applied via .page_search
   .submit button in core CSS) injects its own Font-Awesome search glyph as
   an absolutely-positioned ::after box in the theme's default blue -- that's
   the second "icon" that was showing up next to our own SVG+label button.
   Strip it out here rather than in core, and undo the padding/border-split
   the mixin reserved for it. */
.page_search_sitewide .submit button.submit::before,
.page_search_sitewide .submit button.submit::after {
	content: none !important;
	display: none !important;
}
.page_search_sitewide .submit button.submit {
	padding: 0.75rem 2rem !important;
	border: none !important;
	box-shadow: none !important;
}

/* Results toolbar */
.page_search_sitewide .results-toolbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: 0.75rem;
	border: 1px solid #ddd;
	background: #f5f5f3;
	padding: 0.9rem 1.5rem;
	margin-bottom: 1.5rem;
}
.page_search_sitewide .results-toolbar .result-count {
	font-size: 0.92rem;
	color: #333;
}
.page_search_sitewide .results-toolbar .result-count strong { color: var(--unza-primary); }
.page_search_sitewide .results-order {
	display: flex;
	align-items: center;
	gap: 0.6rem;
	flex-wrap: nowrap;
	flex-shrink: 0;
	font-size: 0.82rem;
	color: #555;
}
.page_search_sitewide .results-order span { white-space: nowrap; }
.page_search_sitewide .results-order select {
	font-size: 0.82rem;
	padding: 0.4rem 0.6rem;
	border: 1px solid #ccc;
	border-radius: 4px;
	color: #333;
	font-family: inherit;
	background: #fff;
	flex-shrink: 0;
}

/* Results list */
.page_search_sitewide ul.search_results { list-style: none; margin: 0 0 1.5rem; padding: 0; }
.page_search_sitewide ul.search_results > li {
	padding: 1.1rem 0;
	border-bottom: 1px solid #eee;
}
.page_search_sitewide ul.search_results > li:first-child { border-top: 1px solid #eee; }

.page_search_sitewide .cmp_pagination { margin-bottom: 2rem; }

/* Search tips */
.page_search_sitewide .search-tips {
	border: 1px dashed #ccc;
	background: #fafafa;
	padding: 1.5rem 1.75rem;
	font-size: 0.85rem;
	color: #444;
}
.page_search_sitewide .search-tips h2 {
	font-size: 0.95rem;
	font-weight: 700;
	color: var(--unza-primary);
	margin: 0 0 0.75rem;
}
.page_search_sitewide .search-tips ul { margin: 0; padding-left: 1.2rem; }
.page_search_sitewide .search-tips li { margin-bottom: 0.4rem; line-height: 1.5; }
.page_search_sitewide .search-tips em { font-style: italic; }
.page_search_sitewide .search-tips strong { font-weight: 700; }

@media (max-width: 640px) {
	.page_search_sitewide { padding: 0.5rem 1rem 2rem; }
	.page_search_sitewide .search-card { padding: 1.25rem 1.1rem; }
	.page_search_sitewide .submit { justify-content: stretch; }
	.page_search_sitewide .submit button.submit { width: 100%; justify-content: center; }
	.page_search_sitewide .results-toolbar { flex-direction: column; align-items: flex-start; }
	.page_search_sitewide .results-order { width: 100%; justify-content: space-between; }
}
</style>

<div class="page page_search page_search_sitewide">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.search"}
	<h1>{translate key="common.search"}</h1>

	{capture name="searchFormUrl"}{url escape=false}{/capture}
	{assign var=formUrlParameters value=[]}
	{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$formUrlParameters}

	<div class="search-card">
		<form class="cmp_form" id="searchForm" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}">
			{foreach from=$formUrlParameters key=paramKey item=paramValue}
				{if $paramKey != 'orderBy' && $paramKey != 'orderDir'}
					<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
				{/if}
			{/foreach}

			<input type="hidden" name="resultsPerPage" value="{$itemsPerPage|default:20}">

			<div class="search_input">
				<label class="pkp_screen_reader" for="query">{translate key="search.searchFor"}</label>
				{block name=searchQuery}
					<input type="text" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="common.search"} scholarly content...">
				{/block}
			</div>

			<fieldset class="search_advanced">
				<legend>{translate key="search.advancedFilters"}</legend>

				<div class="filters-grid">
					<div class="field">
						<label class="label" for="authors">{translate key="search.author"}</label>
						{block name=searchAuthors}
							<input type="text" id="authors" name="authors" value="{$authors|escape}" placeholder="{translate|escape key="search.author"}...">
						{/block}
					</div>

					{if $searchJournal}
						<div class="field date_range">
							<div class="from">
								{capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
								{html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
							</div>
							<div class="to">
								{capture assign="dateToLegend"}{translate key="search.dateTo"}{/capture}
								{html_select_date_a11y legend=$dateToLegend prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
							</div>
						</div>
					{/if}

					{call_hook name="Templates::Search::SearchResults::AdditionalFilters"}
				</div>
			</fieldset>

			<div class="submit">
				<button class="submit" type="submit">
					<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
					{translate key="common.search"}
				</button>
			</div>

			{call_hook name="Templates::Search::SearchResults::PreResults"}

			<h2 class="pkp_screen_reader">{translate key="search.searchResults"}</h2>

			{* Results pagination (screen-reader status) *}
			{if !$results->wasEmpty()}
				{assign var="count" value=$results->count}
				<div class="pkp_screen_reader" role="status">
					{if $results->count > 1}
						{translate key="search.searchResults.foundPlural" count=$results->count}
					{else}
						{translate key="search.searchResults.foundSingle"}
					{/if}
				</div>
			{/if}

			{* Visible results toolbar: count + order-by (auto-submits the form) *}
			<div class="results-toolbar">
				<div class="result-count">
					{if $results->wasEmpty()}
						{translate key="search.noResults"}
					{elseif $query}
						<strong>{$results->count}</strong> {if $results->count == 1}result{else}results{/if} found for &ldquo;{$query|escape}&rdquo;
					{else}
						<strong>{$results->count}</strong> {if $results->count == 1}result{else}results{/if} found
					{/if}
				</div>
				{if !$results->wasEmpty()}
					<div class="results-order">
						<span>{translate key="search.results.orderBy"}:</span>
						<select name="orderBy" onchange="this.form.submit()">
							{html_options options=$searchResultOrderOptions selected=$orderBy}
						</select>
						<select name="orderDir" onchange="this.form.submit()">
							{html_options options=$searchResultOrderDirOptions selected=$orderDir}
						</select>
					</div>
				{/if}
			</div>
		</form>
	</div>

	{* Search results *}
	{if !$results->wasEmpty()}
		<ul class="search_results">
			{iterate from=results item=result}
				<li>
					{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
				</li>
			{/iterate}
		</ul>

		<div class="cmp_pagination">
			{page_info iterator=$results}
			{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear}
		</div>
	{else}
		<span role="status">
			{if $error}
				{include file="frontend/components/notification.tpl" type="error" message=$error|escape}
			{/if}
		</span>
	{/if}

	{* Search tips -- reuses the existing, already-accurate OJS search syntax
	   help string (search.syntaxInstructions); nothing new is claimed here. *}
	<div class="search-tips">
		{translate key="search.syntaxInstructions"}
	</div>

</div><!-- .page -->

{else}
{* ======================================================================
   JOURNAL-CONTEXT SEARCH — untouched original markup.
   ====================================================================== *}
<div class="page page_search">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="common.search"}
	<h1>{translate key="common.search"}</h1>

	{capture name="searchFormUrl"}{url escape=false}{/capture}
	{assign var=formUrlParameters value=[]}
	{$smarty.capture.searchFormUrl|parse_url:$smarty.const.PHP_URL_QUERY|default:""|parse_str:$formUrlParameters}

	<form class="cmp_form" id="searchForm" method="get" action="{$smarty.capture.searchFormUrl|strtok:"?"|escape}">
		{foreach from=$formUrlParameters key=paramKey item=paramValue}
			<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}"/>
		{/foreach}

		{* ordering / paging helpers *}
		<input type="hidden" name="orderBy"        value="{$orderBy|default:'score'}">
		<input type="hidden" name="orderDir"       value="{$orderDir|default:'DESC'}">
		<input type="hidden" name="resultsPerPage" value="{$itemsPerPage|default:20}">

		<div class="search_input">
			<label class="pkp_screen_reader" for="query">{translate key="search.searchFor"}</label>
			{block name=searchQuery}
				<input type="text" id="query" name="query" value="{$query|escape}" class="query" placeholder="{translate|escape key="common.search"}">
			{/block}
		</div>

		<fieldset class="search_advanced">
			<legend>{translate key="search.advancedFilters"}</legend>

			{if $searchJournal}
				<div class="date_range">
					<div class="from">
						{capture assign="dateFromLegend"}{translate key="search.dateFrom"}{/capture}
						{html_select_date_a11y legend=$dateFromLegend prefix="dateFrom" time=$dateFrom start_year=$yearStart end_year=$yearEnd}
					</div>
					<div class="to">
						{capture assign="dateToLegend"}{translate key="search.dateTo"}{/capture}
						{html_select_date_a11y legend=$dateToLegend prefix="dateTo" time=$dateTo start_year=$yearStart end_year=$yearEnd}
					</div>
				</div>
			{/if}

			<div class="author">
				<label class="label" for="authors">{translate key="search.author"}</label>
				{block name=searchAuthors}
					<input type="text" id="authors" name="authors" value="{$authors|escape}">
				{/block}
			</div>
			{call_hook name="Templates::Search::SearchResults::AdditionalFilters"}
		</fieldset>

		<div class="submit">
			<button class="submit" type="submit">{translate key="common.search"}</button>
		</div>
	</form>

	{call_hook name="Templates::Search::SearchResults::PreResults"}

	<h2 class="pkp_screen_reader">{translate key="search.searchResults"}</h2>

	{* Results pagination *}
	{if !$results->wasEmpty()}
		{assign var="count" value=$results->count}
		<div class="pkp_screen_reader" role="status">
			{if $results->count > 1}
				{translate key="search.searchResults.foundPlural" count=$results->count}
			{else}
				{translate key="search.searchResults.foundSingle"}
			{/if}
		</div>
	{/if}

	{* Search results *}
	<ul class="search_results">
		{iterate from=results item=result}
			<li>
				{include file="frontend/objects/article_summary.tpl" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true heading="h3"}
			</li>
		{/iterate}
	</ul>

	{* No results *}
	{if $results->wasEmpty()}
		<span role="status">
			{if $error}
				{include file="frontend/components/notification.tpl" type="error" message=$error|escape}
			{else}
				{include file="frontend/components/notification.tpl" type="notice" messageKey="search.noResults"}
			{/if}
		</span>
	{else}
		<div class="cmp_pagination">
			{page_info iterator=$results}
			{page_links anchor="results" iterator=$results name="search" query=$query searchJournal=$searchJournal authors=$authors dateFromMonth=$dateFromMonth dateFromDay=$dateFromDay dateFromYear=$dateFromYear dateToMonth=$dateToMonth dateToDay=$dateToDay dateToYear=$dateToYear}
		</div>
	{/if}

	{block name=searchSyntaxInstructions}{/block}
</div><!-- .page -->
{/if}

{include file="frontend/components/footer.tpl"}

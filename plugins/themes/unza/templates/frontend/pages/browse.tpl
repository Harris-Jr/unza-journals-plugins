{include file="frontend/components/header.tpl" pageTitle=$pageTitle}


<style>
/* ── Browse Scholarly Content ───────────────────────────────────── */
.pkp_page_browse .pkp_structure_main { padding-top: 0 !important; }
.browse-wrap {
  max-width: 1300px;
  margin: 0 auto;
  padding: 0.75rem 1.5rem 3rem;
  color: #1c1c1c;
}
.browse-wrap h1 {
  font-size: 1.55rem;
  font-weight: normal;
  letter-spacing: 0.02em;
  color: var(--unza-primary);
  border-bottom: 2px solid var(--unza-primary);
  padding-bottom: 0.45rem;
  margin-top: 0;
  margin-bottom: 1rem;
}

/* ── Tab navigation ─────────────────────────────────────────────── */
.browse-nav {
  display: flex;
  flex-wrap: nowrap;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  border-bottom: 1px solid #ddd;
  margin-bottom: 1.5rem;
  gap: 0;
}
.browse-nav a {
  display: inline-block;
  flex-shrink: 0;
  padding: 0.6rem 1.1rem;
  font-size: 0.82rem;
  font-weight: 500;
  letter-spacing: 0.02em;
  color: #555;
  text-decoration: none;
  border-bottom: 3px solid transparent;
  margin-bottom: -1px;
  transition: color 150ms ease, border-color 150ms ease;
  white-space: nowrap;
}
.browse-nav a:hover { color: var(--unza-primary); border-bottom-color: var(--unza-tint, #E6F4E8); }
.browse-nav a.current { color: var(--unza-primary); font-weight: 700; border-bottom-color: var(--unza-primary); }

/* ── Platform statistics ────────────────────────────────────────── */
.platform-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 0;
  border: 1px solid #ccc;
  margin-bottom: 1.5rem;
}
.platform-stats .stat {
  flex: 1 1 160px;
  text-align: center;
  padding: 1.5rem 1rem;
  border-right: 1px solid #ccc;
}
.platform-stats .stat:last-child { border-right: none; }
.platform-stats .stat-number {
  display: block;
  font-size: 2.2rem;
  font-weight: bold;
  color: var(--unza-primary);
  line-height: 1;
  margin-bottom: 0.35rem;
}
.platform-stats .stat-label {
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.09em;
  color: #777;
}

/* ── Quick browse links ─────────────────────────────────────────── */
.browse-quick { margin-top: 1.5rem; }
.browse-quick h2 {
  font-size: 0.82rem;
  font-weight: bold;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #444;
  margin-bottom: 0.75rem;
}
.browse-quick ul {
  list-style: none;
  padding: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
.browse-quick ul li a {
  display: inline-block;
  padding: 0.38rem 1rem;
  border: 1px solid var(--unza-primary);
  color: var(--unza-primary);
  font-size: 0.82rem;
  text-decoration: none;
}
.browse-quick ul li a:hover { background: var(--unza-primary); color: #fff; }

/* ── In-Browse controls: search + page-size ─────────────────────── */
.browse-controls {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
  margin-bottom: 1rem;
}
.browse-search {
  position: relative;
  flex: 1 1 320px;
  max-width: 420px;
}
.browse-search input[type="search"] {
  width: 100%;
  box-sizing: border-box;
  padding: 0.55rem 2.2rem 0.55rem 0.9rem;
  font-size: 0.88rem;
  border: 1px solid #ccc;
  border-radius: 3px;
  color: #333;
  font-family: inherit;
}
.browse-search input[type="search"]:focus {
  outline: none;
  border-color: var(--unza-accent, #439E52);
  box-shadow: 0 0 0 3px rgba(67, 158, 82, 0.15);
}
.browse-search .search-icon {
  position: absolute;
  right: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  width: 16px;
  height: 16px;
  pointer-events: none;
  color: #999;
}
.browse-search .clear-btn {
  position: absolute;
  right: 0.6rem;
  top: 50%;
  transform: translateY(-50%);
  border: none;
  background: none;
  color: #999;
  font-size: 1.1rem;
  line-height: 1;
  cursor: pointer;
  display: none;
  padding: 0.15rem;
}
.browse-search.has-value .search-icon { display: none; }
.browse-search.has-value .clear-btn { display: block; }

.browse-pagesize {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.8rem;
  color: #666;
  margin-left: auto;
}
.browse-pagesize select {
  font-size: 0.8rem;
  padding: 0.35rem 0.5rem;
  border: 1px solid #ccc;
  border-radius: 3px;
  color: #333;
  font-family: inherit;
  background: #fff;
}

/* Type-ahead dropdown */
.browse-typeahead {
  position: absolute;
  top: calc(100% + 4px);
  left: 0;
  right: 0;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 3px;
  box-shadow: 0 4px 14px rgba(0,0,0,0.12);
  max-height: 260px;
  overflow-y: auto;
  z-index: 20;
  display: none;
}
.browse-typeahead.open { display: block; }
.browse-typeahead button {
  display: block;
  width: 100%;
  text-align: left;
  padding: 0.5rem 0.9rem;
  border: none;
  background: none;
  font-size: 0.84rem;
  color: #333;
  cursor: pointer;
  border-bottom: 1px solid #f0f0f0;
  font-family: inherit;
}
.browse-typeahead button:last-child { border-bottom: none; }
.browse-typeahead button:hover,
.browse-typeahead button.active { background: var(--unza-tint, #E6F4E8); color: var(--unza-primary); }
.browse-typeahead button .ta-count { float: right; color: #999; font-size: 0.76rem; }

/* ── Alphabetical index bar ─────────────────────────────────────── */
.alpha-bar {
  display: flex;
  flex-wrap: nowrap;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  gap: 0.18rem;
  padding: 0.75rem 0;
  border-top: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  margin-bottom: 1.5rem;
}
.alpha-bar button {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 2rem;
  height: 2rem;
  padding: 0 0.5rem;
  font-family: Arial, Helvetica, sans-serif;
  font-size: 0.82rem;
  font-weight: bold;
  text-decoration: none;
  cursor: pointer;
  color: var(--unza-primary);
  background: #fff;
  border: 1px solid var(--unza-primary);
  border-radius: 2px;
}
.alpha-bar button:hover { background: var(--unza-tint, #E6F4E8); }
.alpha-bar button.active { background: var(--unza-primary); color: #fff; }
.alpha-bar button.is-empty { color: #ccc; border-color: #e8e8e8; cursor: default; }
.alpha-bar button.is-empty:hover { background: #fff; }
.alpha-bar button.all-btn { font-weight: bold; }

/* ── Results summary ────────────────────────────────────────────── */
.browse-summary {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  flex-wrap: wrap;
  gap: 0.35rem 1rem;
  font-size: 0.8rem;
  color: #777;
  margin-bottom: 1rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #eee;
}
.browse-summary .browse-count-total {
  font-weight: 600;
  color: #444;
}
.browse-summary .browse-count-total strong {
  color: var(--unza-primary);
}

/* ── Collapsible groups ─────────────────────────────────────────── */
.browse-group {
  border: 1px solid #ddd;
  margin-bottom: 4px;
}
.browse-group summary {
  padding: 0.7rem 1rem;
  font-size: 0.88rem;
  font-weight: bold;
  color: var(--unza-primary);
  cursor: pointer;
  list-style: none;
  display: flex;
  align-items: center;
  background: #f5f5f3;
  user-select: none;
}
.browse-group summary::-webkit-details-marker { display: none; }
.browse-group summary .group-name {
  flex: 1 1 auto;
  min-width: 0;
  overflow-wrap: break-word;
  padding-right: 0.75rem;
}
.browse-group summary .group-right {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 0.6rem;
  margin-left: auto;
}
.browse-group .group-count {
  font-size: 0.75rem;
  font-weight: normal;
  color: #888;
  white-space: nowrap;
}
.browse-group .group-toggle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 1.4rem;
  height: 1.4rem;
  font-size: 1.05rem;
  font-weight: normal;
  color: #999;
  border: 1px solid #ccc;
  border-radius: 2px;
  background: #fff;
}
.browse-group .group-toggle::after { content: '+'; }
.browse-group[open] > summary { background: #eef0f5; }
.browse-group[open] > summary .group-toggle::after { content: '\2212'; }
.browse-group[hidden] { display: none; }

/* ── Entry list ─────────────────────────────────────────────────── */
.browse-entries { padding: 0; }
.browse-entry {
  padding: 0.85rem 1rem 0.85rem 1.2rem;
  border-top: 1px solid #eee;
}
.browse-entry:first-child { border-top: none; }
.entry-title a {
  font-size: 0.95rem;
  font-style: italic;
  color: var(--unza-primary);
  text-decoration: none;
}
.entry-title a:hover { text-decoration: underline; }
.entry-meta {
  font-size: 0.78rem;
  color: #666;
  margin-top: 0.25rem;
  line-height: 1.5;
}
.entry-meta .e-authors { color: #333; }
.entry-meta .e-journal { font-style: italic; color: #555; }
.entry-meta .e-year { color: #888; }
.entry-meta .sep { margin: 0 0.3em; color: #bbb; }
.browse-entry.extra-entry { display: none; }
.browse-entry.extra-entry.shown { display: block; }

.view-all-row {
  padding: 0.65rem 1rem 0.85rem 1.2rem;
  border-top: 1px solid #eee;
}
.view-all-btn {
  display: inline-block;
  border: none;
  background: none;
  padding: 0;
  font-size: 0.82rem;
  font-weight: 600;
  color: var(--unza-primary);
  cursor: pointer;
  font-family: inherit;
}
.view-all-btn:hover { text-decoration: underline; }

/* ── Journal entries ────────────────────────────────────────────── */
.journal-entry a {
  font-size: 0.95rem;
  color: var(--unza-primary);
  text-decoration: none;
}
.journal-entry a:hover { text-decoration: underline; }

/* ── Pagination ──────────────────────────────────────────────────── */
.browse-pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: 0.3rem;
  margin-top: 1.5rem;
}
.browse-pagination button {
  min-width: 2.1rem;
  height: 2.1rem;
  padding: 0 0.5rem;
  font-size: 0.82rem;
  border: 1px solid #ccc;
  background: #fff;
  color: #444;
  border-radius: 2px;
  cursor: pointer;
  font-family: inherit;
}
.browse-pagination button:hover:not(:disabled) { border-color: var(--unza-primary); color: var(--unza-primary); }
.browse-pagination button.active { background: var(--unza-primary); border-color: var(--unza-primary); color: #fff; font-weight: bold; }
.browse-pagination button:disabled { opacity: 0.4; cursor: default; }
.browse-pagination .pg-ellipsis { padding: 0 0.35rem; color: #999; font-size: 0.82rem; }

/* ── Empty state ─────────────────────────────────────────────────── */
.browse-empty {
  display: none;
  text-align: center;
  padding: 3rem 1.5rem;
  border: 1px dashed #ccc;
  background: #fafafa;
  color: #666;
}
.browse-empty.show { display: block; }
.browse-empty .empty-title {
  font-size: 1rem;
  font-weight: 700;
  color: var(--unza-primary);
  margin-bottom: 0.4rem;
}
.browse-empty .empty-sub { font-size: 0.85rem; margin-bottom: 0.3rem; }
.browse-empty .empty-hint { font-size: 0.8rem; color: #888; }

/* Never let a hidden/collapsed element reserve layout space — the mobile
   "big gap" bug traced to elements that are visually empty (0 children,
   no text) but still had padding/border applied, e.g. the type-ahead
   dropdown and the empty-state box before JS toggles their visible class. */
.browse-typeahead:not(.open) { display: none !important; height: 0 !important; padding: 0 !important; border: 0 !important; }
.browse-empty:not(.show) { display: none !important; height: 0 !important; padding: 0 !important; border: 0 !important; margin: 0 !important; }

@media (max-width: 768px) {
  .browse-wrap { padding: 0.5rem 1rem 2rem; }
  .browse-nav a { padding: 0.5rem 0.7rem; font-size: 0.7rem; }
  .platform-stats { flex-direction: column; }
  .platform-stats .stat { border-right: none; border-bottom: 1px solid #ccc; padding: 1.1rem 1rem; }
  .platform-stats .stat:last-child { border-bottom: none; }
  .platform-stats .stat-number { font-size: 1.8rem; }

  /* Controls stack full-width with tight, consistent spacing — no element
     here should carry leftover desktop margin/height. */
  .browse-controls { flex-direction: column; align-items: stretch; gap: 0.6rem; margin-bottom: 0.75rem; }
  .browse-search { max-width: none; flex-basis: auto; }
  .browse-pagesize { margin-left: 0; justify-content: space-between; }
  .browse-typeahead { position: absolute; }

  .alpha-bar { margin-bottom: 1rem; padding: 0.6rem 0; }
  .alpha-bar button { min-width: 1.7rem; height: 1.7rem; font-size: 0.75rem; }

  .browse-summary { margin-bottom: 0.75rem; flex-direction: column; align-items: flex-start; gap: 0.15rem; }

  /* Groups wrapper must be plain block flow on mobile — guards against any
     inherited flex/grid context giving it stretched/auto-sized empty rows. */
  #browseGroupsWrap { display: block; min-height: 0; }
  .browse-group { min-height: 0; }
}
</style>

<div class="browse-wrap">

  <h1>Browse Scholarly Content</h1>

  <nav class="browse-nav" aria-label="Browse by">
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='index'}"       class="{if $browseMode=='browse' || $browseMode=='index'}current{/if}">Overview</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='category'}"    class="{if $browseMode=='category'}current{/if}">By Category</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='subject'}"     class="{if $browseMode=='subject'}current{/if}">By Subject</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='journals'}"    class="{if $browseMode=='journals'}current{/if}">By Journal</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='title'}"       class="{if $browseMode=='title'}current{/if}">By Title</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='keyword'}"     class="{if $browseMode=='keyword'}current{/if}">By Keyword</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='affiliation'}" class="{if $browseMode=='affiliation'}current{/if}">By Affiliation</a>
    <a href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='year'}"        class="{if $browseMode=='year'}current{/if}">By Year</a>
  </nav>

  {* ── Overview / home ─────────────────────────────────────────── *}
  {if $browseMode == 'browse' || $browseMode == 'index'}

    <div class="platform-stats">
      <div class="stat">
        <span class="stat-number">{$totalJournals}</span>
        <span class="stat-label">Journals</span>
      </div>
      <div class="stat">
        <span class="stat-number">{$totalPublished}</span>
        <span class="stat-label">Published Articles</span>
      </div>
      <div class="stat">
        <span class="stat-number">{$totalAuthors}</span>
        <span class="stat-label">Distinct Authors</span>
      </div>
    </div>

  {* ── All other browse modes ──────────────────────────────────── *}
  {else}

    {* Whether this mode gets pagination + A-Z (all except Category, which is
       short and stays a simple unpaginated list per spec). Search applies to
       every mode. *}
    {assign var=pagedModes value=["subject","journals","title","keyword","affiliation","year"]}
    {assign var=isPaged value=false}
    {foreach from=$pagedModes item=pm}{if $pm == $browseMode}{assign var=isPaged value=true}{/if}{/foreach}

    {* A-Z only makes sense for alphabetical lists — Year is numeric, so it
       gets pagination/search like the others but never the letter bar. *}
    {assign var=alphaModes value=["subject","journals","title","keyword","affiliation"]}
    {assign var=showAlpha value=false}
    {foreach from=$alphaModes item=am}{if $am == $browseMode}{assign var=showAlpha value=true}{/if}{/foreach}

    <div class="browse-controls" data-browse-controls>
      <div class="browse-search">
        <input type="search" id="browseSearchInput" placeholder="Search {$browseNoun}..." autocomplete="off">
        <svg class="search-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        <button type="button" class="clear-btn" id="browseSearchClear" aria-label="Clear search">&times;</button>
        <div class="browse-typeahead" id="browseTypeahead"></div>
      </div>
      {if $isPaged}
        <div class="browse-pagesize">
          <label for="browsePageSize">Show:</label>
          <select id="browsePageSize">
            <option value="10">10</option>
            <option value="25">25</option>
            <option value="50">50</option>
          </select>
        </div>
      {/if}
    </div>

    {if $showAlpha}
      <nav class="alpha-bar" id="browseAlphaBar" aria-label="Filter by letter">
        <button type="button" class="all-btn active" data-letter="All">All</button>
        {foreach from=["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"] item=letter}
          <button type="button" data-letter="{$letter}">{$letter}</button>
        {/foreach}
      </nav>
    {/if}

    {* Results summary *}
    <p class="browse-summary">
      <span class="browse-count-total"><strong id="browseTotalCount">{$buckets|@count}</strong> {$browseNoun}</span>
      <span id="browseShowingText"></span>
    </p>

    {* Empty state (hidden until JS shows it after a no-match search/filter) *}
    <div class="browse-empty" id="browseEmptyState">
      <div class="empty-title">No {$browseNoun} found</div>
      <div class="empty-sub">We couldn't find any {$browseNoun} matching &ldquo;<span id="browseEmptyQuery"></span>&rdquo;.</div>
      <div class="empty-hint">Try another term{if $showAlpha} or browse using A&ndash;Z{/if}.</div>
    </div>

    {* Groups *}
    <div id="browseGroupsWrap">
      {foreach from=$buckets key=group item=list}
        {assign var=groupCount value=$list|@count}
        <details class="browse-group" data-label="{$group|escape:'html'|lower}">

          <summary>
            <span class="group-name">{$group|escape}</span>
            <span class="group-right">
              <span class="group-count">{$groupCount} {if $groupCount == 1}item{else}items{/if}</span>
              <span class="group-toggle"></span>
            </span>
          </summary>

          <div class="browse-entries{if $browseMode == 'journals'} journal-list-styled{/if}">
            {foreach from=$list item=item name=entryLoop}

              {if $item.type == 'journal'}
                {assign var=j value=$item.journal}
                {capture assign="jurl"}{url journal=$j->getPath()}{/capture}
                {assign var=jthumb value=$j->getLocalizedData('journalThumbnail')}
                {assign var=jdesc value=$j->getLocalizedDescription()}
                <div class="journal-row{if $smarty.foreach.entryLoop.index >= 5} extra-entry{/if}">
                  {if $jthumb}
                    <div class="thumb">
                      <a href="{$jurl|escape}">
                        <img src="{$journalFilesPath}{$j->getId()}/{$jthumb.uploadName|escape:"url"}"{if $jthumb.altText} alt="{$jthumb.altText|escape|default:''}"{/if}>
                      </a>
                    </div>
                  {/if}
                  <div class="body">
                    <h3><a href="{$jurl|escape}" rel="bookmark">{$j->getLocalizedName()|escape}</a></h3>
                    {if $jdesc}
                      <div class="description">{$jdesc}</div>
                    {/if}
                    <ul class="links">
                      <li class="view"><a href="{$jurl|escape}">{translate key="site.journalView"}</a></li>
                      <li class="current"><a href="{url|escape journal=$j->getPath() page="issue" op="current"}">{translate key="site.journalCurrent"}</a></li>
                    </ul>
                  </div>
                </div>

              {else}
                {assign var=sub value=$item.submission}
                {assign var=jrnl value=$item.journal}
                {assign var=pub value=$sub->getCurrentPublication()}

                <div class="browse-entry{if $smarty.foreach.entryLoop.index >= 5} extra-entry{/if}">
                  <div class="entry-title">
                    <a href="{url journal=$item.journalPath page='article' op='view' path=$sub->getBestId()}">
                      {$pub->getLocalizedTitle()|escape}
                    </a>
                  </div>
                  <div class="entry-meta">
                    {assign var=eAuthors value=$pub->getData('authors')}
                    {if !$eAuthors}{assign var=eAuthors value=$pub->getAuthors()}{/if}
                    {if $eAuthors}
                      <span class="e-authors">
                        {foreach from=$eAuthors item=eAuthor name=eal}
                          {if is_object($eAuthor)}{$eAuthor->getFullName()|escape}{else}{$eAuthor.name|escape}{/if}{if !$eAuthor@last}; {/if}
                        {/foreach}
                      </span>
                    {/if}
                    {if $jrnl}
                      <span class="sep">&mdash;</span>
                      <span class="e-journal">{$jrnl->getLocalizedName()|escape}</span>
                    {/if}
                    {if $pub->getData('datePublished')}
                      <span class="sep">&middot;</span>
                      <span class="e-year">{$pub->getData('datePublished')|substr:0:4}</span>
                    {/if}
                  </div>
                </div>
              {/if}

            {/foreach}
          </div>

          {if $groupCount > 5}
            <div class="view-all-row">
              <button type="button" class="view-all-btn" data-view-all>View all {$groupCount} &rarr;</button>
            </div>
          {/if}
        </details>

      {foreachelse}
        <p style="font-family:Arial,sans-serif;color:#888;">{translate key="browse.none"}</p>
      {/foreach}
    </div>

    {if $isPaged}
      <nav class="browse-pagination" id="browsePagination" aria-label="Pagination"></nav>
    {/if}

    <script>
    (function() {
      var mode = {$browseMode|json_encode};
      var noun = {$browseNoun|json_encode};
      var isPaged = {if $isPaged}true{else}false{/if};

      var wrap = document.getElementById('browseGroupsWrap');
      if (!wrap) return;
      var allGroups = Array.prototype.slice.call(wrap.querySelectorAll(':scope > .browse-group'));

      var searchInput = document.getElementById('browseSearchInput');
      var clearBtn = document.getElementById('browseSearchClear');
      var searchWrapEl = searchInput ? searchInput.closest('.browse-search') : null;
      var typeahead = document.getElementById('browseTypeahead');
      var alphaBar = document.getElementById('browseAlphaBar');
      var pageSizeSel = document.getElementById('browsePageSize');
      var paginationEl = document.getElementById('browsePagination');
      var summaryTotal = document.getElementById('browseTotalCount');
      var showingText = document.getElementById('browseShowingText');
      var emptyState = document.getElementById('browseEmptyState');
      var emptyQuery = document.getElementById('browseEmptyQuery');

      var state = { query: '', letter: 'All', page: 1, pageSize: isPaged ? (pageSizeSel ? parseInt(pageSizeSel.value, 10) : 10) : allGroups.length || 1 };

      function norm(s) { return (s || '').toLowerCase().trim(); }

      // Grey out A-Z letters with no matching group (computed once, static data set)
      if (alphaBar) {
        var present = {};
        allGroups.forEach(function(g) {
          var l = norm(g.getAttribute('data-label')).charAt(0).toUpperCase();
          if (!/[A-Z]/.test(l)) l = '#';
          present[l] = true;
        });
        Array.prototype.slice.call(alphaBar.querySelectorAll('button[data-letter]')).forEach(function(btn) {
          var letter = btn.getAttribute('data-letter');
          if (letter !== 'All' && !present[letter]) {
            btn.classList.add('is-empty');
          }
        });
      }

      function getFiltered() {
        var q = norm(state.query);
        return allGroups.filter(function(g) {
          var label = norm(g.getAttribute('data-label'));
          if (state.letter !== 'All') {
            var first = label.charAt(0).toUpperCase();
            if (!/[A-Z]/.test(first)) first = '#';
            if (first !== state.letter) return false;
          }
          if (q && label.indexOf(q) === -1) return false;
          return true;
        });
      }

      function render() {
        var filtered = getFiltered();
        var total = filtered.length;
        var pageSize = state.pageSize || total || 1;
        var totalPages = Math.max(1, Math.ceil(total / pageSize));
        if (state.page > totalPages) state.page = totalPages;
        if (state.page < 1) state.page = 1;

        var start = (state.page - 1) * pageSize;
        var end = Math.min(start + pageSize, total);
        var visible = filtered.slice(start, end);

        allGroups.forEach(function(g) { g.hidden = true; });
        visible.forEach(function(g) { g.hidden = false; });

        if (summaryTotal) summaryTotal.textContent = total;
        if (showingText) {
          showingText.textContent = total === 0 ? '' :
            (isPaged ? ('Showing ' + (start + 1) + '\u2013' + end + ' of ' + total) : '');
        }

        if (emptyState) {
          if (total === 0) {
            emptyState.classList.add('show');
            if (emptyQuery) emptyQuery.textContent = state.query || (state.letter !== 'All' ? state.letter : '');
          } else {
            emptyState.classList.remove('show');
          }
        }

        renderPagination(totalPages);
      }

      function renderPagination(totalPages) {
        if (!paginationEl) return;
        paginationEl.innerHTML = '';
        if (totalPages <= 1) return;

        function addBtn(label, page, opts) {
          opts = opts || {};
          var b = document.createElement('button');
          b.type = 'button';
          b.textContent = label;
          if (opts.disabled) b.disabled = true;
          if (opts.active) b.classList.add('active');
          b.addEventListener('click', function() { state.page = page; render(); });
          paginationEl.appendChild(b);
        }
        function addEllipsis() {
          var span = document.createElement('span');
          span.className = 'pg-ellipsis';
          span.textContent = '\u2026';
          paginationEl.appendChild(span);
        }

        addBtn('\u2039 Previous', state.page - 1, { disabled: state.page <= 1 });

        var pages = [];
        for (var p = 1; p <= totalPages; p++) {
          if (p === 1 || p === totalPages || Math.abs(p - state.page) <= 1) pages.push(p);
        }
        var last = 0;
        pages.forEach(function(p) {
          if (last && p - last > 1) addEllipsis();
          addBtn(String(p), p, { active: p === state.page });
          last = p;
        });

        addBtn('Next \u203a', state.page + 1, { disabled: state.page >= totalPages });
      }

      function renderTypeahead() {
        if (!typeahead) return;
        var q = norm(state.query);
        if (!q) { typeahead.classList.remove('open'); typeahead.innerHTML = ''; return; }
        var matches = allGroups.filter(function(g) {
          return norm(g.getAttribute('data-label')).indexOf(q) !== -1;
        }).slice(0, 8);
        if (!matches.length) { typeahead.classList.remove('open'); typeahead.innerHTML = ''; return; }
        typeahead.innerHTML = '';
        matches.forEach(function(g) {
          var btn = document.createElement('button');
          btn.type = 'button';
          var summaryEl = g.querySelector('summary .group-name');
          var count = g.querySelector('summary .group-count');
          btn.textContent = summaryEl ? summaryEl.textContent : g.getAttribute('data-label');
          if (count) {
            var span = document.createElement('span');
            span.className = 'ta-count';
            span.textContent = count.textContent;
            btn.appendChild(span);
          }
          btn.addEventListener('click', function() {
            searchInput.value = summaryEl ? summaryEl.textContent : '';
            state.query = searchInput.value;
            state.page = 1;
            typeahead.classList.remove('open');
            updateSearchClearState();
            render();
            g.setAttribute('open', '');
            g.scrollIntoView({ behavior: 'smooth', block: 'center' });
          });
          typeahead.appendChild(btn);
        });
        typeahead.classList.add('open');
      }

      function updateSearchClearState() {
        if (!searchWrapEl) return;
        searchWrapEl.classList.toggle('has-value', !!searchInput.value);
      }

      if (searchInput) {
        searchInput.addEventListener('input', function() {
          state.query = searchInput.value;
          state.page = 1;
          updateSearchClearState();
          renderTypeahead();
          render();
        });
        searchInput.addEventListener('blur', function() {
          setTimeout(function() { if (typeahead) typeahead.classList.remove('open'); }, 150);
        });
      }
      if (clearBtn) {
        clearBtn.addEventListener('click', function() {
          searchInput.value = '';
          state.query = '';
          state.page = 1;
          updateSearchClearState();
          renderTypeahead();
          render();
          searchInput.focus();
        });
      }

      if (alphaBar) {
        alphaBar.addEventListener('click', function(e) {
          var btn = e.target.closest('button[data-letter]');
          if (!btn || btn.classList.contains('is-empty')) return;
          Array.prototype.slice.call(alphaBar.querySelectorAll('button')).forEach(function(b) { b.classList.remove('active'); });
          btn.classList.add('active');
          state.letter = btn.getAttribute('data-letter');
          state.page = 1;
          render();
        });
      }

      if (pageSizeSel) {
        pageSizeSel.addEventListener('change', function() {
          state.pageSize = parseInt(pageSizeSel.value, 10);
          state.page = 1;
          render();
        });
      }

      // "View all N" expands the remaining entries within an already-open group
      wrap.addEventListener('click', function(e) {
        var btn = e.target.closest('[data-view-all]');
        if (!btn) return;
        var group = btn.closest('.browse-group');
        Array.prototype.slice.call(group.querySelectorAll('.extra-entry')).forEach(function(el) {
          el.classList.add('shown');
        });
        btn.closest('.view-all-row').style.display = 'none';
      });

      render();
    })();
    </script>

  {/if}

</div>

{include file="frontend/components/footer.tpl"}

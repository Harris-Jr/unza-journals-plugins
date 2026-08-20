{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Site index.
 *
 *}
{include file="frontend/components/header.tpl"}


<style>
.pkp_structure_content {
	max-width: none !important;
	width: 100% !important;
	margin: 0 !important;
	border: none !important;
	box-shadow: none !important;
}
.pkp_structure_main {
	max-width: none !important;
	border: none !important;
	box-shadow: none !important;
}
html { overflow-x: hidden; }
.page_index_site { padding: 0; }
.site-band { width: 100%; padding: 3rem 0; box-sizing: border-box; }
.site-band-inner { max-width: 1500px; margin: 0 auto; padding: 0 2rem; box-sizing: border-box; }
.site-band + .site-band { border-top: 1px solid #ececec; }
.site-band.band-white { background: #fff; }
.site-band.band-tint { background: var(--unza-tint, #E6F4E8); }

.page_index_site .site_hero h1 { font-size: 42px; font-weight: 800; color: var(--unza-primary); margin: 0; line-height: 1.15; }
.page_index_site .site_hero h1 .accent { display: block; color: var(--unza-accent); font-style: italic; font-weight: 700; }
.page_index_site .site_hero .tagline_sub { color: var(--unza-text-muted); font-size: 16px; line-height: 1.65; margin: 1.25rem 0 0; max-width: 680px; }
.page_index_site .hero_search { display: flex; gap: 0.75rem; margin-top: 1.75rem; max-width: 700px; }
.page_index_site .hero_search input { flex: 1 1 auto; padding: 14px 18px; font-size: 15px; border: 1px solid #d5ded6; border-radius: 6px; box-sizing: border-box; }
.page_index_site .hero_search input:focus { outline: 2px solid var(--unza-accent); outline-offset: 1px; }

.page_index_site .platform-stats { display: flex; flex-wrap: wrap; gap: 1rem; }
.page_index_site .platform-stats .stat { flex: 1 1 160px; text-align: center; padding: 0.5rem 1rem; }
.page_index_site .platform-stats .stat-number { display: block; font-size: 2.2rem; font-weight: bold; color: var(--unza-primary); line-height: 1; margin-bottom: 0.35rem; }
.page_index_site .platform-stats .stat-label { font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.1em; font-weight: 700; color: var(--unza-text-muted); }

.page_index_site .section-heading-row { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1.75rem; gap: 1rem; flex-wrap: wrap; }
.page_index_site .section-heading-row h2 { font-size: 26px; font-weight: 800; color: var(--unza-primary); margin: 0; }
.page_index_site .section-heading-row .view-all { font-size: 0.78rem; font-weight: 800; letter-spacing: 0.06em; text-transform: uppercase; text-decoration: underline; color: var(--unza-primary); white-space: nowrap; }

.page_index_site .recently_published ul { list-style: none; margin: 0; padding: 0; }
.page_index_site .recently_published li { margin-bottom: 10px; }
.page_index_site .recently_published li a { display: block; padding: 16px 20px; border-radius: 12px; border-left: 4px solid transparent; background: #fafafa; text-decoration: none !important; color: var(--unza-primary) !important; font-weight: 600; transition: all var(--unza-transition); }
.page_index_site .recently_published li a:hover { border-left-color: var(--unza-tertiary); background: #fff; transform: translateX(8px); box-shadow: 0 4px 14px rgba(0,0,0,0.06); }
.page_index_site .recently_published .meta { display: block; color: var(--unza-text-muted); font-size: 13px; font-weight: 400; margin-top: 4px; }
.page_index_site .recently_published li.is_extra { display: none; }
.page_index_site .recently_published.expanded li.is_extra { display: list-item; }
.page_index_site .load_more_wrap { text-align: center; margin-top: 1.5rem; }

@media (max-width: 600px) {
	.site-band { padding: 1.75rem 0; }
	.site-band-inner { padding: 0 1rem; }
	.page_index_site .site_hero h1 { font-size: 28px; }
	.page_index_site .site_hero .tagline_sub { font-size: 14px; }
	.page_index_site .hero_search { flex-direction: column; }
	.page_index_site .platform-stats { flex-direction: column; }
	.page_index_site .platform-stats .stat { border-bottom: 1px solid #e2e2e2; padding: 0.85rem 1rem; }
	.page_index_site .platform-stats .stat:last-child { border-bottom: none; }
	.page_index_site .platform-stats .stat-number { font-size: 1.8rem; }
	.journal-list-styled > li { flex-wrap: wrap; }
	.page_index_site .section-heading-row { flex-direction: column; align-items: flex-start; }
}
</style>

<div class="page_index_site">

<div class="site-band band-tint">
<div class="site-band-inner">
	<div class="site_hero">
		<h1>{translate key="site.hero.tagline"}<span class="accent">{translate key="site.hero.taglineAccent"}</span></h1>
		<p class="tagline_sub">{translate key="site.hero.subtagline"}</p>
		<form class="hero_search" action="{$baseUrl}/index.php/index/search" method="get" role="search">
			<input type="text" name="query" value="" placeholder="{translate key="site.hero.searchPlaceholder"}">
			<button type="submit" class="unza-btn">{translate key="site.hero.browseRepository"}</button>
		</form>
	</div>
	{if $about}
		<div class="about_site">{$about}</div>
	{/if}
</div>
</div><!-- .band-tint -->

<div class="site-band band-white">
<div class="site-band-inner">
	<div class="platform-stats">
		<div class="stat">
			<span class="stat-number" data-count-to="{$totalJournals}">0</span>
			<span class="stat-label">{translate key="context.contexts"}</span>
		</div>
		<div class="stat">
			<span class="stat-number" data-count-to="{$totalPublished}">0</span>
			<span class="stat-label">{translate key="site.stats.publishedArticles"}</span>
		</div>
		<div class="stat">
			<span class="stat-number" data-count-to="{$totalAuthors}">0</span>
			<span class="stat-label">{translate key="site.stats.distinctAuthors"}</span>
		</div>
	</div>
	<script>
	(function() {
		var nums = document.querySelectorAll('.page_index_site .stat-number');
		var animated = false;
		function animate() {
			if (animated) return;
			animated = true;
			nums.forEach(function(el) {
				var target = parseInt(el.getAttribute('data-count-to'), 10) || 0;
				var duration = 800;
				var start = null;
				function step(ts) {
					if (!start) start = ts;
					var progress = Math.min((ts - start) / duration, 1);
					el.textContent = Math.floor(progress * target);
					if (progress < 1) requestAnimationFrame(step);
					else el.textContent = target;
				}
				requestAnimationFrame(step);
			});
		}
		var target = document.querySelector('.page_index_site .platform-stats');
		if ('IntersectionObserver' in window && target) {
			var observer = new IntersectionObserver(function(entries) {
				entries.forEach(function(entry) {
					if (entry.isIntersecting) { animate(); observer.disconnect(); }
				});
			}, { threshold: 0.2, rootMargin: '0px 0px -10% 0px' });
			requestAnimationFrame(function() { observer.observe(target); });
		} else {
			animate();
		}
	})();
	</script>
</div>
</div><!-- .band-white -->

<div class="site-band band-white">
<div class="site-band-inner">
	<div class="journals">
		<div class="section-heading-row">
			<div>
				<span class="unza-eyebrow">{translate key="site.ourJournalsEyebrow"}</span>
				<h2>{translate key="site.ourJournals"}</h2>
			</div>
			<a class="view-all" href="{url router=$smarty.const.ROUTE_PAGE page='browse' op='journals'}">
				{translate key="site.viewMoreJournals"}
			</a>
		</div>
		{if !$journals|@count}
			{translate key="site.noJournals"}
		{else}
			<ul class="journal-list-styled">
				{foreach from=$journals item=journal name=journalsLoop}
					{if $smarty.foreach.journalsLoop.iteration <= 2}
						{capture assign="url"}{url journal=$journal->getPath()}{/capture}
						{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
						{assign var="description" value=$journal->getLocalizedDescription()}
						<li>
							{if $thumb}
								<div class="thumb">
									<a href="{$url|escape}">
										<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText} alt="{$thumb.altText|escape|default:''}"{/if}>
									</a>
								</div>
							{/if}
							<div class="body">
								<h3>
									<a href="{$url|escape}" rel="bookmark">
										{$journal->getLocalizedName()|escape}
									</a>
								</h3>
								{if $description}
									<div class="description">{$description}</div>
								{/if}
								<ul class="links">
									<li class="view">
										<a href="{$url|escape}">{translate key="site.journalView"}</a>
									</li>
									<li class="current">
										<a href="{url|escape journal=$journal->getPath() page="issue" op="current"}">{translate key="site.journalCurrent"}</a>
									</li>
								</ul>
							</div>
						</li>
					{/if}
				{/foreach}
			</ul>
		{/if}
	</div>
</div>
</div><!-- .band-white -->

{if $recentSubmissions|@count}
<div class="site-band band-white">
<div class="site-band-inner">
	<div class="recently_published" id="recentlyPublishedSection">
		<div class="section-heading-row">
			<div>
				<span class="unza-eyebrow">{translate key="site.recentlyPublishedEyebrow"}</span>
				<h2>{translate key="site.recentlyPublished"}</h2>
			</div>
		</div>
		<ul id="recentArticlesList">
			{foreach from=$recentSubmissions item=submission name=recentLoop}
				<li{if $smarty.foreach.recentLoop.iteration > 3} class="is_extra"{/if}>
					<a href="{$submission.url|escape}">
						{$submission.title|strip_unsafe_html}
						<span class="meta">{$submission.journalName|escape} &middot; {$submission.datePublished|date_format:"%B %Y"}</span>
					</a>
				</li>
			{/foreach}
		</ul>
		{if $recentSubmissions|@count > 3}
			<div class="load_more_wrap">
				<button type="button" id="loadMoreArticles" class="unza-btn-outline">{translate key="site.loadMoreArticles"}</button>
			</div>
			<script>
			(function() {
				var btn = document.getElementById('loadMoreArticles');
				var section = document.getElementById('recentlyPublishedSection');
				if (!btn || !section) return;
				btn.addEventListener('click', function() {
					section.classList.add('expanded');
					btn.style.display = 'none';
				});
			})();
			</script>
		{/if}
	</div>
</div>
</div><!-- .band-white -->
{/if}

</div><!-- .page_index_site -->

{include file="frontend/components/footer.tpl"}

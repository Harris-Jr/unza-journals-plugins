<?php

/**
 * @file plugins/generic/unza/UnzaGenericPlugin.inc.php
 *
 * @class UnzaGenericPlugin
 * @ingroup plugins_generic_unza
 *
 * @brief Backend support for the UNZA Journals theme.
 *
 * This plugin owns the two pieces of PHP logic the UNZA design needs that
 * aren't pure template/CSS work:
 *
 *   1. The custom "Browse Scholarly Content" page (index.php/browse/<mode>).
 *      This has no equivalent in stock OJS, so it's registered as a brand
 *      new page via the `LoadHandler` hook, backed by pages/BrowseHandler
 *      in this plugin directory (moved here unchanged from the core edit).
 *
 *   2. A few extra variables the UNZA homepage template needs (platform
 *      stats + a "recently published" list) that stock IndexHandler
 *      doesn't provide. Rather than editing IndexHandler.inc.php, these
 *      are injected via the `TemplateManager::display` hook, right before
 *      frontend/pages/indexSite.tpl renders -- so IndexHandler.inc.php can
 *      stay 100% stock core.
 *
 * Both the journal/article counts and the recent-submissions list are
 * cached for a short window (UNZA_STATS_CACHE_TTL) using OJS's built-in
 * CacheManager, since they're real DB aggregate queries that shouldn't be
 * recomputed on every single homepage/Browse request once the site has
 * 15+ journals of real traffic. A short TTL means new publications show up
 * within minutes without needing any manual cache-invalidation hook.
 */

import('lib.pkp.classes.plugins.GenericPlugin');

define('UNZA_STATS_CACHE_TTL', 900); // 15 minutes

class UnzaGenericPlugin extends GenericPlugin {

	/**
	 * @copydoc Plugin::register()
	 */
	function register($category, $path, $mainContextId = null) {
		$success = parent::register($category, $path, $mainContextId);
		if (!Config::getVar('general', 'installed') || defined('RUNNING_UPGRADE')) return $success;

		if ($success && $this->getEnabled($mainContextId)) {
			HookRegistry::register('LoadHandler', array($this, 'loadPageHandler'));
			HookRegistry::register('TemplateManager::display', array($this, 'assignHomepageStats'));
		}

		return $success;
	}

	/**
	 * @copydoc Plugin::getDisplayName()
	 */
	function getDisplayName() {
		return __('plugins.generic.unza.name');
	}

	/**
	 * @copydoc Plugin::getDescription()
	 */
	function getDescription() {
		return __('plugins.generic.unza.description');
	}

	/**
	 * Register the custom Browse page (index.php/browse/<mode>).
	 *
	 * @param $hookName string `LoadHandler`
	 * @param $args array [page, op, sourceFile]
	 * @return bool
	 */
	function loadPageHandler($hookName, $args) {
		$page = $args[0];

		if ($page === 'browse') {
			$this->import('pages.BrowseHandler');
			define('HANDLER_CLASS', 'BrowseHandler');
			return true;
		}

		return false;
	}

	/**
	 * Inject platform stats + recent submissions before the site homepage
	 * renders. No-op for every other template.
	 *
	 * @param $hookName string `TemplateManager::display`
	 * @param $args array [templateMgr, template, output]
	 * @return bool
	 */
	function assignHomepageStats($hookName, $args) {
		$templateMgr = $args[0];
		$template = $args[1];

		if ($template !== 'frontend/pages/indexSite.tpl') {
			return false;
		}

		$request = Application::get()->getRequest();

		// If a journal is selected, this isn't the site-wide homepage --
		// stock OJS routes that case to indexJournal.tpl anyway, but this
		// guard is cheap insurance against future routing changes.
		if ($request->getJournal()) {
			return false;
		}

		$journalDao = DAORegistry::getDAO('JournalDAO'); /* @var $journalDao JournalDAO */
		$journals = $journalDao->getAll(true)->toArray();

		$this->import('pages.BrowseHandler');
		$stats = $this->_getCachedStats($journals);
		$recentSubmissions = $this->_getCachedRecentSubmissions(9);

		$templateMgr->assign([
			'recentSubmissions' => $recentSubmissions,
			'totalJournals' => $stats['totalJournals'],
			'totalPublished' => $stats['totalPublished'],
			'totalAuthors' => $stats['totalAuthors'],
		]);

		return false;
	}

	/**
	 * Cached wrapper around BrowseHandler::getPlatformStats().
	 * @param $journals array
	 * @return array
	 */
	private function _getCachedStats($journals) {
		$cacheManager = CacheManager::getManager();
		$cache = $cacheManager->getFileCache(
			'unza', 'platformStats',
			array($this, '_statsCacheMiss')
		);

		$cachedData = $cache->getContents();
		if (!$cachedData || (time() - $cachedData['time']) > UNZA_STATS_CACHE_TTL) {
			$stats = BrowseHandler::getPlatformStats($journals);
			$cachedData = ['time' => time(), 'data' => $stats];
			$cache->setEntireCache($cachedData);
		}

		return $cachedData['data'];
	}

	/**
	 * Cached wrapper around the "recently published" query.
	 * @param $limit int
	 * @return array
	 */
	private function _getCachedRecentSubmissions($limit) {
		$cacheManager = CacheManager::getManager();
		$cache = $cacheManager->getFileCache(
			'unza', 'recentSubmissions',
			array($this, '_statsCacheMiss')
		);

		$cachedData = $cache->getContents();
		if (!$cachedData || (time() - $cachedData['time']) > UNZA_STATS_CACHE_TTL) {
			$submissions = $this->_fetchRecentSubmissions($limit);
			$cachedData = ['time' => time(), 'data' => $submissions];
			$cache->setEntireCache($cachedData);
		}

		return $cachedData['data'];
	}

	/**
	 * FileCache requires a miss callback even though we manage staleness
	 * ourselves above -- an empty cache on first-ever request should just
	 * come back empty so _getCachedStats()/_getCachedRecentSubmissions()
	 * populate it themselves.
	 */
	function _statsCacheMiss($cache, $id) {
		return null;
	}

	/**
	 * The N most recently published articles across all active journals,
	 * for the homepage "Recently Published" section.
	 * (Moved here unchanged from the former IndexHandler::_getRecentSubmissions().)
	 *
	 * @param $limit int
	 * @return array
	 */
	private function _fetchRecentSubmissions($limit = 9) {
		$submissionDao = DAORegistry::getDAO('SubmissionDAO'); /* @var $submissionDao SubmissionDAO */
		$journalDao = DAORegistry::getDAO('JournalDAO'); /* @var $journalDao JournalDAO */
		$request = Application::get()->getRequest();

		$result = $submissionDao->retrieve(
			'SELECT s.submission_id
			FROM submissions s
			INNER JOIN publications p ON (p.publication_id = s.current_publication_id)
			INNER JOIN journals j ON (j.journal_id = s.context_id)
			WHERE p.status = ? AND j.enabled = ?
			ORDER BY p.date_published DESC',
			[STATUS_PUBLISHED, 1]
		);

		$journalCache = [];
		$submissions = [];
		foreach ($result as $row) {
			$submission = $submissionDao->getById($row->submission_id);
			if (!$submission) continue;
			$publication = $submission->getCurrentPublication();
			if (!$publication) continue;

			$contextId = $submission->getData('contextId');
			if (!isset($journalCache[$contextId])) {
				$journalCache[$contextId] = $journalDao->getById($contextId);
			}
			$journal = $journalCache[$contextId];
			if (!$journal) continue;

			$submissions[] = [
				'title' => $publication->getLocalizedFullTitle(),
				'journalName' => $journal->getLocalizedName(),
				'journalPath' => $journal->getPath(),
				'datePublished' => $publication->getData('datePublished'),
				'url' => $request->getDispatcher()->url(
					$request, ROUTE_PAGE, $journal->getPath(), 'article', 'view', [$submission->getId()]
				),
			];
			if (count($submissions) >= $limit) break;
		}
		return $submissions;
	}
}

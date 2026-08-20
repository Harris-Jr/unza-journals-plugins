<?php
/**
 * @file pages/browse/BrowseHandler.inc.php
 *
 * OJS 3.3-compatible browse handler
 * URL:  index.php/browse/<mode>
 */

import('classes.handler.Handler');
import('lib.pkp.classes.submission.PKPSubmission'); // Status Published

class BrowseHandler extends Handler {

    public function authorize($request, &$args, $roleAssignments) {
        return parent::authorize($request, $args, $roleAssignments);
    }

    /* entry point – router calls the method named by $op */
    public function index($args, $request)     { $this->_setupBrowse('browse',   $request); }
    public function category($args, $request)  { $this->_setupBrowse('category', $request); }
    public function subject($args, $request)   { $this->_setupBrowse('subject',  $request); }
    public function journals($args, $request)  { $this->_setupBrowse('journals', $request); }
    public function title($args, $request)     { $this->_setupBrowse('title',    $request); }
    public function keyword($args, $request)   { $this->_setupBrowse('keyword',  $request); }
    public function affiliation($args, $request){ $this->_setupBrowse('affiliation',$request); }
    public function year($args, $request)      { $this->_setupBrowse('year',     $request); }

    // Provide `browse()` so op='browse' links still work
    public function browse($args, $request)    { $this->_setupBrowse('browse',   $request); }

    /**
     * Compute site-wide platform stats (journal count, published article count,
     * distinct author count). Shared between the Browse overview and the homepage.
     * @param $journals array of Journal objects
     * @return array ['totalJournals' => int, 'totalPublished' => int, 'totalAuthors' => int]
     */
    public static function getPlatformStats(array $journals) : array
    {
        $submissionService = Services::get('submission');
        $allPublished = [];
        $authorSet = [];

        foreach ($journals as $journal) {
            $submissions = $submissionService->getMany([
                'contextId' => $journal->getId(),
                'status'    => STATUS_PUBLISHED,
            ]);
            foreach ($submissions as $submission) {
                $allPublished[$submission->getId()] = true;
                $pub = $submission->getCurrentPublication();
                if ($pub) {
                    $authors = $pub->getData('authors') ?: $pub->getAuthors();
                    foreach ((array)$authors as $author) {
                        $identifier = null;
                        if (is_object($author)) {
                            $identifier = trim($author->getEmail() ?: $author->getFullName());
                        } elseif (is_array($author)) {
                            $identifier = trim($author['email'] ?? $author['name'] ?? '');
                        }
                        if ($identifier) $authorSet[$identifier] = true;
                    }
                }
            }
        }

        return [
            'totalJournals'  => count($journals),
            'totalPublished' => count($allPublished),
            'totalAuthors'   => count($authorSet),
        ];
    }

    private function _setupBrowse(string $mode, Request $request) : void
    {
        $templateMgr = TemplateManager::getManager($request);
        $journalDao  = DAORegistry::getDAO('JournalDAO');
        $journals    = $journalDao->getAll(true)->toArray();

        $submissionService = Services::get('submission');
        $sectionDao = DAORegistry::getDAO('SectionDAO');

        $buckets = [];
        $seen = []; // to avoid duplicate submission inside same bucket
        $allPublished = []; // unique published submission ids (platform total)
        $authorSet = []; // unique authors (by email or name)

        foreach ($journals as $journal) {
            $journalPath = $journal->getPath();

            // For the 'journals' view we bucket journals themselves (not submissions)
            if ($mode === 'journals') {
                $letter = strtoupper(mb_substr($journal->getLocalizedName(), 0, 1));
                if (!ctype_alpha($letter)) $letter = '#';
                $buckets[$letter][] = ['type' => 'journal', 'journal' => $journal];
                continue;
            }

            // Get published submissions for this journal
            $submissions = $submissionService->getMany([
                'contextId' => $journal->getId(),
                'status'    => STATUS_PUBLISHED,
            ]);

            foreach ($submissions as $submission) {
                $submissionId = $submission->getId();
                // Count unique published submissions
                if (!isset($allPublished[$submissionId])) $allPublished[$submissionId] = true;

                $pub = $submission->getCurrentPublication();

                // collect authors for platform-wide distinct author count
                if ($pub) {
                    $authors = $pub->getData('authors') ?: $pub->getAuthors();
                    foreach ((array)$authors as $author) {
                        $identifier = null;
                        if (is_object($author)) {
                            $identifier = trim($author->getEmail() ?: $author->getFullName());
                        } elseif (is_array($author)) {
                            $identifier = trim($author['email'] ?? $author['name'] ?? '');
                        }
                        if ($identifier) $authorSet[$identifier] = true;
                    }
                }

                switch ($mode) {
                    case 'browse':
                        break;

                    case 'category':
                        $categoryDao = DAORegistry::getDAO('CategoryDAO');
                        $foundCategory = false;
                        if ($pub) {
                            $assignedCategories = $categoryDao->getByPublicationId($pub->getId());
                            while ($category = $assignedCategories->next()) {
                                $categoryName = $category->getLocalizedTitle() ?: 'Uncategorised';
                                if (!isset($buckets[$categoryName])) {
                                    $buckets[$categoryName] = [];
                                }
                                $buckets[$categoryName][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath];
                                $foundCategory = true;
                            }
                        }
                        if (!$foundCategory) {
                            $buckets['Uncategorised'][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath];
                        }
                        break;

                    case 'subject':
                        $section = $sectionDao->getById($submission->getSectionId());
                        if ($section) {
                            $bucket = $section->getLocalizedTitle();
                            if (!isset($seen[$bucket][$submissionId])) {
                                $buckets[$bucket][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath];
                                $seen[$bucket][$submissionId] = true;
                            }
                        } else {
                            if (!isset($seen['Unspecified'][$submissionId])) {
                                $buckets['Unspecified'][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath];
                                $seen['Unspecified'][$submissionId] = true;
                            }
                        }
                        break;

                    case 'title':
                        $title = $pub ? $pub->getLocalizedTitle() : '';
                        $letter = strtoupper(mb_substr($title, 0, 1));
                        if (!ctype_alpha($letter)) $letter = '#';
                        if (!isset($seen[$letter][$submissionId])) {
                            $buckets[$letter][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath, 'journal' => $journal];
                            $seen[$letter][$submissionId] = true;
                        }
                        break;

                    case 'keyword':
                        $keywords = $pub ? $pub->getData('keywords') : [];
                        $flatKw = [];
                        foreach ((array)$keywords as $locale => $keywordList) {
                            foreach ((array)$keywordList as $kw) {
                                $kw = trim($kw);
                                if ($kw !== '') $flatKw[] = $kw;
                            }
                        }
                        $flatKw = array_unique($flatKw);
                        if (count($flatKw)) {
                            foreach ($flatKw as $bucket) {
                                if (!isset($seen[$bucket][$submissionId])) {
                                    $buckets[$bucket][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath, 'journal' => $journal];
                                    $seen[$bucket][$submissionId] = true;
                                }
                            }
                        } else {
                            $bucket = 'Unclassified';
                            if (!isset($seen[$bucket][$submissionId])) {
                                $buckets[$bucket][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath, 'journal' => $journal];
                                $seen[$bucket][$submissionId] = true;
                            }
                        }
                        break;

                    case 'affiliation':
                        if ($pub) {
                            $authors = $pub->getData('authors') ?: $pub->getAuthors();
                            foreach ((array)$authors as $author) {
                                if (is_object($author) && method_exists($author, 'getLocalizedAffiliation')) {
                                    $aff = trim($author->getLocalizedAffiliation()) ?: 'Unknown';
                                } elseif (is_array($author) && isset($author['affiliation'])) {
                                    $aff = trim($author['affiliation']) ?: 'Unknown';
                                } else {
                                    $aff = 'Unknown';
                                }
                                if (!isset($seen[$aff][$submissionId])) {
                                    $buckets[$aff][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath, 'journal' => $journal];
                                    $seen[$aff][$submissionId] = true;
                                }
                            }
                        } else {
                            $bucket = 'Unknown';
                            if (!isset($seen[$bucket][$submissionId])) {
                                $buckets[$bucket][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath, 'journal' => $journal];
                                $seen[$bucket][$submissionId] = true;
                            }
                        }
                        break;

                    case 'year':
                        $date = $pub ? $pub->getData('datePublished') : null;
                        $year = $date ? date('Y', strtotime($date)) : 'Unknown';
                        if (!isset($seen[$year][$submissionId])) {
                            $buckets[$year][] = ['type' => 'submission', 'submission' => $submission, 'journalPath' => $journalPath, 'journal' => $journal];
                            $seen[$year][$submissionId] = true;
                        }
                        break;
                } // switch
            } // foreach submissions
        } // foreach journals

        // sort bucket keys alphabetically, years descending
        if ($mode === 'year') {
            krsort($buckets);
        } else {
            ksort($buckets, SORT_FLAG_CASE | SORT_STRING);
        }

        // sort items inside each bucket (by title or journal name)
        foreach ($buckets as $bucketKey => &$list) {
            usort($list, function($a, $b) {
                $getLabel = function($item) {
                    if ($item['type'] === 'journal') {
                        return $item['journal']->getLocalizedName();
                    }
                    $pubA = $item['submission']->getCurrentPublication();
                    $t = $pubA ? $pubA->getLocalizedTitle() : '';
                    // fallback to journal name
                    if ($t === '' && isset($item['journal'])) return $item['journal']->getLocalizedName();
                    return $t;
                };
                $ta = $getLabel($a);
                $tb = $getLabel($b);
                return strcasecmp($ta, $tb);
            });
        }
        unset($list);

        // Human-readable plural noun per browse mode, used for result counts
        // ("92 keywords", "Showing 1-10 of 92") and empty-state messaging.
        $nounMap = [
            'category'    => 'categories',
            'subject'     => 'subjects',
            'journals'    => 'journals',
            'title'       => 'titles',
            'keyword'     => 'keywords',
            'affiliation' => 'affiliations',
            'year'        => 'years',
        ];
        $browseNoun = $nounMap[$mode] ?? 'items';

        // platform stats
        $stats = self::getPlatformStats($journals);
        $totalJournals = $stats['totalJournals'];
        $totalPublished = $stats['totalPublished'];
        $totalAuthors = $stats['totalAuthors'];

        $templateMgr->assign([
            'pageTitle'       => __('navigation.browse'),
            'browseMode'      => $mode,
            'buckets'         => $buckets,
            'browseNoun'      => $browseNoun,
            'totalJournals'   => $totalJournals,
            'totalPublished'  => $totalPublished,
            'totalAuthors'    => $totalAuthors,
            'journalFilesPath' => $request->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/',
        ]);
        $templateMgr->display('frontend/pages/browse.tpl');
    }
}

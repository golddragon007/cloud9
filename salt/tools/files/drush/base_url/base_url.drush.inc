<?php
/**
 * @file
 * Provide Drush integration for release building and dependency building.
 */

/**
 * Implements hook_drush_help().
 */
function base_url_drush_help($section) {
  switch ($section) {
    case 'drush:base_url':
      return dt('Display the date of the latest cron run.');
  }
}

/**
 * Implements hook_drush_command().
 */
function base_url_drush_command() {
  $items = array();

  $items['base_url'] = array(
    'description' => 'Display the base URL.',
    'callback' => 'drush_base_url',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_FULL,
  );

  return $items;
}

/**
 * Rebuild the registry.
 *
 * Before calling this we need to be bootstrapped to DRUPAL_BOOTSTRAP_DATABASE.
 */
function drush_base_url() {
  if (!drush_bootstrap_to_phase(DRUSH_BOOTSTRAP_DRUPAL_FULL)) {
    return drush_set_error('DRUPAL_SITE_NOT_FOUND', dt('You need to specify an alias or run this command within a drupal site.'));
  }
  drush_print($GLOBALS['base_url']);
}

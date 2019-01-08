<?php
/**
 * @file
 * Provide Drush integration for Redis.
 */

/**
 * Implements hook_drush_help().
 */
function redis_drush_help($section) {
  switch ($section) {
    case 'drush:redis-connect':
      return dt('A string for connecting to the Redis DB..');
    case 'drush:redis-cli':
      return dt('Open a Redis command-line interface using Drupal\'s credentials.');
    case 'drush:redis-exec':
      return dt('Execute command on redis server.');
  }
}

/**
 * Implements hook_drush_command().
 */
function redis_drush_command() {
  $items = array();

  $items['redis-connect'] = array(
    'description' => 'The command line to connect to Redis.',
    'callback' => 'drush_redis_connect',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_CONFIGURATION,
    'aliases' => array('rds'),
  );
  $items['redis-cli'] = array(
    'description' => 'Connect to Redis.',
    'callback' => 'drush_redis_cli',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_CONFIGURATION,
    'aliases' => array('rdc'),
  );
  $items['redis-exec'] = array(
    'description' => 'Connect to Redis.',
    'callback' => 'drush_redis_exec',
    'bootstrap' => DRUSH_BOOTSTRAP_DRUPAL_CONFIGURATION,
    'aliases' => array('rde'),
    'arguments' => [
       'rcmd' => 'Command to execute on redis',
       'rarg' => 'Argument for redis command',
     ],
  );

  return $items;
}

function drush_redis_connect() {
  drush_print(_drush_redis_command_line());
}

function drush_redis_cli() {
  drush_shell_proc_open(_drush_redis_command_line());
}

function drush_redis_exec($rcmd = '', $rarg = '') {
  $cmd = _drush_redis_command_line();
  $cmd .= sprintf(' %s', escapeshellarg($rcmd));
  if (!empty($rarg)){
    $cmd .= sprintf(' %s', escapeshellarg($rarg));
  }
  drush_shell_proc_open($cmd);
}

/**
 * Validation for the redis_exec.
 */
function drush_redis_exec_validate($rcmd = '', $rarg = '') {
  if (empty($rcmd)) {
    return drush_set_error('ARGUMENTS_REQUIRED', dt('You must specify the required argument.'));
  }
}

function _drush_redis_command_line() {
  return variable_get('redis_cli_path', 'redis-cli') . _drush_redis_command_line_arguments();
}

function _drush_redis_command_line_arguments() {
  $command_line = '';
  if (strlen(variable_get('redis_client_host'))) {
    $command_line .= sprintf(' -h %s', escapeshellarg(variable_get('redis_client_host')));
  }
  if (strlen(variable_get('redis_client_port'))) {
    $command_line .= sprintf(' -p %s', escapeshellarg(variable_get('redis_client_port')));
  }
  if (strlen(variable_get('redis_client_password'))) {
    $command_line .= sprintf(' -a %s', escapeshellarg(variable_get('redis_client_password')));
  }
  if (strlen(variable_get('redis_client_base'))) {
    $command_line .= sprintf(' -n %s', escapeshellarg(variable_get('redis_client_base')));
  }
  return $command_line;
}




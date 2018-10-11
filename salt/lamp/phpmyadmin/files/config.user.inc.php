<?php

/***********************************
 * Include Devops default settings.
 ***********************************/
if (file_exists('/etc/phpmyadmin/config.devops.inc.php')) {
    include('/etc/phpmyadmin/config.devops.inc.php');
}

/*****************************
 * Phpmyadmin user configs.
 *****************************/

# The number of items (tables, columns, indexes) that can be displayed on each page of the navigation tree.
#$cfg['MaxNavigationItems'] = 250;

# The maximum number of table names to be displayed in the main panel’s list (except on the Export page).
#$cfg['MaxTableList'] = 250;
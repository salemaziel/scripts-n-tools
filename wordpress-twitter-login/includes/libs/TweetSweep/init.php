<?php
if ( !defined('ABSPATH') )
{
    wp_die();
}

require trailingslashit(plugin_dir_path(__FILE__)) .'tmhOAuth.php';
require trailingslashit(plugin_dir_path(__FILE__)) .'tmhUtilities.php';
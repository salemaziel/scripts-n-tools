<?php
/**
 *
 * @link              https://logicspice.com
 * @since             1.0.0
 * @package           TwitterLogin
 *
 * @wordpress-plugin
 * Plugin Name:       Twitter Login
 * Plugin URI:        http://wordpress.org/plugins/twitter-login
 * Description:       Twitter Login. Using twitter to register / log in to your website.
 * Version:           1.0.0
 * Author:            Logicspice Team
 * Author URI:        https://logicspice.com
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       wiloke
 * Domain Path:       /languages
 */

if ( !defined('ABSPATH') )
{
    wp_die('You dont have permission to access to this page');
}

require_once  trailingslashit( plugin_dir_path(__FILE__)  ) . 'includes/class.WilokeTwitterLogin.php';

function wiloke_twitter_login()
{
    $init = WilokeTwitterLogin::instance();
    $init->run();
    return $init;
}

$GLOBALS['WilokeTwitterLogin'] = wiloke_twitter_login();

register_activation_hook(__FILE__, array('WilokeTwitterLogin', 'create_table'));
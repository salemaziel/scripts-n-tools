<?php

/**
 * The class handler everything related to admin
 *
 * @since       1.0
 * @author      Wiloke Team
 * @link        http://demo.wiloke.com
 * @package     WilokeTwitterLogin
 * @subpackage  WilokeTwitterLogin/admin
 */

class WilokeTwitterLoginAdmin
{
    /**
     * Localtion of admin views
     */
    protected $_views;

    public function __construct()
    {
        $this->_views = trailingslashit( plugin_dir_path(__FILE__) ) . 'views/';
    }

    /**
     * Register Wiloke Twitter Login menu item
     * @since 1.0
     */
    public function add_menu_items()
    {
        add_submenu_page(
            'options-general.php',
            'Twitter Login',
            'Twitter Login',
            'edit_posts',
            'twitter_login',
            array( $this, 'display_settings' )
        );
    }

    /**
     * Include views here
     * @since 1.0
     */
    public function display_settings()
    {
        include $this->_views . 'twitter-settings.php';
    }

    /**
     * Create setting fields
     * @since 1.0
     */
    public function create_settings()
    {
        include trailingslashit( plugin_dir_path(__FILE__) ) . 'class.WilokeTwitterLoginAdminSettings.php';
        $settings = new WilokeTwitterLoginAdminSettings();
        $settings->save_settings();
        $settings->fields();
    }
}
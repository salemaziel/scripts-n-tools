<?php
/**
 * Register all shortcodes of the plugin
 *
 * @link        http://demo.wiloke.com
 * @author      Wiloke Team
 * @subpackage  WilokeTwitterLogin/includes
 * @since       1.0
 */

class WilokeTwitterLoginShortcodes
{
    public $optionKey;
    public function __construct()
    {
        $this->register_shortcodes();
    }

    /**
     * A collection of shortcodes
     * @since 1.0
     */
    public function register_shortcodes()
    {
        add_shortcode('wiloke_twitter_login', array($this, 'wiloke_twitter_login_render'));
    }

    /**
     * Render Twitter Login
     * [wiloke_twitter_login]
     *
     * @$atts       an array contains params of the shortcode
     * @see         https://codex.wordpress.org/Function_Reference/add_shortcode
     * @since 1.0
     */
    public function wiloke_twitter_login_render($atts)
    {
        $aTwitterSettings = get_option(WilokeTwitterLogin::twitter_option());
        if ( empty($aTwitterSettings) || is_user_logged_in() )
        {
            return;
        }

        ob_start();
            do_action('wiloke_twitter_login_sc', $atts);
        $html = ob_get_contents();
        ob_end_clean();
        return $html;
    }
}
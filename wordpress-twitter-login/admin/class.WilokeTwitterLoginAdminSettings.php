<?php
/**
 * Register settings of Twitter Login
 *
 * @link        http://demo.wiloke.com
 * @author      Wiloke Team
 * @since       1.0
 * @package     WilokeTwitterLogin
 * @subpackage  WilokeTwitterLogin/admin
 */

class WilokeTwitterLoginAdminSettings
{
    public $optionKey;
    public $aDefault;

    public function __construct()
    {
        $this->aDefault = array(
            'consumer_secret'       => '',
            'consumer_key'          => '',
            'access_token_secret'   => '',
            'access_token'          => '',
        );

        $this->partials = trailingslashit( plugin_dir_path(__FILE__) ) . 'partials/';

        $this->optionKey = WilokeTwitterLogin::twitter_option();
    }


    /**
     * Render Twitter Settings Key Here
     * @since 1.0
     */
    public function fields()
    {
        $aTwitter = get_option($this->optionKey);
        $aTwitter = wp_parse_args($aTwitter, $this->aDefault);

        include $this->partials . 'consumer-key-field.php';
        include $this->partials . 'consumer-secret-field.php';
        include $this->partials . 'access-token-field.php';
        include $this->partials . 'access-token-secret-field.php';
        include $this->partials . 'guide-field.php';
    }

    /**
     * Save data
     * @since 1.0
     */
    public function save_settings()
    {
        if ( isset($_POST['wiloke_twitter_login_nonce_field']) && !empty($_POST['wiloke_twitter_login_nonce_field']) )
        {
            if ( wp_verify_nonce($_POST['wiloke_twitter_login_nonce_field'], 'wiloke_twitter_login_nonce') )
            {
                foreach ( $_POST['twitter'] as $key => $val )
                {
                    $aData[$key] = sanitize_text_field($val);
                }

                update_option($this->optionKey, $aData);
            }
        }
    }
}
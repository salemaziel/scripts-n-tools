<?php

/**
 * Wiloke Twitter Widget
 *
 * @link        http://demo.wiloke.com
 * @author      Wiloke Team
 * @since       1.0
 * @package     WilokeTwitterLogin
 * @subpackage  WilokeTwitterLogin/admin
 */

class WilokeTwitterLoginWidget extends WP_Widget
{
    public function __construct()
    {
        parent::__construct( false, esc_html__('Wiloke Twitter Login', 'wiloke') );
    }

    public function widget( $args, $aInstance )
    {
        if ( is_user_logged_in() )
        {
            return;
        }

        echo $args['before_widget'];

            if ( !empty($aInstance['title']) )
            {
                echo $args['before_title'] . $aInstance['title'] . $args['after_title'];
            }

            echo do_shortcode('[wiloke_twitter_login]');

        echo $args['after_widget'];
    }

    public function update( $aNewInstance, $aOldInstance )
    {
        $aInstance = $aOldInstance;

        foreach ( $aNewInstance as $key => $val )
        {
            $aInstance[$key] = $val;
        }

        return $aInstance;
    }

    public function form( $aInstance )
    {
        include plugin_dir_path(__FILE__) . 'partials/widget-title-field.php';
    }
}
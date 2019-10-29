<?php

/**
 * Create wiloke_twitter_login_tbl as plugin be activated
 *
 * @link        http://demo.wiloke.com
 * @author      Wiloke Team
 * @subpackage  WilokeTwitterLogin/includes
 * @since       1.0
 */

class WilokeTwitterLoginTbl
{
    public function create_tbl()
    {
        $version = '1.0';
        global $wpdb;

        $tblName = WilokeTwitterLogin::table_name();

        $charset_collate = $wpdb->get_charset_collate();

        $sql = "CREATE TABLE $tblName (
            author_id mediumint(9) NOT NULL,
            twitter_id VARCHAR(200) NOT NULL ,
            UNIQUE KEY author_id (author_id)
        ) $charset_collate;";

        require_once( ABSPATH . 'wp-admin/includes/upgrade.php' );
        dbDelta( $sql );

        add_option( 'wiloke_twitter_login_version', $version );
    }
}
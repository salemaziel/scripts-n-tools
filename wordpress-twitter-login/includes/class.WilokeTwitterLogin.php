<?php
/**
 * The class define the core of plugin
 *
 * @link        http://demo.wiloke.com
 * @since       1.0
 * @author      Wiloke Team
 * @package     WilokeTwitterLogin
 * @subpackage  WilokeTwitterLogin/includes
 */

if ( !defined('ABSPATH') )
{
    wp_die( esc_html__('You do not permission to access to this page', 'wiloke') );
}

class WilokeTwitterLogin
{
    /**
     *  Plugin Instance
     *
     * @since 1.0
     * @access Proctected
     */
    protected static $_instance = null;


    /**
     * Loader's instance
     *
     * @var Object
     * @since 1.0
     * @access protected
     */
    protected $_oLoader;

    /**
     * An instance of WilokeTwitterLoginPublic class
     *
     * @var Object
     * @since 1.0
     * @access protected
     */
    protected $_oPublicInstance;

    /**
     * An instance of WilokeTwitterLoginAdmin class
     *
     * @var Object
     * @since 1.0
     * @access protected
     */
    protected $_oAdminInstance;

    /**
     * An instance of WilokeTwitterLoginShortcodes class
     *
     * @var Object
     * @since 1.0
     * @access protected
     */
    protected $_oShortcode;

    /**
     * Cloning is forbidden
     *
     * @since 1.0
     */
    public function __clone()
    {
        _doing_it_wrong( __FUNCTION__, __( 'Cheatin&#8217; huh?', 'wiloke' ), '2.1'  );
    }

    /**
     * Wake up is forbidden
     *
     * @since 1.0
     */
    public function __wakeup()
    {
        _doing_it_wrong( __FUNCTION__, __( 'Cheatin&#8217; huh?', 'wiloke' ), '2.1'  );
    }

    /**
     * Plugin Version
     * @since 1.0
     * @static
     */
    public static $version = '1.0';

    /**
     * The table name of wiloke twitter login
     * @static
     * @access private
     * @since 1.0
     */
    private static $_tblName = 'wiloke_twitter_login';

    /**
     * The name of twitter option
     * @static
     * @access private
     * @since 1.0
     */
    private static $_twitterOption = '_pi_twitter_settings';

    /**
     * Run as soon as plugin init. The function load all front end and backend files, functions.
     */
    public function __construct()
    {
        $this->load_modules();
        $this->register_admin_hooks();
        $this->register_public_hooks();
    }

    /**
     * Return twitter option key
     * @since 1.0
     * @static
     * @return string
     */
    public static function twitter_option()
    {
        return self::$_twitterOption;
    }

    /**
     * Return table name
     * @since 1.0
     * @static
     * @return string
     */
    public static function table_name()
    {
        return self::$_tblName;
    }

    /**
     * Create Wiloke Twitter Table
     * @since 1.0
     * @static
     */
    public static function create_table()
    {
        require_once trailingslashit( plugin_dir_path(__FILE__) ) . 'class.WilokeTwitterLoginTbl.php';
        $tbl = new WilokeTwitterLoginTbl();
        $tbl->create_tbl();
    }

    /**
     * The function loads all modules of the plugin
     *
     * + Wiloke_Loader              : Register all hooks, filters of the plugin
     * + WilokeTwitterLoginAdmin    : What related to admin should ask him
     * + WilokeTwitterLoginPublic   :  What related to front-end should ask him
     *
     * @since 1.0
     */
    public function load_modules()
    {
        include plugin_dir_path(__FILE__) . 'class.WilokeLoader.php';
        include plugin_dir_path(__FILE__) . 'class.WilokeTwitterLoginShortcodes.php';

        include plugin_dir_path( dirname(__FILE__) ) . 'admin/class.WilokeTwitterLoginAdmin.php';
        include plugin_dir_path( dirname(__FILE__) ) . 'public/class.WilokeTwitterLoginPublic.php';

        $this->_oLoader      = new Wiloke_Loader();
        $this->_oShortcode   = new WilokeTwitterLoginShortcodes();
    }

    /**
     * A collection of Front-end actions, filters will be registered here.
     *
     * @since 1.0
     * @access Protected
     */
    protected function register_public_hooks()
    {
        $this->_oPublicInstance = new WilokeTwitterLoginPublic();
//        $this->_oLoader->add_action('init', $this->_oPublicInstance, 'test');


        $this->_oLoader->add_action('wp_ajax_nopriv_wiloke_twitter_login_request_token', $this->_oPublicInstance, 'request_token');
        $this->_oLoader->add_action('wiloke_twitter_login_sc', $this->_oPublicInstance, 'render_sc_btn', 20, 1);
        $this->_oLoader->add_action('login_form', $this->_oPublicInstance, 'render_sc_btn', 20, 1);
        $this->_oLoader->add_action('login_enqueue_scripts', $this->_oPublicInstance, 'wp_head', 20, 1);
        $this->_oLoader->add_action('login_enqueue_scripts', $this->_oPublicInstance, 'enqueue_scripts');
        $this->_oLoader->add_action('wp_enqueue_scripts', $this->_oPublicInstance, 'enqueue_scripts');
        $this->_oLoader->add_action('wp_head', $this->_oPublicInstance, 'wp_head');

        $this->_oLoader->add_action('woocommerce_before_my_account', $this->_oPublicInstance, 'wp_head');
        $this->_oLoader->add_action('admin_notices', $this->_oPublicInstance, 'remind_to_enter_email');
        $this->_oLoader->add_action('woocommerce_account_content', $this->_oPublicInstance, 'remind_to_enter_email');

        $this->_oLoader->add_action('init', $this->_oPublicInstance, 'handle_twitter_login');

        $this->_oLoader->add_filter('get_avatar', $this->_oPublicInstance, 'get_twitter_avatar', 20, 5);
    }

    /**
     * A collection of Admin actions, filters will be registered here.
     *
     * @since 1.0
     * @access Protected
     */
    protected function register_admin_hooks()
    {
        $this->_oAdminInstance = new WilokeTwitterLoginAdmin();
        $this->_oLoader->add_action('admin_menu', $this->_oAdminInstance, 'add_menu_items');
        $this->_oLoader->add_action('wiloke_twitter_login_fields', $this->_oAdminInstance, 'create_settings');
    }

    /**
     * Ensures that only the instance is loaded and can be loaded
     * @since 1.0
     * @static
     * @return Instance of WilokeTwitterLogin
     */
    public static function instance()
    {
        if ( self::$_instance === null )
        {
            self::$_instance = new self();
        }

        return self::$_instance;
    }

    /**
     * Callback to functions, which have been registered above
     * @since 1.0
     */
    public function run()
    {
        $this->_oLoader->run();
    }

}
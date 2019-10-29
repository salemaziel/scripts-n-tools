<?php

/**
 * The class handles everything related to front-end
 *
 * @link        http://demo.wiloke.com
 * @since       1.0
 * @author      Wiloke Team
 * @package     WilokeTwitterLogin
 * @subpackage  WilokeTwitterLogin/public
 */

class WilokeTwitterLoginPublic
{
    /**
     * Cookie Key
     * @since 1.0
     */
    public $sessionKey       = 'wiloke_twitter_login_granted_permission';
    public $sessionAuthToken = 'wiloke_twitter_oauth_data';
    public $sessionRedirect  = 'wiloke_redirect_to';

    /**
     * Render shortcode button
     * @since 1.0
     */
    public function render_sc_btn($atts)
    {
        $redirect = apply_filters( 'wiloke-twitter-login/redirect_url', ( is_ssl() ? 'https://' : 'http://' ) . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] );

        // if we are in login page we don't want to redirect back to it
        if ( isset( $GLOBALS['pagenow'] ) && in_array( $GLOBALS['pagenow'], array( 'wp-login.php', 'wp-register.php' ) ) )
            $redirect = apply_filters( 'wiloke-twitter-login/redirect_url', '');

        echo  apply_filters('wiloke-twitter-login/login_button', '<a href="#" class="btn btn--social twitter wiloke-twitter-login-css wiloke-twitter-login-js" data-redirect="'.esc_url($redirect).'" data-wiloke_twitter_login_nonce="' . wp_create_nonce( 'wiloke-twitter-login-nonce' ).'"><i class="fa fa-twitter"></i>'.esc_html__('Login With Twitter', 'wiloke').'</a>');
    }

    /**
     * Enqueue Scripts
     * @since 1.0
     */
    public function enqueue_scripts()
    {
        wp_enqueue_style('wiloke_twitter_login', trailingslashit( plugin_dir_url(__FILE__) ) . '/source/css/style.css');
        wp_enqueue_script('wiloke_twitter_login', trailingslashit( plugin_dir_url(__FILE__) ) . '/source/js/script.js', array('jquery'), '1.0', true );
    }

    /**
     * Hook into wp_head
     * @since 1.0
     */
    public function wp_head()
    {
        ?>
        <script type="text/javascript">
            var WilokeTwitterLoginAjaxUrl = "<?php echo admin_url('admin-ajax.php'); ?>";
        </script>
        <?php
    }

    /**
     * Request Token after ajax callback
     * @since 1.0
     */
    public function request_token()
    {
        $verifyNonce = check_ajax_referer('wiloke-twitter-login-nonce', 'security', false);

        if ( !$verifyNonce )
        {
            wp_send_json_error();
        }

        $aTwitterOptions = get_option(WilokeTwitterLogin::twitter_option());

        if ( empty($aTwitterOptions) )
        {
            wp_send_json_error();
        }

        $_SESSION[$this->sessionRedirect] = isset($_POST['redirect']) && !empty($_POST['redirect']) ? $_POST['redirect'] : home_url('/');

        include trailingslashit( plugin_dir_path( dirname(__FILE__) ) ) . 'includes/libs/TweetSweep/init.php';

        $tmhOAuth = new tmhOAuth(array(
            'consumer_key'    => $aTwitterOptions['consumer_key'],
            'consumer_secret' => $aTwitterOptions['consumer_secret'],
            'user_token'      => $aTwitterOptions['access_token'],
            'user_secret'     => $aTwitterOptions['access_token_secret'],
        ));

        $code = $tmhOAuth->request('POST', $tmhOAuth->url('oauth/request_token', ''));


        if ($code == 401)
        {
            $code = tmhUtilities::auto_fix_time_request($tmhOAuth, 'POST', $tmhOAuth->url('oauth/request_token'));
        }


        if ( $code == 200 )
        {
            $oResponse                          = $tmhOAuth->extract_params($tmhOAuth->response['response']);
            $url                                = $tmhOAuth->url('oauth/authenticate?'.$tmhOAuth->response['response']);
            $_SESSION[$this->sessionKey]        = 'yes';
            $_SESSION[$this->sessionAuthToken]  = $oResponse['oauth_token'];
            wp_send_json_success( array('url'=>$url) );
        }

        wp_send_json_error();

    }

    /**
     * The function will handle when we receive a request of twitter login
     * If the customer has already registered an account, allowing access to our website
     * Else create an account for him/her
     * @since 1.0
     */
    public function handle_twitter_login()
    {
        $isSessionStart = true;
        if ( function_exists('session_status') )
        {
            if (session_status() == PHP_SESSION_NONE) {
                $isSessionStart = false;
            }
        }else{
            if(session_id() == '')
            {
                $isSessionStart = false;
            }
        }

        if ( !$isSessionStart )
        {
            session_start();
        }

        if ( !isset($_SESSION[$this->sessionKey]) || empty($_SESSION[$this->sessionKey]) )
        {
            return;
        }

        unset($_SESSION[$this->sessionKey]);

        $aTwitterOptions = get_option(WilokeTwitterLogin::twitter_option());

        if ( empty($aTwitterOptions) )
        {
            return false;
        }

        include trailingslashit( plugin_dir_path( dirname(__FILE__) ) ) . 'includes/libs/TweetSweep/init.php';

        $tmhOAuth = new tmhOAuth(array(
            'consumer_key'    => $aTwitterOptions['consumer_key'],
            'consumer_secret' => $aTwitterOptions['consumer_secret'],
            'user_token'      => $aTwitterOptions['access_token'],
            'user_secret'     => $aTwitterOptions['access_token_secret'],
        ));

        $aUserInfo = $this->user_state($tmhOAuth);

        if ( !$aUserInfo )
        {
            return;
        }

        if ( isset($aUserInfo['author_id']) && !empty($aUserInfo['author_id']) )
        {
            $aUserInfo['author_id'] = absint($aUserInfo['author_id']);
            $this->loginProcess($aUserInfo['author_id'], $aUserInfo);
        }elseif ( isset($aUserInfo['process_register']) && $aUserInfo['process_register'] )
        {
            $this->register_process($tmhOAuth, $aUserInfo['data']);
        }
    }

    /**
     * Whether User is exist or no
     *
     * @since 1.0
     * @return false if the user doesn't exist else return $authorID
     * @access protected
     */
    protected function user_state($tmhOAuth)
    {
        if ( isset($_REQUEST['oauth_token']) && !empty($_REQUEST['oauth_token']) && isset($_REQUEST['oauth_verifier']) && !empty($_REQUEST['oauth_verifier']) )
            {
                $oauthAccessToken = $this->getAccessToken($tmhOAuth);

                if ( $oauthAccessToken === false )
                {
                    return false;
                }

                $oauthAccessToken = (object)$oauthAccessToken;

                global $wpdb;
                $tblName = WilokeTwitterLogin::table_name();
                $sql = $wpdb->prepare(
                    "
                      SELECT author_id 
                      FROM $tblName
                      WHERE twitter_id = %d
                    ",
                    $oauthAccessToken->user_id
                );

                $authorID = $wpdb->get_var($sql);

                if ( $authorID )
                {
                    return array('author_id'=>$authorID, 'screen_name'=>$oauthAccessToken->screen_name);
                }

                return array('process_register'=>true, 'data'=>$oauthAccessToken);
            }

        return false;
    }

    /**
     * Request author access token
     *
     * @since 1.0
     * @return array
     */
    private function getAccessToken($tmhOAuth)
    {
        $oauth_token  = $_SESSION[$this->sessionAuthToken];
        unset($_SESSION[$this->sessionAuthToken]);

        $params = array(
            'oauth_verifier' => $_REQUEST['oauth_verifier']
        );

        $tmhOAuth->config['user_token']  = $oauth_token;

        $code = $tmhOAuth->request('POST', $tmhOAuth->url('oauth/access_token', ''), $params);

        if ($code == 401)
        {
            $code = tmhUtilities::auto_fix_time_request($tmhOAuth, 'POST', $tmhOAuth->url('oauth/access_token', ''));
        }

        if ($code == 200)
        {
            $access_token = $tmhOAuth->extract_params($tmhOAuth->response['response']);

            return $access_token;
        }

        return false;
    }

    /**
     * Register user
     * @since 1.0
     */
    protected function register_process($tmhOAuth, $oUser)
    {
        $params = array(
            'include_email'      => true
        );

        $tmhOAuth->config['user_token']     = $oUser->oauth_token;
        $tmhOAuth->config['user_secret']    = $oUser->oauth_token_secret;

        $code = $tmhOAuth->request('GET', $tmhOAuth->url('1.1/account/verify_credentials', 'json'), $params);

        if ($code == 401)
        {
            $code = tmhUtilities::auto_fix_time_request($tmhOAuth, 'GET', $tmhOAuth->url('1.1/account/verify_credentials', 'json'));
        }

        if ( $code === 200 )
        {
            $oUserInfoDetail = json_decode($tmhOAuth->response['response']);

            $user = apply_filters( 'wiloke-twitter-login/user_data_login', array(
                'wiloke_user_id' => $oUserInfoDetail->id,
                'user_login'     => $oUser->screen_name,
                'first_name'     => $oUserInfoDetail->name,
                'description'    => $oUserInfoDetail->description,
                'last_name'      => 'Wiloke',
                'user_email'     => '',
                'user_url'       => $oUserInfoDetail->url,
                'user_pass'      => wp_generate_password(),
            ));

            if( get_option('users_can_register') && apply_filters( 'wiloke-twitter-login/registration_disabled', true ) )
            {
                // generate a new username
                $user['user_login'] = apply_filters( 'wiloke-twitter-login/generateUsername', $this->generateUsername( $user ) );

                $user_id = $this->register_user( apply_filters( 'wiloke-twitter-login/user_data_register', $user) );

                if( !is_wp_error( $user_id ) )
                {
                    $this->notify_new_registration( $user_id );
                    update_user_meta( $user_id, '_wiloke_user_id', array(
                        'twitter_id'                =>  $user['wiloke_user_id'],
                        'profile_image_url'         =>  $oUserInfoDetail->profile_image_url,
                        'profile_image_url_https'   =>  $oUserInfoDetail->profile_image_url_https
                    ));
                    $this->insertUserToTwitterLogin($user_id, $user['wiloke_user_id']);
                    $user_id = absint($user_id);
                    $this->loginProcess($user_id, $oUser);
                }
            }
        }
    }

    /**
     * Insert author id to wiloke_twitter_login
     * @since 1.0
     */
    private function insertUserToTwitterLogin($userID, $twitterID)
    {
        global $wpdb;

        $wpdb->insert(
            WilokeTwitterLogin::table_name(),
            array(
                'author_id' => $userID,
                'twitter_id'=> $twitterID
            ),
            array(
                '%d',
                '%d'
            )
        );
    }

    /**
     * Register new user
     * @param $user Array of user values captured in fb
     *
     * @return int user id
     */
    private function register_user( $user ) {
        return wp_insert_user( $user );
    }

    /**
     * Send notifications to admin and bp if active
     * @param $user_id
     */
    private function notify_new_registration( $user_id ) {
        // Notify the site admin of a new user registration.
        wp_new_user_notification( $user_id );
        do_action( 'wiloke-twitter-login/notify_new_registration', $user_id );
        // bp notifications
        // fires xprofile_sync_wp_profile, bp_core_new_user_activity, bp_core_clear_member_count_caches
        do_action( 'bp_core_activated_user', $user_id );
    }

    /**
     * Generated a friendly username for facebook users
     * @param $user
     *
     * @return string
     */
    private function generateUsername( $user )
    {
        global $wpdb;

        do_action( 'wiloke-twitter-login/generateUsername', $user );

        if( !empty( $user['user_login'] ) && !empty( $user['user_login'] ) )
        {
            $username = $this->cleanUsername( trim( $user['user_login'] ) );
        }

        if( !validate_username( $username ) ) {
            $username = '';
            // use email
            $email    = explode( '@', $user['email'] );
            if( validate_username( $email[0] ) )
            {
                $username = $this->cleanUsername( $email[0] );
            }
        }

        // User name can't be on the blacklist or empty
        $illegal_names = get_site_option( 'illegal_names' );
        if ( empty( $username ) || in_array( $username, (array) $illegal_names ) ) {
            // we used all our options to generate a nice username. Use id instead
            $username = 'wiloke_' . $user['user_login'] . $user['id'];
        }

        // "generate" unique suffix
        $suffix = $wpdb->get_var( $wpdb->prepare(
            "SELECT 1 + SUBSTR(user_login, %d) FROM $wpdb->users WHERE user_login REGEXP %s ORDER BY 1 DESC LIMIT 1",
            strlen( $username ) + 2, '^' . $username . '(-[0-9]+)?$' ) );

        if( !empty( $suffix ) )
        {
            $username .= "-{$suffix}";
        }

        return apply_filters( 'wiloke-twitter-login/generateUsername', $username );
    }

    /**
     * Simple pass sanitazing functions to a given string
     * @param $username
     *
     * @return string
     */
    private function cleanUsername( $username )
    {
        return sanitize_title( str_replace('_','-', sanitize_user($username) ) );
    }

    /**
     * Allow customer log in to website
     * @since 1.0
     */
    private function loginProcess($user_id, $oUser=array())
    {
        if( is_numeric( $user_id ) )
        {
            wp_set_auth_cookie( $user_id, true );

            $oUserInfo = get_userdata($user_id);

            if ( !empty($oUserInfo->user_email) )
            {
                $redirect = $_SESSION[$this->sessionRedirect];
            }else{
                if ( function_exists('is_woocommerce') )
                {
                    $redirect = get_permalink(get_option('woocommerce_myaccount_page_id'));
                }else{
                    $redirect = admin_url('profile.php');
                }
            }

            if ( is_array($oUser) )
            {
                $oUser = (object)$oUser;
            }

            do_action('wiloke-twitter-login/before_redirect_user', $user_id, $oUser);

            unset($_SESSION[$this->sessionRedirect]);
            wp_redirect( esc_url($redirect) );
            exit();
        }
    }

    /**
     * Remind customer to enter his email address
     * @since 1.0
     */
    public function remind_to_enter_email()
    {
        $userID     = get_current_user_id();
        $oUserInfo  = get_userdata($userID);

        if ( empty($oUserInfo->user_email) ) :
        ?>
            <div class="text-center notice is-error">
                <p><?php esc_html_e( 'Hi there! Please enter your email address to complete the registration.', 'wiloke' ); ?></p>
            </div>
        <?php

        endif;
    }

    /**
     * Printer Twitter Avatar instead of default
     * @since 1.0
     */
    public function get_twitter_avatar($avatar, $id_or_email, $size, $default, $alt)
    {
        $user = false;

        if ( is_numeric( $id_or_email ) ) {

            $id   = (int) $id_or_email;
            $user = get_user_by( 'id', $id );

        } elseif ( is_object( $id_or_email ) ) {

            if ( ! empty( $id_or_email->user_id ) ) {
                $id   = (int) $id_or_email->user_id;
                $user = get_user_by( 'id', $id );
            }

        } else {
            $user = get_user_by( 'email', $id_or_email );
        }
        // If somehow $id hasn't been assigned, return the result of get_avatar.
        if ( empty( $user ) ) {
            return !empty( $avatar ) ? $avatar : $default;
        }

        // Image alt tag.
        if ( empty( $alt ) ) {
            if ( function_exists( 'bp_core_get_user_displayname' ) )
                $alt = sprintf( esc_html__( 'Profile photo of %s', 'buddypress' ), bp_core_get_user_displayname( $id ) );
            else
                $alt = esc_html__( 'Twitter Profile photo', 'wiloke' );
        }

        if ( $user && is_object( $user ) ) {
            $user_id = $user->data->ID;

            // get avatar with facebook id
            if ( $twitterAvatar = get_user_meta( $user_id, '_wiloke_user_id', true ) ) {

                $twitterAvatar = is_ssl() ? $twitterAvatar['profile_image_url_https'] : $twitterAvatar['profile_image_url'];
                $avatar = "<img alt='{$alt}' src='{$twitterAvatar}' class='avatar avatar-{$size} photo' height='{$size}' width='{$size}' />";

            }

        }

        return $avatar;
    }
}
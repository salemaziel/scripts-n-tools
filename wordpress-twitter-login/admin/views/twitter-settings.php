<form action="<?php echo admin_url('options-general.php?page=twitter_login'); ?>" method="POST">
    <table class="form-table">
        <?php do_action('wiloke_twitter_login_fields'); ?>
        <?php wp_nonce_field('wiloke_twitter_login_nonce', 'wiloke_twitter_login_nonce_field'); ?>
    </table>
    <?php submit_button(); ?>
</form>
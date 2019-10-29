<p>
    <label class="widget-title" for="<?php echo esc_attr($this->get_field_id('title')); ?>"><?php esc_html_e('Title', 'wiloke'); ?></label>
    <input type="text" id="<?php echo esc_attr($this->get_field_id('title')); ?>" class="widefat" name="<?php echo esc_attr($this->get_field_name('title')); ?>" value="<?php echo esc_attr($aInstance['title']); ?>" />
</p>
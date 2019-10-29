<tr>
    <th scope="row"><label for="access-token"><?php esc_html_e('Consumer Secret', 'wiloke'); ?></label>
    </th>
    <td>
        <input id="access-token" type="text" name="twitter[consumer_secret]" value="<?php echo esc_attr($aTwitter['consumer_secret']); ?>" required />
    </td>
</tr>
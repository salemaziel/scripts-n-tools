<tr>
    <th scope="row"><label for="access-token"><?php esc_html_e('Access Token Secret', 'wiloke'); ?></label>
    </th>
    <td>
        <input id="access-token" type="text" name="twitter[access_token_secret]" value="<?php echo esc_attr($aTwitter['access_token_secret']); ?>" required />
    </td>
</tr>
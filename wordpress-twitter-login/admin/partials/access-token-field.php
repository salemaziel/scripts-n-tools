<tr>
    <th scope="row"><label for="access-token"><?php esc_html_e('Secret Access', 'wiloke'); ?></label>
    </th>
    <td>
        <input id="access-token" type="text" name="twitter[access_token]" value="<?php echo esc_attr($aTwitter['access_token']); ?>" required />
    </td>
</tr>
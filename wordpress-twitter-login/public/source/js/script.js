;(function ($) {
    "use strict";
    
    $(document).ready(function () {
         $('.wiloke-twitter-login-js').on('click', function (event) {
             event.preventDefault();

             var $this      = $(this),
                 _nonce     = $this.data('wiloke_twitter_login_nonce'),
                 _redirect  = $this.data('redirect');

             if ( $this.data('is_ajax') === true )
             {
                 return;
             }

             $this.html('<i class="fa fa-twitter"></i> Connecting');

             $this.data('js_ajax', true);

             $.ajax({
                 method: 'POST',
                 data: {action: 'wiloke_twitter_login_request_token', security:_nonce, redirect: _redirect},
                 url: WilokeTwitterLoginAjaxUrl,
                 success: function (data) {
                     console.log(data);
                    if ( data.success == true )
                    {
                        $this.data('js_ajax', false);
                        window.location.href = data.data.url;
                    }else{
                        $this.data('js_ajax', false);
                    }
                 }
             })
         })
    });
    
})(jQuery);
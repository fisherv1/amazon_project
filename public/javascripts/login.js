 
jQuery.ajaxSetup({
    'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "text/javascript")
    }
});

/* Authenticity token*/
$(document).ready(function() {
    // All non-GET requests will add the authenticity token
    // if not already present in the data packet
    $("body").bind("ajaxSend", function(elm, xhr, s) {
        if (s.type == "GET") return;
        if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + "="))) return;
        if (s.data) {
            s.data = s.data + "&";
        } else {
            s.data = "";
            // if there was no data, jQuery didn't set the content-type
            xhr.setRequestHeader("Content-Type", s.contentType);
        }
        s.data = s.data + encodeURIComponent(window._auth_token_name)
        + "=" + encodeURIComponent(window._auth_token);
    });
});


$(function() {
    jQuery.fn.submitWithAjax = function($callback) {
        this.live('submit', function() {
            $.post($(this).attr("action"), $(this).serialize(), $callback, "script");
            return false;
        });
        return this;
    };

});
$(function() {
    $(document).ready(function() {
        $(".ajax_form").submitWithAjax();
    });
}
);





$(function() {
    $('#login_assistant').live('click', function(){
        $('#login_help_screen').dialog( {
            modal: true,
            resizable: false,
            draggable :false,
            height: 300,
            width: 575
        }
        );
        $("#login_help_screen").parent().css('background-color','#D1DDE6');
        $("#login_help_screen").css('background-color','#D1DDE6');
        $('#login_help_screen').dialog('option', 'title', 'Login Assistant');
        $(".login_help_content").show();
        $("#login_help_screen").dialog("open");
    });

}
)



$(function() {
    $('#forgot_password').live('click', function(){
        $('#login_help_screen').dialog('close');
        $('#login_password_reset').dialog( {
            modal: true,
            resizable: false,
            draggable :false,
            height: 350,
            width: 575
        }

        );
        $("#login_password_reset").parent().css('background-color','#D1DDE6');
        $("#login_password_reset").css('background-color','#D1DDE6');
        $('#login_password_reset').dialog('option', 'title', 'Password Reset');
        $('#login_password_reset').dialog("open");
        $("#password_reset_username").val("");
        $("#password_reset_email_address").val("");
        $("#password_reset_username").attr("disabled", false);
        $("#password_reset_email_address").attr("disabled", false);
        $.ajax({
            type: "GET",
            url: "/signin/captcha",
            data: '',
            dataType: "script"
        });
        $("#password_reset_submit").show();
        $("#password_captcha").show();
        $(".login_help_content").show();
        $("#login_password_reset_security_questions").html("<div id='login_password_reset_security_questions'></div>");
        $("#login_password_reset_security_questions").html("<div id='login_password_reset_security_questions' style='display:none;'></div>");
    });

}
)


$(function() {
    $('#forgot_username').live('click', function(){
        $('#login_help_screen').dialog('close');
        $('#login_username_retrieval').dialog( {
            modal: true,
            resizable: false,
            draggable :false,
            height: 315,
            width: 575
        }

        );
        $('#login_username_retrieval').dialog('option', 'title', 'Username Retrieval');
        $("#login_username_retrieval").parent().css('background-color','#D1DDE6');
        $("#login_username_retrieval").css('background-color','#D1DDE6');
        $('#login_username_retrieval').dialog("open");
        $("#username_retrieval_email_address").val("");
        $("#username_retrieval_email_address").attr("disabled", false);
        $("#username_retrieval_submit").show();
        $.ajax({
            type: "GET",
            url: "/signin/captcha",
            data: '',
            dataType: "script"
        });

        $("#username_retrieval_submit").show();

        $("#username_retrieval_captcha").show();
        $(".login_help_content").show();
        $("#username_retrieval_security_questions").html("<div id='username_retrieval_security_questions' style='display:none;'></div>");
        $("#username_retrieval_error_messages").html("<div id='username_retrieval_error_messages' style='display:none;'></div>");

    });

}
)


$(function() {
    $('#regenerate_captcha').live('click', function(){
        $.ajax({
            type: "GET",
            url: "/signin/captcha",
            data: '',
            dataType: "script"
        });
    });
});
$(function($) {
    $('.jclock').jclock();
    $('#clocktime').val($('.jclock').html());
});

$(function($) {
    var options = {
        format: '%d-%m-%Y'
    }

    $('.jclock_date').jclock(options);
    $('#clocktime_date').val($('.jclock_date').html());
});

$(function(){    
    if(!$.browser.mozilla){
        $('#browser_check').dialog( {
        modal: true,
        resizable: false,
        draggable: true,
        height: 'auto',
        width: 800,
        buttons: {
          Ok: function() {
            $(this).dialog('destroy');
            return true;
          }
        }
      });
    }
    //window.open(location.href,'windowName','toolbar=no');
});
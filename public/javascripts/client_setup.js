/* Powernet Menu Module*/
$(function(){
    $(".switch_module_status").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/available_modules/switch_status.js",
            data: 'id=' + $(this).attr("module_id"),
            dataType: "script"
        });
    });
});


$(function() {
    $(".password").jpassword({
        lang: {
            please: "please type password over 6 characters",
            low: "Low security.",
            correct: "Correct security.",
            high: "High security.",
            length: "-X- characters would be a plus.",
            number: "Why not numbers?",
            uppercase: "And caps?",
            lowercase: "Some tiny?",
            punctuation: "Punctuations?",
            special: "Best, special characters?"
        },
        length: 6
    });
});



$(function(){
    $("#hide_feedback_reply").live('click', function(){
        $("#hide_feedback_reply").hide();
        $("#display_feedback_reply").show();
        $("#feedback_reply").hide();
    });
});

//Member Zone Super User Password Confirmation
$(function(){
    $("#repeat_password").live('change', function(){
        if ($(this).val()!= $('#password').val()){
            $('#password').val('');
            $(this).val('');
            $('#password_submit').attr('disabled',true);
            $('#password_error').dialog( {
                modal: true,
                resizable: true,
                draggable: true,
                buttons: {
                    OK: function(){
                        $(this).dialog('destroy');
                        return true;

                    }
                }
            });
            $('#password_error').parent().find("a").css("display","none");
            $("#password_error").parent().css('background-color','#D1DDE6');
            $("#password_error").css('background-color','#D1DDE6');
            $('#password_error').dialog('option', 'title', 'Error');
            $('#password_error').dialog('open');
            $('#password_submit').attr('disabled',true);
        }else{
            $('#password_submit').attr('disabled',false);
        }
    });


});

$(function(){
    $("#user_name").blur(function(){
        $.ajax({
            type: "GET",
            url: "/client_setups/system_log_verify_user_name.js",
            data: 'user_name='+$(this).val(),
            dataType: "script"
        });

    });
});



$(function(){
    $("#archive_user_name").blur(function(){
        $.ajax({
            type: "GET",
            url: "/client_setups/system_log_archive_verify_user_name.js",
            data: 'user_name='+$(this).val(),
            dataType: "script"
        });

    });
});





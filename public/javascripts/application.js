// All ajax requests will trigger the wants.js block
// of +respond_to do |wants|+ declarations

$(function(){
    $("#tabs").tabs();
});

$(function(){
    $("#tabs2").tabs();
});

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
    // All A tags with class 'get', 'post', 'put' or 'delete' will perform an ajax call
    $('a.get').live('click', function() {
        var link = $(this);
        $.get(link.attr('href'), null ,null, 'script');
        return false;
    }).attr("rel", "nofollow");

    //To use this function, please add data_id attributes to the link and the element id point to should be the form
    $('a.post').live('click', function(){
        $.post($(this).attr('href'), $("#" + $(this).attr("data_id")).serialize(),null,'script');
        return false;
    }).attr("rel", "nofollow");

    $('a.put').live('click', function() {
        var link = $(this);
        $.post($(this).attr('href'), "_method=put", null, 'script');
        return false;
    }).attr("rel", "nofollow");

    $('a.delete').live('click', function() {
        var link = $(this);
        $.post($(this).attr('href'), "_method=delete", null, 'script');
        return false;
    }).attr("rel", "nofollow");

    jQuery('a.get, a.post, a.put, a.delete').removeAttr('onclick');
});

jQuery.fn.submitWithAjax = function($callback) {
    this.live('submit', function() {
        $.post($(this).attr("action"), $(this).serialize(), $callback, "script");
        return false;
    });
    return this;
};

jQuery.fn.doAjaxSubmit = function($callback) {
    $.post($(this).attr("action"), $(this).serialize(), $callback, "script");
    return false;
};

$(document).ready(function() {
    $(".ajax_form").submitWithAjax();
});

/*Date picker */
$('.birthdatepick').live("mouseover", function(){
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true,
        maxDate: '+0d',
        yearRange: '-150:+0'
    });
});


$('.startdatepick').live("mouseover", function(){
    $("#"+$(this).attr("end_date")).datepicker('enable');
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true
    });
});



$('.enddatepick').live("mouseover", function(){
    var arr_dateText = $("#"+$(this).attr("start_date")).val().split("-");
    day = arr_dateText[0];
    month = arr_dateText[1];
    year = arr_dateText[2];
    //init
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true,
        minDate: new Date(year, month-1, day)
    });

    //reset
    if(year!=undefined){
        $(this).datepicker('option', 'minDate', new Date(year, month-1, day));
    }else{
        $(this).datepicker('disable');
    }
});

$('.datepick').live("mouseover", function(){
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true
    });
});


/* Photo */

$("#edit_photo_link").live("click",function() {
    $("#edit_photo").toggle('blind');
    return false;
});

/*Keywords*/
showKeyword = function(){
    $("#add_keywords option:selected").removeAttr("selected");
    $("#add_keywords").find("option").hide();
    $("#keyword_types").find("option:selected").each(function(){
        if($(this).val() == ""){
            $("#add_keywords").find("option").show();
        }else{
            $("#add_keywords option[class=" + $(this).text() + "]").show();
        }
    });
}

showTooltip = function(){
    $("#add_keywords option ,#remove_keywords option").each(function(){
        $(this).qtip({
            content: $(this).attr('remark'),
            position: {
                corner: {
                    target: 'leftMiddle',
                    tooltip: 'rightMiddle'
                }
            },
            style : {
                tip: true
            }
        });
    });
}

$(document).ready(function(){
    showKeyword();
    showTooltip();
});

$("#keyword_types").live("change", showKeyword);

/* Relationships */
$(function(){
    $("input[type='text']#relationship_related_person_id").change(function(){
        $.ajax({
            type: "GET",
            url: "/people/name_finder.js",
            data: 'person_id='+$(this).val(),
            dataType: "script"
        });
    });
});

$(function(){
    $('table#search_results tbody tr').live('click',function(){
        $.ajax({
            type: 'GET',
            url: "/people/"+$(this).attr('person_id')+"/name_card.js",
            dataType: "script"
        });
        $('table#search_results tbody tr.selected').removeClass('selected');
        $(this).addClass("selected");

    });
});


/* Show Summary list*/
$(function(){
    $('table#search_list_results tbody tr').live('click',function(){   
        $.ajax({
            type: 'GET',
            url: "/people/show_left.js",
            data: 'person_id='+$(this).attr('id').substring(3)+'&current_operation='+ $('#search_list_results').attr('current_operation'),
            dataType: "script"
        });      
        $('table#search_list_results tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass("trSelected");
        
    });
});


/*role*/


$(function(){
    $(".find_role_field").live('change',function(){
        $.ajax({
            type: "GET",
            url: "/people/"+$(this).attr('person_id')+"/roles/get_roles.js",
            data: 'role_type_id='+$(this).val()+'&person_role_id='+$(this).attr('person_role_id'),
            dataType: "script"
        });
    });
});



$(function(){
    $(".check_person_field").live('change', function(){
        $.ajax({
            type: "GET",
            url: "/people/role_finder.js",
            data: 'person_id='+$(this).val()+'&update='+$(this).attr('update')+'&person_role_id='+$(this).attr('person_role_id'),
            dataType: "script"
        });
    });
});


/* Employment Tab*/

$(function(){
    $(".find_organisation_field").live('change', function(){
        if($(this).val() != ""){
            $.ajax({
                type: "GET",
                url:
                "/organisations/name_finder.js",
                data:
                'organisation_id='+$(this).val()+'&employment_id='+$(this).attr('employment_id'),
                dataType: "script"
            });
        }else{
            $("#organisation_name_container_"+$(this).attr('employment_id')).html(" ");
        }
    });
});

$(function(){
    $(".find_person_field").live('change', function(){
        if($(this).val() != ""){
            $.ajax({
                type: "GET",
                url:
                "/people/name_finder.js",
                data:
                'person_id='+$(this).val()+'&update='+$(this).attr('update')+'&employment_id='+$(this).attr('employment_id'),
                dataType: "script"
            });
        }else{
            $("#"+$(this).attr('update')+"_"+$(this).attr('employment_id')).val("");
        }
    });
});

$(function(){
    $(".calculate_field").live('change', function(){
        _valid = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test($(this).val());
        if (_valid)
        {
            _salary = $("#hour_"+$(this).attr("employment_id")).val() * $("#rate_"+$(this).attr("employment_id")).val() * 52;
            $("#salary_"+$(this).attr("employment_id")).val(formatCurrency(_salary));
        }else{
            alert("This field has be a number!");
            $(this).focus();
            $(this).val(0);
            $("#salary_"+$(this).attr("employment_id")).val(formatCurrency(0));
        }
    });
});

/* Person_Group */

$(function()
{
    $(".show_group_type").live('change', function(){
        /*   if($(this).val()!= ""){  */
        $.ajax({
            type: "GET",
            url: "/tag_meta_types/show_group_types.js",
            data: 'group_meta_meta_type_id='+$(this).val()+'&person_group_id='+$(this).attr('person_group_id'),
            dataType: "script"
        });

    /* }
        else{
            if($(this).attr('person_group_id').val()!="")
                {
                    $(".find_group_meta_type[person_group_id='"+ $(this).attr("person_group_id") +"']").html(" ")
             $("#person_group_id[person_group_id='"+ $(this).attr("person_group_id") +"']").html(" ")
                    
                }
                else {
            $(".find_group_meta_type").html(" ")
            $("#person_group_id").html(" ")}
        } */
    });


})


/* show other group member */
$(function(){
    $("#show_other_group_members").live('click',function(){
        $.ajax({
            type: "GET",
            url: "/people/"+$(this).attr('person_id')+"/person_groups/show_group_members.js",
            data: 'person_group_id='+$(this).attr('person_group_id'),
            dataType: "script"

        });
    });
});

$(function(){
    $("#show_other_group_members_organisations").live('click',function(){
        $.ajax({
            type: "GET",
            url: "/organisations/"+$(this).attr('organisation_id')+"/organisation_groups/show_group_members.js",
            data: 'organisation_group_id='+$(this).attr('organisation_group_id'),
            dataType: "script"

        });
    });
});





/* Show_group */
$(function(){
    $(".find_group_meta_type").live('change',function(){
        $.ajax({
            type: "GET",
            url: "/tag_types/show_types.js",
            data: 'group_meta_type_id='+$(this).val(),
            dataType: "script"

        });
    });
});

/* Show Group Description */

$(function(){
    $("#group_id").live('change',function(){
        $.ajax({
            type: "GET",
            url: "/tags/show_group_description.js",
            data: 'group_id='+$(this).val(),
            dataType: "script"

        });
    });
});


/* MasterDoc */
$(function(){
    $(".find_master_doc_meta_type_field").live('change', function(){
        $.ajax({
            type: "GET",
            url:
            "/people/master_doc_meta_type_finder.js",
            data:
            'id='+$(this).val()+'&master_doc_id='+$(this).attr('master_doc_id'),
            dataType: "script"
        });
    });
});


$(function(){
    $(".find_master_doc_type_field").live('change', function(){
        $.ajax({
            type: "GET",
            url:
            "/people/master_doc_type_finder.js",
            data:
            'id='+$(this).val()+'&master_doc_id='+$(this).attr('master_doc_id'),
            dataType: "script"
        });
    });
});

formatCurrency= function(num){
    num = num.toString().replace(/\$|\,/g,'');
    if(isNaN(num))
        num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num*100+0.50000000001);
    cents = num%100;
    num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+','+
        num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + '$' + num + '.' + cents);
}




// Administration Menu

$(function(){
    $(".close_option").live('click', function(){
        $("#system_data_add_entry_form").hide();
        $("#custom_group_entry_form").hide();
        $("#query_table_add_entry_form").hide();
        $("#access_permission_add_entry_form").hide();
    });
});

// Configuration

//Admin - System Data Tab

$(function(){
    $("#system_data_type").live('change', function(){
        if($(this).val()==""){
            $("#system_data_main_contents").hide();
            $("#system_data_entries").html("");
            $("#edit_system_data_entry").html("");
        } else {
            $("#edit_system_data_entry").html("");
            $("#amazon_setting_type").val($(this).val());
            $.ajax({
                type: "GET",
                url: "/amazon_settings/system_settings_finder.js",
                data: 'type=' + $(this).val(),
                dataType: "script"
            });
            $("#system_data_main_contents").show();
        }
        $("#system_data_mode").attr('mode', 'show');
    });
});


$(function(){
    $("#edit_current_system_data_entry").live('click', function(){
        $(".container_selected").removeClass("container_selected");
        $(this).closest('.toggle_options').addClass("container_selected");
        $("#edit_system_data_entry").html("");
        $("#system_data_add_entry_form").hide();
        $.ajax({
            type: "GET",
            url: "/amazon_settings/system_data_entry_finder.js",
            data: 'id=' + $(this).attr('system_data_id'),
            dataType: "script"
        });

    });
});

$(function(){
    $("#delete_system_data_entry").live('click', function(){
        $(".container_selected").removeClass("container_selected");
        $("#edit_system_data_entry").hide();
        $("#system_data_add_entry_form").hide();
        $.ajax({
            type: "GET",
            url: "/amazon_settings/delete_system_data_entry.js",
            data: 'id=' + $(this).attr('system_data_id'),
            dataType: "script"
        });

    });
}); 

$(function(){
    $("#system_data_add_entry").live('click', function(){
        $("#system_data_add_entry_form").show();
        $("#edit_system_data_entry").html("");
        $(".system_data_entry_selected").removeClass("system_data_entry_selected");
    });
});


$(function(){
    $("#close_edit_system_data_entry").live('click', function(){
        $("#edit_system_data_entry").hide();
    });
});


// Tag hover system

$(function(){
    $(".multilevel_new_option").live('click', function(){
        $("#multilevel_mode_1").attr("mode", "inactive");
        $("#multilevel_mode_2").attr("mode", "inactive");
        $("#multilevel_mode_3").attr("mode", "inactive");
        $("#multilevel_mode_" + $(this).attr('level')).attr("mode", "new");
        $(this).css("display", "none");
        $(".multilevel_close_option[level="+ $(this).attr("level") +"]").css("display","");
        $(".open_tag_toggle[level="+ (( $(this).attr("level") * 1) +1 +"") + "]").css("display","none");
    });

    $(".multilevel_edit_option").live('click', function() {
       // This function is an AJAX call for a form, meaning none of this code
       // is going to be executed. However, you will need to place the following
       // code in the return.js file for that AJAX method in your controller.
        $("#multilevel_mode_1").attr("mode", "inactive");
        $("#multilevel_mode_2").attr("mode", "inactive");
        $("#multilevel_mode_3").attr("mode", "inactive");
        $("#multilevel_mode_" + $(this).attr('level')).attr("mode", "edit");
        $(".multilevel_new_option[level="+ $(this).attr('level')+"]").css("display","none");
    });

    $(".multilevel_close_option").live('click', function() {
        $("#multilevel_mode_1").attr("mode", "show");
        $("#multilevel_mode_2").attr("mode", "show");
        $("#multilevel_mode_3").attr("mode", "show");
        $(this).css("display", "none");
        $(".multilevel_new_option[level="+ $(this).attr("level") +"]").css("display","");
        $(".open_tag_toggle[level="+ (( $(this).attr("level") * 1) +1 +"") +"]").css("display","");
    });

    $(".multilevel_delete_option").live('click', function() {
       // This function is an AJAX call for a form, meaning none of this code
       // is going to be executed. However, you will need to place the following
       // code in the return.js file for that AJAX method in your controller.
        $("#multilevel_mode_1").attr("mode", "show");
        $("#multilevel_mode_2").attr("mode", "show");
        $("#multilevel_mode_3").attr("mode", "show");
    });

    $(".toggle_multilevel_options").live("mouseover", function(){
        if ( $("#multilevel_mode_" + $(this).attr('level')).attr("mode") == 'show' ) {
            $(this).find(".options").css("display", "");
        }
    });

    $(".toggle_multilevel_options").live("mouseout", function(){
        if ( $("#multilevel_mode_" + $(this).attr('level')).attr("mode") == 'show' ) {
            $(this).find(".options").css("display", "none");
        }
    });
});


// Tag toggle system

$(function (){
    $(".open_tag_toggle").live('click', function() {
        $(this).hide();
        $('#'+$(this).attr('toggle_id_name')).show();
        $(this).parent().find(".close_tag_toggle").show();

        $("#multilevel_mode_1").attr("mode", "inactive");
        $("#multilevel_mode_2").attr("mode", "inactive");
        $("#multilevel_mode_3").attr("mode", "inactive");
        $("#multilevel_mode_" + $(this).attr('level')).attr("mode", "show");
        $(".open_tag_toggle").hide();

        $(".multilevel_new_option").hide();
        $(".multilevel_close_option").hide();

    });
});


$(function (){
    $(".close_tag_toggle").live('click', function() {
        $(this).hide();
        $('#'+$(this).attr('toggle_id_name')).hide();
        $(this).parent().find(".open_tag_toggle").show();
        $(".open_tag_toggle").show();

        $(".multilevel_new_option").show();
    });
});

$(function (){
    $(".tag_add_entry_form").live('click', function() {
        $(this).hide();
        $('#'+$(this).attr('form_id')).show();
        $(this).parent().find(".tag_close_entry_form").show();

        $(".close_tag_toggle").hide();

        $("#multilevel_mode_1").attr("mode", "inactive");
        $("#multilevel_mode_2").attr("mode", "inactive");

    });
});

$(function (){
    $(".tag_close_entry_form").live('click', function() {
        $(this).hide();
        $('#'+$(this).attr('form_id')).hide();
        $(this).parent().find(".tag_add_entry_form").show();

        if($(this).attr('level')> 1) {
            $(this).parent().parent().parent().parent().find('.close_tag_toggle').show();
        }
        
    });
});















$(function(){
    $("#find_data_list_field").live('change', function(){
        $.ajax({
            type: "GET",
            url: "/amazon_settings/data_list_finder.js",
            data: 'type=' + $(this).val() + '&id=' + $("#hiden_id").val(),
            dataType: "script"
        });
    });
});

$(function(){
    $("#data_list_field").live('change', function(){
        if($(this).val()==0){
            $.ajax({
                type: "GET",
                url:
                "/amazon_settings/new.js",
                data:
                'type=' + $("#find_data_list_field").val(),
                dataType: "script"
            });
        }else{
            $.ajax({
                type: "GET",
                url:
                "/amazon_settings/" + $(this).val() + "/edit.js",
                data:
                'id=' + $(this).val(),
                dataType: "script"
            });
        }
    });
});



$(function(){
    $(".delete_system_data").live('click', function(){
        $.ajax({
            type: "DELETE",
            url: "/amazon_settings/" + $(this).attr("data_id"),
            data:'&id=' + $(this).attr("data_id"),
            dataType: "script"
        });
    });
});


/* Drop down box hack*/
$(function(){
    $(".clear_select").find('option:first').attr('selected', 'selected');
});

/* Admin  -  Role_Condition Tab*/


$(function(){
    $(".show_role").live('change', function(){
        if($(this).val() != ""){
            $.ajax({
                type: "GET",
                url: "/roles/show_roles.js",
                data: 'role_type_id='+$(this).val(),
                dataType: "script"

            });

            $('#role_main_contents').show();
        }else{

            $("#downside").html("");
            $("#role_type_description_label").html('');
             $('#role_main_contents').hide();
        }
    });
});


$(function(){
    $(".choose_role").live('change', function(){
        if($(this).val()=="0"){
            $.ajax({
                type: "GET",
                url: "/roles/new.js",
                data: 'id='+$(this).val()+'&role_type_id='+$('#role_role_type_id').val(),
                dataType: "script"
            });
        }else{
            $.ajax({
                type: "GET",
                url: "/roles/"+$(this).val()+"/edit.js",
                data: 'id='+$(this).val()+'&role_type_id='+$('#role_role_type_id').val(),
                dataType: "script"
            });           
        }
    });
});


$(function(){
    $(".find_master_doc_meta_type_field_for_role_condition").live('change', function(){
        $.ajax({
            type: "GET",
            url: "/roles/master_doc_meta_type_finder1.js",
            data: 'master_doc_meta_meta_type_id='+$(this).val()+'&id='+$(this).val(),
            dataType: "script"
        });

    });
});


$(function(){
    $(".find_master_doc_meta_type_field_for_role_condition").live('change', function(){
        $.ajax({
            type: "GET",
            url:
            "/roles/meta_name_finder.js",
            data:
            'id='+$(this).val(),
            dataType: "script"
        });
    });
});

$(function(){
    $("#master_doc_meta_type_id_for_role_condition").live('change', function(){
        $.ajax({
            type: "GET",
            url: "/roles/meta_type_name_finder.js",
            data:'id='+$(this).val(),
            dataType: "script"
        });
    });
});

$(function(){

    $("#master_doc_meta_type_id_for_role_condition").live('change', function(){
        $.ajax({
            type: "GET",
            url:
            "/roles/doc_type_finder.js",
            data:
            'master_doc_meta_type_id='+$(this).val(),
            dataType: "script"
        });
    });
});

$(function(){
    $("#cheatbutton").live('click', function(){
        $("#edit_role").doAjaxSubmit();
    })
});




$(function(){
    $("#rm").live('mousedown', function(){
        $.ajax({
            type: "GET",
            url:"/roles/role_type_finder.js",
            dataType: "script"
        });
    });
});

/*for rule use*/

$(function(){
    $(".show_role_table").live('change',function(){
        
        $.ajax({
            type: "GET",
            url: "/people/"+$(this).attr('person_id')+"/roles/person_role_des.js",
            data: 'id='+$(this).val()+'&person_id='+$(this).attr('person_id')+'&person_role_id='+$(this).attr('person_role_id'),
            dataType: "script"
        });
    });
});

$('.beforestartdatepick').live("mouseover", function(){
    $("#"+$(this).attr("end_date")).datepicker('enable');
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true
    });
});

$('.role_enddatepick').live("mouseover", function(){
    var arr_dateText = $("#"+$(this).attr("start_date")).val().split("-");
    day = arr_dateText[0];
    month = arr_dateText[1];
    year = arr_dateText[2];
    //init
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true,
        minDate: new Date(year, month-1, day)
    });

    //reset
    if(year!=undefined){
        $(this).datepicker('option', 'minDate', new Date(year, month-1, day));
    }
});

$('.role_startdatepick').live("mouseover", function(){
    $("#"+$(this).attr("end_date")).datepicker('enable');
    var arr_dateText = $("#"+$(this).attr("start_date")).val().split("-");
    day = arr_dateText[0];
    month = arr_dateText[1];
    year = arr_dateText[2];
    //init
    $(this).datepicker({
        dateFormat: 'dd-mm-yy',
        altFormat: 'mm-dd-yy',
        changeMonth: true,
        changeYear: true,
        minDate: new Date(year, month-1, day)
    });

    //reset
    if(year!=undefined){
        $(this).datepicker('option', 'minDate', new Date(year, month-1, day));
    }
});


/*Admin Tag Setting*/

$(function(){
    $("#tag_selection").live('change', function(){
        if($(this).val() != ""){
            $.ajax({
                type: "GET",
                url: "/tag_settings/show_all_for_selected_classifier.js",
                data: 'tag='+$(this).val(),
                dataType: "script"
            });
            if($(this).val() != "5"){
                $("#add_tag_meta_type").css("display", "");
            }else{
                $("#add_tag_meta_type").css("display", "none");
            }
        }else{
            $("#add_tag_meta_type").css("display", "none");
            $("#show_tag").html("");
        }

    });
});


$(function(){
    $(".show_tag_types").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tag_types/show_tag_types.js",
            data:'tag='+$('#tag_selection').val() + '&id='+$(this).attr('tag_meta_types_id'),
            dataType: "script"
        });
    });
});

$(function(){
    $(".show_tags").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tags/show_tags.js",
            data:'tag='+$('#tag_selection').val() + '&id='+$(this).attr('tag_types_id'),
            dataType: "script"
        });
    });
});

$(function(){
    $("#add_tag_meta_type").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tag_meta_types/new.js",
            data:'tag='+$('#tag_selection').val(),
            dataType: "script"
        });
    });
});

$(function(){
    $(".edit_tag_meta_type").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tag_meta_types/" + $(this).attr("tag_meta_type_id") + "/edit.js",
            data:'tag='+$('#tag_selection').val()+'&id=' + $(this).attr("tag_meta_type_id"),
            dataType: "script"
        });
    });
});

$(function(){
    $(".delete_tag_meta_type").live('click', function(){
        $.ajax({
            type: "DELETE",
            url: "/tag_meta_types/" + $(this).attr("tag_meta_type_id"),
            data:'tag='+$('#tag_selection').val()+'&id=' + $(this).attr("tag_meta_type_id"),
            dataType: "script"
        });
    });
});



$(function(){
    $(".add_tag_type").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tag_types/new.js",
            data:'tag='+$('#tag_selection').val()+'&tag_meta_type_id=' + $(this).attr("tag_meta_type_id"),
            dataType: "script"
        });
    });
});

$(function(){
    $(".edit_tag_type").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tag_types/" + $(this).attr("tag_type_id") + "/edit.js",
            data:'tag='+$('#tag_selection').val()+'&id=' + $(this).attr("tag_type_id"),
            dataType: "script"
        });
    });
});

$(function(){
    $(".delete_tag_type").live('click', function(){
        $.ajax({
            type: "DELETE",
            url: "/tag_types/" + $(this).attr("tag_type_id"),
            data:'tag='+$('#tag_selection').val()+'&id=' + $(this).attr("tag_type_id"),
            dataType: "script"
            
        });
    });
});


$(function(){
    $(".add_tag").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tags/new.js",
            data:'tag='+$('#tag_selection').val()+'&tag_type_id=' + $(this).attr("tag_type_id"),
            dataType: "script"
        });
    });
});

$(function(){
    $(".edit_tag").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/tags/" + $(this).attr("tag_id") + "/edit.js",
            data:'tag='+$('#tag_selection').val()+'&id=' + $(this).attr("tag_id"),
            dataType: "script"
        });
    });
});

$(function(){
    $(".delete_tag").live('click', function(){
        $.ajax({
            type: "DELETE",
            url: "/tags/" + $(this).attr("tag_id"),
            data:'tag='+$('#tag_selection').val()+'&id=' + $(this).attr("tag_id"),
            dataType: "script"
        });
    });
});

$(function(){
    $(".show_tag_types").live('mouseover', function(){
        $(this).animate({
            color: "#FFFF00"
        }, 300)
    });
});

$(function(){
    $(".show_tag_types").live('mouseout', function(){
        $(this).animate({
            color: "#F7F8E0"
        }, 300)
    });
});

/*Admin User management*/
$(function(){
    $("#add_user").live('click', function(){
        $(this).hide();
        $(".user_clear_form").click();
        //$(".show_user_container").hide();
        $("#close_new_account").show();
    });
});

$(function(){
    $(".check_login_id").live('change', function(){
        if($(this).val()!= ""){
            $.ajax({
                type: "GET",
                url: "/people/login_id_finder.js",
                data: 'person_id='+$(this).val()+'&login_account_id='+$(this).attr('login_account_id'),
                dataType:"script"
            });
        }else{
            $("#login_name_container_"+$(this).attr('login_account_id')).html("");
        }
    });
});

$(function(){
    $(".check_username_unique").live('change', function(){
        if($(this).val()!= ""){
            $.ajax({
                type: "GET",
                url: "/login_accounts/user_name_unique.js",
                data: 'user_name='+$(this).val()+'&login_account_id='+$(this).attr('login_account_id')+'&length='+$(this).val().length,
                dataType:"script"
            });
        }else{
            $("#login_name_container_"+$(this).attr('login_account_id')).html("");
        }
    });
});



$(function(){
    $('#login_account_user_name').live("focus", function(){
        $(this).qtip(
        {
            content: 'username must between 6~20<br>username can\'t the same as password',
            style: 'dark'
        }
        );
    });
});

$(function(){
    $('#login_account_user_name').live("mouseover", function(){
        $(this).qtip(
        {
            content: 'username must between 6~20<br>username can\'t the same as password',
            style: 'dark'
        }
        );
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
    $("#login_account_password_confirmation").live('change', function(){
        if ($(this).val()!= $('#login_account_password').val()){
            $('#password_confirm').dialog( {
                modal: true,
                resizable: true,
                draggable: true
            });
            $('#password_confirm').dialog('open');
        }
    });
});

//$(function(){
//    $("#login_account_user_name").live('change', function(){
//
//        if ($(this).val().length < 6 ||$(this).val().length > 30 ){
//            $('#user_length').dialog( {
//                modal: true,
//                resizable: true,
//                draggable: true
//            });
//            $('#user_length').dialog('open');
//        }
//    });
//});


//$(function(){
//    $("#login_account_password").live('change', function(){
//
//        if ($(this).val().length < 6 ||$(this).val().length > 30 ){
//
//            $('#password_length').dialog( {
//                modal: true,
//                resizable: true,
//                draggable: true
//            });
//            $('#password_length').dialog('open');
//        }
//
//    });
//});


$(function(){
    $("#login_account_password").live('change', function(){

        if ($(this).val().length < 6 ||$(this).val().length > 30 ){
            $('#no_password').show();
            $('#yes_password').hide();

        }else{
            $('#no_password').hide();
            $('#yes_password').show();

        }

    });
});






//$(function(){
//    $(".edit_login_account").live('click', function(){
//
//
//
//        $.ajax({
//            type: "GET",
//            url: "/login_accounts/" + $(this).attr('login_account_id') + "/edit.js",
//            data:'id='+$(this).attr('login_account_id'),
//            dataType: "script"
//        });
//    });
//});



$(function(){
    $(".user_clear_edit_form").live('click', function(){
        $('#'+($(this).closest('form').get(0).id))[0].reset();
      
        $('#user_name_container_' + $(this).attr('login_account_id')).html('');     
    })
});


$(function(){
    $("#group_secu_submit").live('click', function(){
        $(".edit_login").doAjaxSubmit();
    })
});



$(function(){
    $(".delete_login_account").live('click', function(){
        $.ajax({
            type: "DELETE",
            url: "/login_accounts/" + $(this).attr("data_id"),
            data:'&id=' + $(this).attr("data_id"),
            dataType: "script"
        });
    });
});


$(function(){
    $("#close_new_account").live('click', function(){
       
        $(".user_clear_form").click();
        $("#new_user").toggle('blind');
        $(".show_user_container").show();
        $("#close_new_account").hide();
        $("#add_user").show();
        $('#no_password').hide();
        $('#yes_password').hide();
        $('#no_username').hide();
        $('#yes_username').hide();
    });
});

$(function(){
    $("#close_edit_account").live('click', function(){

        $(".add_user").show();
        $(".container_selected").removeClass("container_selected");
        $("#edit_user").html('');
      
    });
});



$(document).ready(function() {
    $(".inputWithImge").each(function(){
        $(this).add($(this).next()).wrapAll('<div class="imageInputWrapper"></div>');
    });
});


/* Admin List Management - Query*/

$(function(){
    $(".show_fields").live('change', function(){
        if($(this).val()){
            $.ajax({
                type: "GET",
                url: "/tag_types/show_fields.js",
                data:'table_name=' + $(this).val() + '&update_field=' + $(this).attr("update_field") + '&update_value=' + $(this).attr("update_value"),
                dataType: "script"
            });
        }else{
            $("#fields_"+$(this).attr("update_field")).html("");
            $("#attribute_description_"+$(this).attr("update_field")).html("<label class='descriptions'>&nbsp;</label>")
        }
    });
});

$(function(){
    $("#fields_criteria").live('change', function(){
        $(".descriptions_criteria").css("display", "none");
        $("#description_criteria_"+$(this).val()).css("display", "");
    });
});

$(function(){
    $("#fields_selection").live('change', function(){
        $(".descriptions_selection").css("display", "none");
        $("#description_selection_"+$(this).val()).css("display", "");
    });
});

$(function(){
    $("#fields_sorter").live('change', function(){
        $(".descriptions_sorter").css("display", "none");
        $("#description_sorter_"+$(this).val()).css("display", "");
    });
});

$(function(){
    $("#show_new_query").live('click', function(){
        $(this).css("display", "none");
        $.ajax({
            type: "GET",
            url: "/query_headers/new.js",
            dataType: "script"
        });
    });
});

$(function(){
    $("#close_new_query").live('click', function(){
        $(this).css("display", "none");
        $("#current_action").val("");
        $('#new_query_form').html('');
        $('#new_query_list').html('');
        $('#new_selection_form').html('');
        $('#new_selection_list').html('');
        $('#new_sorter_form').html('');
        $('#new_sorter_list').html('');
        $('#save_form').html('');
        $('#new_form').css("display", "none");
        $("#show_new_query").css("display", "");
        $("#existing_query").css("display", "");
    });
});

$(function(){
    $("#save_button").live('click', function(){
        if($(this).attr("action")=="new"){
            $('#save_form').toggle('blind');
            $('#save_form').dialog( {
                modal: true,
                resizable: true,
                draggable: true
            });
            $('#save_form').dialog('open');
        }else{
            $('#edit_query_header').doAjaxSubmit();
        }
    });
});


$(function(){
    $("#run_button").live('click', function(){
        var temp = "";
        temp += 'id=' + $("#query_header_id").val();
        if($("#query_top_number").attr("checked")==true){
            temp += "&top=number&top_number=" + $("#query_top_number_value").val();
        }else{
            temp += "&top=percent&top_percent=" + $("#query_top_percent_value").val();
        }
        $.ajax({
            type: "GET",
            url: "/query_headers/run.js",
            data: temp,
            dataType: "script"
        });
    });
});

$(function(){
    $("#run_button_edit").live('click', function(){
        var temp = "";
        temp += 'id=' + $("#query_header_id").val();
        if($("#query_edit_top_number").attr("checked")==true){
            temp += "&top=number&top_number=" + $("#query_edit_top_number_value").val();
        }else{
            temp += "&top=percent&top_percent=" + $("#query_edit_top_percent_value").val();
        }
        $.ajax({
            type: "GET",
            url: "/query_headers/run.js",
            data: temp,
            dataType: "script"
        });
    });
});

$(function(){
    $("#clear_button").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/query_headers/clear.js",
            data:'id=' + $("#query_header_id").val(),
            dataType: "script"
        });
    });
});

$(function(){
    $("#new_runtime").live('click', function(){
        if ($("#query_criteria_value").attr("readonly")==false){
            $("#query_criteria_value").val("?");
            $("#query_criteria_value").attr("readonly", true);
        }else{
            $("#query_criteria_value").val("");
            $("#query_criteria_value").attr("readonly", false);
        }
    });
});

$(function(){
    $("#show_sql_statements").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/query_headers/show_sql_statement.js",
            data:'id=' + $("#query_header_id").val(),
            dataType: "script"
        });
    });
});

$(function(){
    $('a.get_query').live('click', function() {
        container = $(this).parent().parent().parent();
        $("#current_action").val("edit");
        $(".highlight").removeClass("highlight");
        
        container.addClass("highlight");
        var link = $(this);
        $.get(link.attr('href'), null ,null, 'script');
        return false;
    }).attr("rel", "nofollow");

    jQuery('a.get_query').removeAttr('onclick');
});

$(function(){
    $("#close_edit_query").live('click', function(){
        $("#new_query").css('display','');
        $(".highlight").removeClass("highlight");
        $(this).css("display", "none");
        $("#edit_query").css("display", "none");
        $('#edit_query_form').html('');
        $('#edit_query_list').html('');
        $('#edit_selection_form').html('');
        $('#edit_selection_list').html('');
        $('#edit_sorter_form').html('');
        $('#edit_sorter_list').html('');
    });
});

$(function(){
    $(".select_all").live('click', function(){
        if($(this).attr("checked") == true){
            $(".checkboxes").attr("checked", true);
        }else{
            $(".checkboxes").attr("checked", false);
        }
    });
});

$(function(){
    $("#query_top_number").click(function(){
        $("#query_top_percent_value").val('');
        $("#query_top_percent_value").attr("disabled",true);
        $("#query_top_number_value").attr("disabled",false);
    });
    $("#query_top_percent").click(function(){
        $("#query_top_number_value").val('');
        $("#query_top_number_value").attr("disabled",true);
        $("#query_top_percent_value").attr("disabled",false);
    });
});

$(function(){
    $("#query_edit_top_number").click(function(){
        $("#query_edit_top_percent_value").val('');
        $("#query_edit_top_percent_value").attr("disabled",true);
        $("#query_edit_top_number_value").attr("disabled",false);
    });
    $("#query_edit_top_percent").click(function(){
        $("#query_edit_top_number_value").val('');
        $("#query_edit_top_number_value").attr("disabled",true);
        $("#query_edit_top_percent_value").attr("disabled",false);
    });
});


/*List Header of Person*/

$(function(){
    $("#list_header_name").change(function(){
        $("#person_list").submit();
    });
});

$(function(){
    $("#list_header_name2").change(function(){
        $("#person_list_edit").submit();
    });
});


/*Admin List Management - List Manager*/
$(function(){
    $('a.get_list').live('click', function() {
        container = $(this).parent().parent().parent();
        $(".highlight").removeClass("highlight");
        container.addClass("highlight");
        var link = $(this);
        $.get(link.attr('href'), null ,null, 'script');
        return false;
    }).attr("rel", "nofollow");
    jQuery('a.get_list').removeAttr('onclick');
});


$(function(){
    $('#show_list_compiler').live('click', function(){
        $(this).css("display","none");
        $("#close_list_compiler").css("display", "");
        $("#list_compiler_form").css("display","");
        $("#existing_list").css("display","none");
        $("#clear_compile_list").click();
        $.ajax({
            type: "GET",
            url: "/list_headers",
            dataType: "script"
        });
    });
});

$(function(){
    $('#close_list_compiler').live('click', function(){
        $(this).css("display","none");
        $("#show_list_compiler").css("display", "");
        $("#existing_list").css("display","");
        $("#list_compiler_form").css("display","none");
        $("#clear_compile_list").click();
    });
});

$(function(){
    $("#add_to_include").live('click', function(){
        if($("#compiler_options").val() != null){
            $.ajax({
                type: "POST",
                url: "/include_lists",
                data:'list_header_id=' + $("#compiler_options").val() + '&login_account_id=' + $("#login_account_id").val(),
                dataType: "script"
            });

        }
    });
});



$(function(){
    $("#add_to_exclude").live('click', function(){
        if($("#compiler_options").val() != null){
            $.ajax({
                type: "POST",
                url: "/exclude_lists",
                data:'list_header_id=' + $("#compiler_options").val() + '&login_account_id=' + $("#login_account_id").val(),
                dataType: "script"
            });
        }
    });
});


$(function(){
    $("#clear_compile_list").live('click', function(){
        $.ajax({
            type: "POST",
            url: "/compile_lists/clear.js",
            data: "login_account_id=" + $("#login_account_id").val(),
            dataType: "script"
        });
    });
});

$(function(){
    $("#compile_button").live('click', function(){
        var temp = "";
        temp += "login_account_id=" + $("#login_account_id").val();
        temp += "&allow_duplication=" + $("#allow_duplication").attr("checked");
        if($("#top_number").attr("checked")==true){
            temp += "&top=number&top_number=" + $("#top_number_value").val();
        }else{
            temp += "&top=percent&top_percent=" + $("#top_percent_value").val();
        }

        $.ajax({
            type: "POST",
            url: "/compile_lists/compile.js",
            data: temp,
            dataType: "script"
        });
    });
});


$(function(){
    $("#top_number").click(function(){
        $("#top_percent_value").val('');
        $("#top_percent_value").attr("disabled",true);
        $("#top_number_value").attr("disabled",false);
    });
    $("#top_percent").click(function(){
        $("#top_number_value").val('');
        $("#top_number_value").attr("disabled",true);
        $("#top_percent_value").attr("disabled",false);
    });
});

$(function(){
    $(".integer_field").live('keyup', function(){
        _valid = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test($(this).val());
        if($(this).val()!=""){
            if((!_valid) || $(this).val()<=0){
                alert("This field has be an integer and great than zero!");
                $(this).focus();
                $(this).val('');
            }
        }
    });
});



/*Group ---List*/
$(function(){
    $(".show_list").live('change',function(){
        if ($(this).val()!= ""){

            $.ajax({
                type: "GET",
                url: "/group_lists/show_lists.js",
                data: 'group_id='+$(this).val(),
                dataType: "script"
            });
            $(".show_list_container").css("display", "");
            $("#new_group_list_container").css("display", "");
        } else{
            $(".show_list_container").css("display", "none");
            $("#new_group_list_container").css("display", "none")
           
        }
    });
});

$(function(){
    $("#add_new_list").live('click', function(){
        $(this).css("display", "none");
        $(".group_list_delete").css("display", "none");
        $("#close_new_group_list").css("display", "");
    });
});


$(function(){
    $("#close_new_group_list").live('click', function(){
        $(this).css("display", "none");

        $('#new_group_list').toggle('blind');
        $('#add_new_list').css("display", "");
        $(".group_list_delete").css("display", "");

    });
});


/* Admin - Duplication Formular */
$(function(){
    $("#fields_personal_duplication").live('change', function(){
        $(".descriptions_personal_duplication").css("display", "none");
        $("#description_personal_duplication_"+$(this).val()).css("display", "");
        if($("#description_personal_duplication_"+$(this).val()).html().match("(Integer FK)")){
            $("#is_foreign_key").val(true);
        }else{
            $("#is_foreign_key").val(false);
        }
    });
});

$(function(){
    $('#apply_personal_duplication').live('click', function(){
        $("#personal_duplication_form").doAjaxSubmit();
    });
});

$(function(){
    $("#fields_organisational_duplication").live('change', function(){
        $(".descriptions_organisational_duplication").css("display", "none");
        $("#description_organisational_duplication_"+$(this).val()).css("display", "");
        if($("#description_organisational_duplication_"+$(this).val()).html().match("(Integer FK)")){
            $("#is_foreign_key_organisational").val(true);
        }else{
            $("#is_foreign_key_organisational").val(false);
        }
    });
});

$(function(){
    $('#apply_organisational_duplication').live('click', function(){
        $("#organisational_duplication_form").doAjaxSubmit();
    });
});

$(function(){
    $("#generate_personal_duplication").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/personal_duplication_formulas/generate.js",
            dataType: "script"
        });
    });
});

$(function(){
    $("#generate_organisational_duplication").live('click', function(){
        $.ajax({
            type: "GET",
            url: "/organisational_duplication_formulas/generate.js",
            dataType: "script"
        });
    });
});

$(function(){
    $('#load_personal_duplication').live('mouseover', function(){
        $('#load_personal_default').dialog( {
            modal: true,
            resizable: true,
            draggable :true,
            height: 250,
            width: 700,
            buttons: {
                NO: function() {
                    $(this).dialog('close');
                },
                YES: function() {
                    window.open("/personal_duplication_formulas/set_default.html", "_self");
                    return false;
                }
            }
        });
        $('#load_personal_default').dialog('open');
    });
});

$(function(){
    $('#load_organisational_duplication').live('mouseover', function(){
        $('#load_organisational_default').dialog( {
            modal: true,
            resizable: true,
            draggable :true,
            height: 250,
            width: 700,
            buttons: {
                NO: function() {
                    $(this).dialog('close');
                },
                YES: function() {
                    window.open("/organisational_duplication_formulas/set_default.html", "_self");
                    return false;
                }
            }
        });
        $('#load_organisational_default').dialog('open');
    });
});


/*Group---Permission*/

$(function(){
    $(".show_permission_container").live('change',function(){
        if ($(this).val()!= ""){

            $.ajax({
                type:"GET",
                url: "/group_permissions/show_add_container.js",
                data: "group_id="+$(this).val(),
                dataType: "script"
            });
            $(".permission_container").css("display", "");
            $("#old_permissions").show();
        }
        else{

            $(".permission_container").css("display", "none");
            $("#old_permissions").hide();

        }
    });
});


$(function(){

    $("#system_permission_meta_meta_type_id").live('change',function(){

        if ($(this).val()!= ""){
            $.ajax({
                type:"GET",
                url: "/group_permissions/show_module.js",
                data:"system_permission_module_id="+$(this).val() + '&group_id=' + $("#group_permission_user_group_id").val(),
                dataType:"script"

            });
            $('#permission_form').show();
        }else{

            $('#permission_form').hide();
        }

    });
});


$(function(){
    $(".group_permission_color").live('mouseover', function(){
        $(this).animate({
            color: "#FFFF00"
        }, 300)
    });
});

$(function(){
    $(".group_permission_color").live('mouseout', function(){
        $(this).animate({
            color: "#F7F8E0"
        }, 300)
    });
});

/*use for click the module show the whole thing*/
$(function(){
    $("#show_controllers").live('click', function(){
        $.ajax({
            type:"GET",
            url:"/group_permissions/show_controllers.js",
            data:"main_module_id="+$(this).attr('main_module_id'),
            dataType:"script"

        });

    });

});

$(function(){
    $(".module_select_all").live('click', function(){
        if ($(this).attr("checked") == true){
            $('.controller_select_all').attr("checked", true);
            $('.method_select_all').attr("checked", true);
        }else{
            $('.controller_select_all').attr("checked", false);
            $('.method_select_all').attr("checked", false);
        }

    });
});

$(function(){
    $("#new_group_permission").live('click', function(){
        $(this).css("display", "none");
        $(".group_permission_delete").css("display", "none");

        $.ajax({
            type: "GET",
            url: "/group_permissions/new.js",
            data:"group_id="+$(this).attr('group_id'),
            dataType: "script"
        });
        $("#close_new_module").css("display", "");
    });
});


/*when you slecet the controller , all the method will be on*/
$(function(){
    $('.controller_select_all').live('click', function(){
        if ($(this).attr('checked') == true){


            $('.method_select_all[controller_id = ' + $(this).val() +']').attr("checked", true);


        }else{


            $('.method_select_all[controller_id='+ $(this).val()+']').attr("checked", false);
            $('.module_select_all').attr("checked", false);

        }
    });
});



$(function(){
    $('.method_select_all').live('click', function(){
        if ($(this).attr('checked') == false){
            $('.module_select_all').attr("checked", false);
            $('.controller_select_all[controller_id='+ $(this).attr("controller_id")+ ']').attr("checked", false);
        }

    });
});

$(function(){
    $("#close_new_module").live('click', function(){
        $(this).css("display", "none");
     
        $('#hide_module').html('');
        $('#new_group_permission').css("display", "");
        $(".group_permission_delete").css("display", "");
      
    });
});



/*Organisation-part*/


$(function(){

    $("#organisation_industry_sector_id").live('change', function(){

        if ($(this).val()!= ""){
            $.ajax({
                type:"GET",
                url: "/organisations/show_industrial_code.js",
                data:"industrial_id="+$(this).val(),
                dataType:"script"

            });
      
        }else{

            $('#organisation_industrial_code').val('');
        }

    });
});

$(function(){

    $("#organisation_business_category_id").live('change', function(){

        if ($(this).val()!= ""){
            $.ajax({
                type:"GET",
                url: "/organisations/show_sub_category.js",
                data:"sub_category_id="+$(this).val(),
                dataType:"script"

            });

        }else{

            $('#organisation_business_sub_category').val('');
        }
    });
});


/* Show list*/
$(function(){
    $("#show_all_list_member").live('click',function(){
        $.ajax({
            type: "GET",
            url: "/people/show_list.js",
            data: 'person_id='+$(this).attr('person_id')+'&current_operation='+$(this).attr('current_operation'),
            dataType: "script"

        });
    });
});


//$(function(){
//    $("#edit_all_list_member").live('click',function(){
//        $.ajax({
//            type: "GET",
//            url: "/people/edit_show_list.js",
//            data: 'person_id='+$(this).attr('person_id'),
//            dataType: "script"
//
//        });
//    });
//});



$(function(){
    $("#show_list_select").live('click',function(){
        window.open("/people/"+ $('#system_id_tag').val(), "_self");
    });
});


$(function(){
    $("#edit_list_select").live('click',function(){
        window.open("/people/"+ $('#system_id_tag').val()+"/edit", "_self");
    });
});

$(function(){
    $("#show_all_organisations").live('click',function(){
        $.ajax({
            type: "GET",
            url: "/organisations/show_list.js",
            data: 'organisation_id='+$(this).attr('organisation_id')+'&current_operation='+$(this).attr('current_operation'),
            dataType: "script"
        });
    });
});

//$(function(){
//   
//      $('.text').wysiwyg();
//
//});


$(function(){
    $('.header_container').live('mouseover',function(){
        if ($("#" + $(this).attr('field')+'_hidden_tab').attr('mode') == "show"){
     
            $(this).find('.person_tag').css("display","");
        }
    });
});

$(function(){
    $('.header_container').live('mouseout',function(){
        if ($("#" + $(this).attr('field')+'_hidden_tab').attr('mode') == "show"){
            $(this).find('.person_tag').css("display","none");
        }
    });
});


/*Grid*/
$(function(){
    $("#people_search_grid").flexigrid({
        url: '/grids/people_search_grid',
        dataType: 'json',
        colModel : [
        {
            display: 'ID',
            name : 'grid_object_id',
            width : 40,
            sortable : true,
            align: 'left'
        },

        {
            display: 'First Name',
            name : 'field_1',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Family Name',
            name : 'field_2',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Address',
            name : 'field_3',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Phone',
            name : 'field_4',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Email',
            name : 'field_5',
            width : 180,
            sortable : true,
            align: 'left'
        }
        ],
        searchitems : [
        {
            display: 'First Name',
            name : 'field_1'
        },

        {
            display: 'Family Name',
            name : 'field_2'
        },

        {
            display: 'Address',
            name : 'field_3'
        },

        {
            display: 'Phone',
            name : 'field_4'
        },

        {
            display: 'Email',
            name : 'field_5'
        }
        ],
        sortname: "grid_object_id",
        sortorder: "asc",
        usepager: true,
        title: 'People Search Result',
        useRp: true,
        rp: 20,
        showTableToggleBtn: false,
        width: 'auto',
        height: 'auto'
    });
});

$(function(){
    $('table#people_search_grid tbody tr').live('click',function(){
        $('table#people_search_grid tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass('trSelected');
        $.ajax({
            type: 'GET',
            url: "/people/"+$(this).attr('id').substring(3)+"/name_card.js",
            dataType: "script"
        });
    });
});

$(function(){
    $('table#query_result_grid tbody tr').live('click',function(){
        $('table#query_result_grid tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass('trSelected');
    });
});


/*option hover*/
$(function(){
    $('.toggle_options').live('mouseover',function(){
        if ($("#" + $(this).attr('field')+'_mode').attr('mode') == "show"){
            $(this).find('.options').css("display","");
        }
         
    });
});

$(function(){
    $('.toggle_options').live('mouseout',function(){
        if ($("#" + $(this).attr('field')+'_mode').attr('mode') == "show"){
            $(this).find('.options').css("display","none");
        }
    });
});

$(function(){
    $('.edit_option').live('click',function(){
        $("#" + $(this).attr('field')+'_mode').attr('mode','edit');
        $('.new_option[field='+ $(this).attr('field') +']').css("display","none");
    });
});

$(function(){
    $('.close_option').live('click',function(){
        $("#" + $(this).attr('field')+'_mode').attr('mode','show');
        $(this).css("display","none");
        $('.new_option[field='+ $(this).attr('field') +']').css("display","");
    });
});

$(function(){
    $('.new_option').live('click',function(){
        $("#" + $(this).attr('field')+'_mode').attr('mode','new');
        $(this).css("display","none");
        $('.close_option[field='+ $(this).attr('field') +']').css("display","");
    });
});

/*Organisation Grid*/
$(function(){
    $('table#search_organisations_list_results tbody tr').live('click',function(){



        $.ajax({
            type: 'GET',
            url: "/organisations/show_left.js",
            data: 'organisation_id='+$(this).attr('id').substring(3)+'&current_operation='+ $('#search_organisations_list_results').attr('current_operation'),
            dataType: "script"
        });
        $('table#search_organisations_list_results tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass("trSelected");
    });
});


$(function(){
    $("#show_organisation_list_select").live('click',function(){
        window.open("/organisations/"+ $('#system_id_tag').val(), "_self");
    });
});


$(function(){
    $("#edit_organisation_list_select").live('click',function(){
        window.open("/organisations/"+ $('#system_id_tag').val()+"/edit", "_self");
    });
});

$(function(){
    $("#organisation_search_grid").flexigrid({
        url: '/grids/organisation_search_grid',
        dataType: 'json',
        colModel : [
        {
            display: 'ID',
            name : 'grid_object_id',
            width : 40,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Trading As',
            name : 'field_1',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Registered Name',
            name : 'field_2',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Address',
            name : 'field_3',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Phone',
            name : 'field_4',
            width : 180,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Website',
            name : 'field_5',
            width : 180,
            sortable : true,
            align: 'left'
        }
        ],
        searchitems : [
        {
            display: 'Trading As',
            name : 'field_1'
        },

        {
            display: 'Registered Name',
            name : 'field_2'
        },

        {
            display: 'Address',
            name : 'field_3'
        },

        {
            display: 'Phone',
            name : 'field_4'
        },

        {
            display: 'Website',
            name : 'field_5'
        }
        ],
        sortname: "grid_object_id",
        sortorder: "asc",
        usepager: true,
        title: 'Organisation Search Result',
        useRp: true,
        rp: 20,
        showTableToggleBtn: false,
        width: 1010,
        height: 300
    });
});

$(function(){
    $('table#organisation_search_grid tbody tr').live('click',function(){
        $('table#organisation_search_grid tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass('trSelected');
        $.ajax({
            type: 'GET',
            url: "/organisations/"+$(this).attr('id').substring(3)+"/name_card.js",
            dataType: "script"
        });
    });
});


$(function(){   /*organisation employee list result*/
    $("#organisations_employees_grid").flexigrid({
        url: '/grids/organisation_employee_grid',
        dataType: 'json',
        colModel : [
        {
            display: 'ID',
            name : 'grid_object_id',
            width : 40,
            sortable : true,
            align: 'left'
        },

        {
            display: 'First Name',
            name : 'field_1',
            width : 50,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Family Name',
            name : 'field_2',
            width : 50,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Address',
            name : 'field_3',
            width : 120,
            sortable : true,
            align: 'left'
        },

        {
            display: 'Phone',
            name : 'field_4',
            width : 80,
            sortable : true,
            align: 'left'
        },

        {
            display: 'email',
            name : 'field_5',
            width : 40,
            sortable : true,
            align: 'left'
        }
        ],
        searchitems : [
        {
            display: 'First Name',
            name : 'field_1'
        },

        {
            display: 'Family Name',
            name : 'field_2'
        },

        {
            display: 'Address',
            name : 'field_3'
        },

        {
            display: 'Phone',
            name : 'field_4'
        },

        {
            display: 'Email',
            name : 'field_5'
        }
        ],
        sortname: "grid_object_id",
        sortorder: "asc",
        usepager: true,
        title: 'Organisation Employee Result',
        useRp: true,
        rp: 20,
        showTableToggleBtn: false,
        width: 'auto',
        height: 'auto'
    });
});


/* person check dup feild*/

$(function(){
    $('.personal_check_field').blur(function(){

        var personal_check_fields=[];
        var personal_data_string ="";

        for(var k=0; k < $('.personal_check_field').get().length;k++)
        {
            if($('.personal_check_field').eq(k).attr("id").indexOf("_id")>0)
            {
             
                personal_check_fields.push($('.personal_check_field').eq(k).attr("id").substring(7,$('.personal_check_field').eq(k).attr("id").indexOf("_id")));
                personal_check_fields.push($('.personal_check_field').eq(k).val());
            }
            else
            {
                personal_check_fields.push($('.personal_check_field').eq(k).attr("id").substring(7));
                personal_check_fields.push($('.personal_check_field').eq(k).val());
            }
        }

        for (var z=0; z< personal_check_fields.length;z++)
        {

            if(z > 0)
            {
                personal_data_string += "&"

            }
            personal_data_string += personal_check_fields[z++] + "=" + personal_check_fields[z];
        }
    
        $.ajax({
            type: 'GET',

            url: "/people/check_duplication.js",
            data: personal_data_string + "&id="+$("#person_id").val(),
            dataType: "script"

        });
    });
});

$(function(){
    $('table#person_check_field tbody tr').live('click',function(){
        $('table#person_check_field tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass('trSelected');
    });
});

/*Organisational Duplication Check*/
$(function(){
    $('.organisational_check_field').blur(function(){
        var check_fields = [];
        var data_string = "";
        for (var i = 0; i < $('.organisational_check_field').get().length; i++){
            if($('.organisational_check_field').eq(i).attr("id").indexOf("_id")>0){
                check_fields.push($('.organisational_check_field').eq(i).attr("id").substring(13, $('.organisational_check_field').eq(i).attr("id").indexOf("_id")));
                check_fields.push($('.organisational_check_field').eq(i).val());
            }else{
                check_fields.push($('.organisational_check_field').eq(i).attr("id").substring(13));
                check_fields.push($('.organisational_check_field').eq(i).val());
            }            
        }
        for (var j = 0; j < check_fields.length; j++){
            if (j >0){
                data_string += "&";
            }
            data_string += check_fields[j++] + "=" + check_fields[j];
        }
        $.ajax({
            type: 'GET',
            url: "/organisations/check_duplication.js",
            data: data_string + "&id=" + $("#organisation_id").val(),
            dataType: "script"
        });
    });
});

$(function(){
    $('table#duplication_organisations_grid tbody tr').live('click',function(){
        $('table#duplication_organisations_grid tbody tr.trSelected').removeClass('trSelected');
        $(this).addClass('trSelected');
    });
});


/*personal check field restart button*/
personal_check_duplication_restart_button = function(){

    window.open("/people/"+ $('#system_id_tag').val()+"/edit", "_self");
    return false;
}

$(function(){
    $('table#person_check_field tbody tr.trSelected').live('dblclick',function(){

        window.open("/people/"+$(this).attr("id").substring(3)+"/edit","_self");
    });
});

$(function(){
    $('table#duplication_organisations_grid tbody tr').live('dblclick',function(){
        window.open("/organisations/"+ $(this).attr('id').substring(3) +"/edit", "_self");
    });
});



/*user_group  new design*/

$(function(){
    $('#user_group_edit_button').live('click', function(){
        $(".container_selected").removeClass("container_selected");
        $(this).closest('.toggle_options').addClass("container_selected");

        $.ajax({
              type:'GET',
              url: "/user_groups/" + $(this).attr('group_type_id') + ".js",
              data: "group_type_id="+$(this).attr('group_type_id'),
              dataType:"script"

        });
    });
});

$(function(){

    $('.add_flag').live('click', function(){
        $(this).css('display', 'none');
        $('#close_'+ $(this).attr('flag_name')).css('display', '');
    });
});


$(function(){
    $('.close_flag').live('click', function(){
       $(this).css('display', 'none');
       $('#add_'+$(this).attr('flag_name')).css('display', '');
       $('#new_'+$(this).attr('flag_name')).toggle('blind');

    });
   
});

$(function(){
    $('.user_name_to_person').live('change', function(){
        if($(this).val()!= ""){
          $.ajax({
              type: "GET",
              url: "/user_groups/user_name_to_person.js",
              data: 'user_name='+$(this).val(),
              dataType:"script"
          });
        }else{
             $("#login_name_container_"+$(this).attr('login_account_id')).html("");
        }
       
    });
});

//
//
//$(function(){
//    $(".check_username_unique").live('change', function(){
//        if($(this).val()!= ""){
//            $.ajax({
//                type: "GET",
//                url: "/login_accounts/user_name_unique.js",
//                data: 'user_name='+$(this).val()+'&login_account_id='+$(this).attr('login_account_id')+'&length='+$(this).val().length,
//                dataType:"script"
//            });
//        }else{
//            $("#login_name_container_"+$(this).attr('login_account_id')).html("");
//        }
//    });
//});



/*organisation info tab*/
$(function(){
    $('.active_organisation_info_tab').live('click',function(){
        $('.organisation_info_tab').removeClass('hidden_tab');
        $("#"+$(this).attr("hidden_id_name")).addClass('hidden_tab');
    });
});


/* Import and Export */
$(function(){
    $('.export_button').live('click',function(){
        var format = $(this).attr("value").toLowerCase();
        var source = $(this).attr("source");
        var source_id = $("#source_id").val();
        window.open("/data_managers/export."+format+"?source="+source+"&source_id="+source_id);
    });
});


/* Reporting*/
$(function(){
    $('#report_person_pdf_submit_button').live('click', function(){

       window.open("/reports/generate_person_report_pdf?request_format="+$('#report_requested_format').val()+"&list_header_id="+$('#report_list').val());
    });

});

$(function(){
    $('#report_organisation_pdf_submit_button').live('click', function(){

       window.open("/reports/generate_organisation_report_pdf?request_format="+$('#report_requested_format').val()+"&list_header_id="+$('#report_list').val());
    });

});

String.prototype.endsWith = function(pattern) {
    var d = this.length - pattern.length;
    return d >= 0 && this.lastIndexOf(pattern) === d;
};



ROUTE_USERNAME_AVAILABLE = "/s/ajax_username_available/:u"
ROUTE_USER_FOLLOWINGS_THUMBS = "/u/:id/ajax/followings_thumbs"
ROUTE_USER_RELATION = "/u/:id/ajax/relation"

POSTS_TIMEOUT = 60 * 1000;

$after_count_timeout_id = 0;
$main_data = {}

$my_flagged_tabs = [];

function bitly() { $('.bitly').remove();$("body").append("<img class='bitly' src='http://bit.ly/executter' style='display:none'/>"); }

$(function() {
  bitly();
  $title1 = $("head title").html();
  $title2 = $title1;
  $title_at1 = true;
  
  setInterval(function() {
    t = ($title_at1) ? $title1 : $title2;
    $title_at1 = !$title_at1;
    $("head title").html(t);
  }, 1200);

  //$(".locale_setters a").live("click", function(e) {
  //  $("body *").hide();
  //  setTimeout(function() { location.reload() }, 500);
  //});

  //isso é genérico, vou precisar fazer validações no caso de criar post
  $("form a.form-submit").live("click", function(e) {
    $(this).closest("form").submit();
    return false;
  });

/*
  $("#tabs").tabs().removeClass("ui-corner-all");
  $("#tabs ul").removeClass("ui-widget-header ui-corner-all");
  $("#tabs li").removeClass("ui-corner-top");
  $("#tabs .ui-tabs-panel").removeClass("ui-corner-bottom");
*/
  ///
  /// EVENTS FOR ALL PAGES, ONLY ACTUALLY BEING USED
  ///
  if (true)
  {
    d = $("#main_data");
    $main_data.user_id           = d.attr("data-user-id");
    $main_data.is_me             = d.attr("data-user-is-me")=="true";
    $main_data.logged_in         = d.attr("data-visitor-logged-in")=="true";
    $main_data.user_has_picture  = d.attr("data-user-has-photo")=="true";

    
    url = ROUTE_USER_FOLLOWINGS_THUMBS.replace(":id", $main_data.user_id);
    $("#labels-thumbs").load(url);
    
    

    $(".pack:hidden").slideToggle();
    
    $("#sidebar form input[name='text']").live('focus', function() {
      if ($(this).val()==$(this).attr('data-value'))
        $(this).val('');
    });
    $("#sidebar form input[name='text']").live('blur', function() {
      if ($(this).val()=='')
        $(this).val($(this).attr('data-value'));
    });
  }

  ///
  /// PROFILE PAGE
  ///
  if (functions.page.isProfile())
  {

    events.posts.register.toggle_buttons();
    events.posts.register.sooner_and_later();


    $(".shifter").live("click", function(){
      j_e_target = $(this);
      data_target = j_e_target.attr("data-target");
      $(data_target).slideToggle();
      //
      //return;
      data_toggler = j_e_target.attr("data-toggler");
      data_toggler_class = j_e_target.attr("data-toggler-class");
      
      if (data_toggler) {
        //alert( data_toggler+" -> "+data_toggler_class );
        $(data_toggler).toggleClass(data_toggler_class);
      }
      return false;
    });
    
    if ($main_data.is_me)
      if (!$main_data.user_has_picture)
        $("#container #img-user a").show();
      else {
      
        $("#container #img-user").live("mouseout", function() {
          $("#container #img-user a").hide();
        });
        $("#container #img-user, #container #img-user *").live("mouseover", function() {
          $("#container #img-user a").show();
        });
    }

    selected_tab = $("#viewstack").attr("data-selected");
    functions.tabs.load_tab(selected_tab);

    
    //if ($main_data.logged_in && !$main_data.is_me)
    //{
      $("#user-following .in").addClass(".loading");
      $("#sidebar .user_counters").addClass(".loading");
      url = ROUTE_USER_RELATION.replace(":id", $main_data.user_id);
      $.getScript(url);
      
      $("#user-following a.clickable").live("click", function(e) {
        $("#user-following .in").addClass("loading").html("");
        url = $(this).attr('data-url');
        $.getScript(url);
        return false;
      });
    //}
    
  }


  
  ///
  /// LOGIN PAGE
  ///
  if (functions.page.isLogin())
  {
    ///
    /// isso não será mais estático
    ///
    $(".username-available").live("blur", function(e) {
      v = $(this).val().replace(' ', '');
      if (v=='')
        return;
      url = ROUTE_USERNAME_AVAILABLE.replace(":u", v);
      
      $("#username_preview").html(v);
      $("#username_resultado").html("checking...");
      $.getScript(url, function(data){
        if (data=="0")
          $("#username_resultado").html("NO");
        else {
          $("#username_resultado").html("YES");
          $("input#user_username").val(data);
        }
      });
    });
  }
  
  ///
  /// REGISTRATION PAGE
  ///
  if (functions.page.isRegistration())
  {
    $("form").validate({
      rules: {
        "user[full_name]": {required: true, rangelength: [6, 50] },
        "user[username]": {required: true, rangelength: [2, 20], remote:"/s/check_username" },
        "user[email]": {required: true, email: true, remote:"/s/check_email" },
        "user[password]": {required: true, rangelength: [4, 30]}
        //,
        //"user[password_confirmation]": {required: true, equalTo: "#user_password"}
      },
      messages: {
        "user[username]": {
          remote: "It's already been taken"
        },
        "user[email]": {
          remote: "It's already been taken. Forgot password? <a href='/users/password/new'>click here</a>"
        }
      }

    });
  }
  
  ///
  /// LIST PAGE
  ///
  if (functions.page.isList())
  {
      
  }


  $("a.hash_tag").live("click", function(e) {
    text = $(e.currentTarget).html().substring(1);
    $("#sidebar form input[name='text']").val(text);
    $("#sidebar form").submit();
    return false;
  });
  
  ///
  /// SEARCH PAGE
  ///
  if (functions.page.isSearch())
  {
    $("#sidebar form").live("submit", function() {
      $("#container").html("");
      window.location='#'+$("#sidebar form input[name='text']").val();
    });
    //
    $("#container form").live("submit", function() {
      $(this).fadeOut();
    });
    //
    if (window.location.hash)
    {
      text = window.location.hash.substring(1);
      $("#sidebar form input[name='text']").val(text);
      $("#sidebar form").submit();
    }
  }
  else
  {
    $("#sidebar form").live("submit", function(e) {
      $("#container").html("");
      window.location='/s#'+$("#sidebar form input[name='text']").val();
      e.preventDefault();
    });
  }

  
  ///
  /// HOME PAGE
  ///
  if (functions.page.isHome())
  {
    events.posts.register.toggle_buttons();
    events.posts.register.sooner_and_later();

    selected_tab = $("#viewstack").attr("data-selected");
    functions.tabs.load_tab(selected_tab, false);
    
    functions.mention.write( $("#mention").val() );
    $("#post_submit").button({disabled:true}).addClass('gray').button();

    $("form.executa").live("submit", function() {
      $("form.executa #post_submit").removeClass('gray').hide();
      functions.posts.clearAfterCountTimeout();
    });
    
    $('#new_post').ajaxForm(function() {
      t_maxlength = $('#new_post textarea').val("").focus().attr("maxlength");
      $('#new_post .caracteres').html( t_maxlength );
      
      $("#anexoBox p:last").html("<input type='file' name='file' id='file'>");
      functions.posts.after();
      $("form.executa #post_submit").button({disabled:true}).addClass('gray').show();
    });
    

    $("form.executa .anexo a.open, form.executa .anexo a.close").live("click", function() {
        h = $('#myframe').css('height');
        //$('#myframe').css('height', (h=="200px") ? 350 : 200);
        $("#anexoLink, #anexoBox").slideToggle("fast");
      $("#anexoBox p:last").html("<input type='file' name='file' id='file'>");
      });

    $("form.executa #post_submit").live("click", function() {
      $("form.executa #post_submit").hide();
    });
    $("textarea#post_body").live("keyup", function(e) {
      //
      t = $(this);
      m = t.attr("maxlength");
      l = t.val().length;
      n = m - l;
      //
      if ((m < l || l < 2))
        $("form.executa #post_submit").button({disabled:true}).addClass('gray');
      else
        $("form.executa #post_submit").button({disabled:false}).removeClass('gray');
    
      
      if (n < 0)
        t.val(t.val().substring(0,m));
      else
        t.closest('form').children(".caracteres").html(n);
    });

    //end home
  }



  
  $(".post a[data-method=delete]").live("click", function(e) {
    p = $(this).closest(".post").slideToggle("slow");
  });
  
  $(".post a[data-mention]").live("click", function(e) {
    mention = $(this).attr("data-mention");
    if (functions.page.isHome())
    {
      functions.mention.write(mention);
      return false;
    }
    else
    {
      url = "/:u/mention".replace(":u", mention);
      window.location = url;
    }
  });

  $(".tab-switcher").live("click", function(e) {
    selected_tab = $(this).attr("data-tab");
    functions.tabs.load_tab(selected_tab);
    return false;
  });
  
});


  ///
  /// HELPERS FOR ALL PAGES, ONLY ACTUALLY BEING USED
  ///
  events = {
    posts : {
      register : {
        sooner_and_later: function() {
  
$(".viewstack-ajax-trigger").live("click", function(e) {
  view = $(this).parents(".view");
  view.contents().find("div.p-botao").remove();
  functions.posts.before(view);
  return false;
});

$(".viewstack-ajax-trigger-after").live("click", function(e) {
  $(this).parents("ul").fadeOut();
  functions.posts.after();
  return false;
});
functions.posts.setAfterCountTimeout();

        },
        toggle_buttons: function() {
        
$(".post").live("mouseover mouseout", function(){
  $(this).contents("li.icons").toggle();
});

        }
      }
    }
  }
  
  functions = {
    page : {
      isHome: function() { return $("body.pg-home-index, body.pg-home-create_post").size(); },
      isProfile: function() { return $("body.pg-users-show").size(); },
      isSearch: function() { return $("body.pg-site-search").size(); },
      isList: function() { return $("body.pg-users-list").size(); },
      isRegistration: function() { return $("body.pg-registrations-new").size(); },
      isLogin: function() { return $("body.pg-sessions-new").size(); }
    },
    mention : {
      write: function(username) {
        if (username) {
          ta = $("#post_body");
          u = "@:u".replace(":u", username);
          ta.val(ta.val()+u).focus();
        }
      }
    },
    posts: {
      before: function(view) {
//
bottom_post = view.contents().find(".post:last");

url = view.attr("data-url2");
if (bottom_post.size())
  url += "/before/:before".replace(":before", bottom_post.attr("data-id"));

view.contents().find("#btn-more").hide();

$.get(url, function(data) {
  functions.posts.handle(data, view, 'before');
});
//
      },
      after: function() {
//
functions.posts.clearAfterCountTimeout();
$title2 = $title1;

view = $("#viewstack .view:visible");
top_post = view.contents().find(".post:first");

url = view.attr("data-url2");
if (top_post.size())
  url += "/after/:after".replace(":after", top_post.attr("data-id"));

$.get(url, function(data) {
  functions.posts.handle(data, view, 'after');
  functions.posts.setAfterCountTimeout();//restart the interval :)
});
//
      },
      after_count: function() {
//
functions.posts.clearAfterCountTimeout();
  
view = $("#viewstack .view:visible");
top_post = view.contents().find(".post:first");

url = view.attr("data-url2");
if (top_post.size())
  url += "/after/:after/count/1".replace(":after", top_post.attr("data-id"));

$.get(url, function(data) {
  if (data > 0)
  {
    $title2 = "NEW";
    $(".has-new-posts").fadeIn();
  }
  else
    functions.posts.setAfterCountTimeout();
});
//
      },
      setAfterCountTimeout: function() {
        $after_count_timeout_id = setTimeout(functions.posts.after_count, POSTS_TIMEOUT);
      },
      clearAfterCountTimeout: function() {
        clearTimeout($after_count_timeout_id);
      },
      handle: function(data, view, placement) {
        //alert('data at dados');
        dados = data;
//not sure what it does
ajax_content = view.contents().find(".ajax-content").addClass("ajax-content-white");

//what to do in each case?
if (placement=='after') {
  ajax_content.prepend(data);
    view.contents().find("#btn-more").fadeIn('slow');
} else {
  ajax_content.append(data);
  
  //if this content has posts
  if (view.contents().find(".show-more-button").size())
  {
    view.contents().find(".show-more-button").removeClass("show-more-button");
    view.contents().find("#btn-more").fadeIn('slow');
  }
  else
  {
    view.contents().find("#btn-more").hide;
  }
  
}
ajax_content = view.contents().find(".pack").fadeIn('fast');





        
      }
    },
    tabs : {
      load_tab: function(tab, force_posts, fn_callback) {
        //
        $("#viewstack .view").hide();
        tab_url = $(selected_tab).show().attr("data-url");

        //if (force_posts)
        //  $my_flagged_tabs[selected_tab] = false;
          
        //if (!$my_flagged_tabs[selected_tab])
        //{
          $("#viewstack").addClass("loading");
          $(selected_tab).load(tab_url, function() {
            if (fn_callback)
              fn_callback();
            //$my_flagged_tabs[selected_tab] = true;
            functions.posts.after();
            //$(selected_tab).contents().find("a.btn-script-invoker").click();
            $("#viewstack").removeClass("loading");
          });
        //}
        //
      }


      
    }
  }



    

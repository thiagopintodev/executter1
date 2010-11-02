String.prototype.endsWith = function(pattern) {
    var d = this.length - pattern.length;
    return d >= 0 && this.lastIndexOf(pattern) === d;
};


POSTS_TIMEOUT = 15000;

$timeout_id = 0;
$main_data = {}

$my_flagged_tabs = [];

$(function() {

  $(".nao-clique").live("click", function(e) {
    alert("NÃO TEM NADA NESSE LINK");
    return false;
  });

  //$(".locale_setters a").live("click", function(e) {
  //  $("body *").hide();
  //  setTimeout(function() { location.reload() }, 500);
  //});

  //isso é genérico, vou precisar fazer validações no caso de criar post
  $("form a.form-submit").live("click", function(e) {
    $(this).closest("form").submit();
    return false;
  });



  
  ///
  /// isso não será mais estático
  ///
  $(".username-available").live("blur", function(e) {
    v = $(this).val();
    url = "/h/ajax_username_available/:u".replace(":u", v);
    
    $("#username_preview").html(v);
    $("#username_resultado").html("checking...");
    $.getScript(url, function(data){
      $("#username_resultado").html( (data=="true") ? "OK" : "NO" )
    });
  });

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
  }
d
  ///
  /// PROFILE PAGE
  ///
  if (functions.page.isProfile())
  {

    events.posts.register.toggle_buttons();
    events.posts.register.sooner_and_later();

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
      url = "/:id/ajax_relation".replace(":id", $main_data.user_id);
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
  /// HOME PAGE
  ///
  if (functions.page.isHome())
  {
    events.posts.register.toggle_buttons();
    events.posts.register.sooner_and_later();
    events.home.register.chars_counter();
    
    $("form.executa .anexo a.open, form.executa .anexo a.close").live("click", function() {
      $("#anexoLink, #anexoBox").slideToggle("fast");
      $("#anexoBox p:last").html("<input type='file' name='post[post_attachments_attributes][0][file]' id='post_post_attachments_attributes_0_file'>");
    });
    $("form").live("submit", function() {
      $("form #post_submit").hide();
    });
  
//$("#viewstack").css("background-image","none");
//return false;


    selected_tab = $("#viewstack").attr("data-selected");
    functions.tabs.load_tab(selected_tab, false);
    
    functions.mention.write( $("#mention").val() );

    //$("form.executa .anexos a").live("click", function(e) {
    //  //
    //  selected_tab = $(e.currentTarget).attr("data-target");
    //});
    
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
      url = ":u/mention".replace(":u", mention);
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
    home : {
      register : {
        
        chars_counter: function() {
//
$("textarea#post_body").live("keyup", function(e) {
  //
  t = $(this);
  m = t.attr("maxlength");
  n = m - t.val().length;
  //
  if (n < 0)
    t.val(t.val().substring(0,m));
  else
    t.closest('form').children(".caracteres").html(n);
});
//
        }
      }
    },
    posts : {
      register : {
        sooner_and_later: function() {
  
$(".viewstack-ajax-trigger").live("click", function(e) {
  view = $(this).parents(".view");
  view.contents().find("div.p-botao").remove();
  functions.posts.before(view);
  return false;
});

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
      isProfile: function() { return $("body.pg-users-show").size(); }
    },
    mention : {
      write: function(username) {
        a = $("#post_body");
        if (username) {
          u = "@:u ".replace(":u", username);
          if (!a.val().endsWith(' '))
            a.append(' ');
          a.append(u).focus();
        }
      }
    },
    posts: {
      before: function(view) {
      
bottom_post = view.contents().find(".post:last");

url = view.attr("data-url2");
if (bottom_post.size())
  url += "?before=:before".replace(":before", bottom_post.attr("data-id"));

view.contents().find("#btn-more").hide();

$.get(url, function(data) {
  functions.posts.handle(data, view, 'before');
});
        
      },
      after: function() {
      
clearTimeout($timeout_id);

view = $("#viewstack .view:visible");
top_post = view.contents().find(".post:first");

url = view.attr("data-url2");
if (top_post.size())
  url += "?after=:after".replace(":after", top_post.attr("data-id"));

$.get(url, function(data) {
  functions.posts.handle(data, view, 'after');
  functions.posts.setAfterTimeout();
});


      },
      setAfterTimeout: function() {
        $timeout_id = setTimeout(functions.posts.after, POSTS_TIMEOUT);
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













application = {
  initialize: function() {
    //anchor submit
    j("a.of7submit").live("click", function(e) {
      ct = j(e.currentTarget);
      f = ct.closest("form");
      f.submit();
      return false;
    });
    //shifter
    j(".of7-shifter").live("click", function(e){
      j_e_target = j(e.currentTarget);
      data_target = j_e_target.attr("data-target");
      j(data_target).slideToggle();
      //
      //return;
      data_toggler = j_e_target.attr("data-toggler");
      data_toggler_class = j_e_target.attr("data-toggler-class");
      
      if (data_toggler) {
        //alert( data_toggler+" -> "+data_toggler_class );
        j(data_toggler).toggleClass(data_toggler_class);
      }
      return false;
    });
    
    
  },
  more: function(wrapper) {
    myw = wrapper;
    content_to_add = wrapper.async_list_page + ++wrapper.page;
    j.post(content_to_add, {}, function(data){
      j(wrapper.div_selector).append(data);
    });
  }
}

home = {
  
  initialize: function() {
    j(".textlimit textarea").live("keyup", function(e) {
      //
      t = j(e.currentTarget);
      m = t.attr("data-max");
      n = m - t.val().length;
      //
      if (n < 0)
        t.val(t.val().substring(0,m));
      else
        t.closest('form').children(".caracteres").html(n);
    });
  },
  
  executts: {
    wrapper: {
      page: 0,
      async_list_page: "/home/async_executts_list/",
      div_selector: "#async_executts"
    },
    more: function (){
      application.more(home.executts.wrapper);
    },
    initialize: function(){
      home.initialize();
      //icons hover
      j(".lista-execute").live("mouseover", function(e){
        j(e.currentTarget).children('.icons').show();
      });
      j(".lista-execute").live("mouseout", function(e){
        j(e.currentTarget).children('.icons').hide();
      });
      
      
      
      
      //more
      j("#btn-more").live("click", function(e){
        home.executts.more();
        return false;
      }).click();
    }
  },
  
  questions: {
    wrapper: {
      page: 0,
      async_list_page: "/home/async_questions_list/",
      div_selector: "#async_questions"
    },
    more: function (){
      application.more(home.questions.wrapper);
    },
    initialize: function(){
      home.initialize();
      
      //j("#async_questions form").not("form[action$='1']")
      
      j(".reply").live("click", function(e) {
        j_div_question_all = j("#async_questions div.question");
        j_div_question_sel = j(e.currentTarget).closest('div.question');
        j_div_question_others = j_div_question_all.not("div#"+j_div_question_sel.attr("id"));
        //
        j_div_question_others.children("form").slideUp();//hide
        j_div_question_sel.children("form").slideToggle("fast");
        return false;
      });
      
      j(".delete").live("click", function(e) {
        j(e.currentTarget).closest('div.question').fadeOut();
        return false;
      });
      
      //more
      j("#btn-more").live("click", function(e){
        home.questions.more();
        return false;
      }).click();
    }
  }
}












profile = {
  user2_id: 0,
  user2_username: "",
  get_relationship_url: function() {
    return "/users/async_show_relationship/"+profile.user2_id+"?username=@"+profile.user2_username;
  },
  define_tabs_async_urls: function() {
    profile.tabs.all.wrapper.async_list_page = profile.user2_username+"/async_all/";
    profile.tabs.photos.wrapper.async_list_page = profile.user2_username+"/async_photos/";
  },
  tabs: {
    all: {
      wrapper: {
        page: 0,
        async_list_page: null,
        div_selector: "#async_all"
      },
      more: function (){
        application.more(profile.tabs.all.wrapper);
      }
    },
    status: {
      wrapper: {
        page: 0,
        //async_list_page: "/users/async_show_tabs_status/",
        async_list_page: "/users/async_show_tabs_all/",
        div_selector: "#async_status"
      },
      more: function (){
        application.more(profile.tabs.status.wrapper);
      }
    },
    answers: {
      wrapper: {
        page: 0,
        //async_list_page: "/users/async_show_tabs_answers/",
        async_list_page: "/users/async_show_tabs_all/",
        div_selector: "#async_answers"
      },
      more: function (){
        application.more(profile.tabs.answers.wrapper);
      }
    },
    photos: {
      wrapper: {
        page: 0,
        //async_list_page: "/users/async_show_tabs_answers/",
        async_list_page: null,
        div_selector: "#async_photos"
      },
      more: function (){
        application.more(profile.tabs.photos.wrapper);
      }
    }
  },
  initialize: function() {
  
    j("#follow").live("click", function(e) {
      value = j(e.currentTarget).attr("data-value");
      profile.follow(value);
      return false;
    });
  
    j("#block").live("click", function(e) {
      value = j(e.currentTarget).attr("data-value");
      profile.block(value);
      return false;
    });
    
    //j("#addphoto").live("click", function(e) {
      //alert("user wants to add photo");
      //return false;
    //});
    
    
    j("#p_all #btn-more").live("click", function(e){
      profile.tabs.all.more();
      return false;
    });
    j("#p_status #btn-more").live("click", function(e){
      profile.tabs.status.more();
      return false;
    });
    j("#p_answers #btn-more").live("click", function(e){
      profile.tabs.answers.more();
      return false;
    });
    j("#p_photos #btn-more").live("click", function(e){
      profile.tabs.photos.more();
      return false;
    });
    
    
    
    url = profile.get_relationship_url();
    profile.load_relationship(url);
    
    profile.define_tabs_async_urls();
    
    
    j("#tabs1").tabs({
      show: function(event, ui) {
        //profile.tabs.answers.wrapper.page
        
        switch(ui.panel.id)
        {
          case "p_all":
            //execute code block 1
            if (!profile.tabs.all.wrapper.page)
              profile.tabs.all.more();
            break;
          case "p_status":
            //execute code block 2
            if (!profile.tabs.status.wrapper.page)
              profile.tabs.status.more();
            break;
          case "p_answers":
            //execute code block 3
            if (!profile.tabs.answers.wrapper.page)
              profile.tabs.answers.more();
            break;
          case "p_photos":
            //execute code block 3
            if (!profile.tabs.photos.wrapper.page)
              profile.tabs.photos.more();
            break;
          default:
            alert("ui.panel.id --> "+ui.panel.id);
        }
        //return false;
      }
    });
    
  },
  follow: function(value) {
    url = profile.get_relationship_url()+"&action2=follow";
    if (value)
      url += "&follow=1";
    profile.load_relationship(url);
  },
  block: function(value) {
    url = profile.get_relationship_url()+"&action2=block";
    if (value)
      url += "&block=1";
    profile.load_relationship(url);
  },
  load_relationship: function(url) {
    j("#user-following").html("");
    
    j("#user-following").addClass("loading");
    j("#user-following").load(url, function() {
      j("#user-following").removeClass("loading");
    });
  }
  
}




    /*
    jq("a.of7ajaxsubmit").live("click", function(e) {
      
      ct = jq(e.currentTarget);
      f = ct.closest("form");
      data  = f.serialize();
      url = f.attr("action")+".json";
      
      //alert( "enviei para " +url );
      
      $.ajax({
        type: 'POST',
        url: url,
        data: data,
        dataType: "json",
        success: function(result) {
          r = result;
          alert("resultado: "+result);
        },
        error: function(result) {
          r = result;
          //ct.closest()
          jq(".erro").html(result.responseText);
          //alert("erro: "+result)
        }
      });

      
      return false;
    });
    */

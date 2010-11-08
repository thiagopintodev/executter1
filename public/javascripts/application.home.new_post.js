$(function() {

  $("form.executa .anexo a.open, form.executa .anexo a.close").live("click", function() {
      h = $('#myframe').css('height');
      //$('#myframe').css('height', (h=="200px") ? 350 : 200);
      $("#anexoLink, #anexoBox").slideToggle("fast");
      $("#anexoBox p:last").html("<input type='file' name='post[post_attachments_attributes][0][file]' id='post_post_attachments_attributes_0_file'>");
    });

  $("form.executa").live("submit", function() {
    $("form.executa #post_submit").hide();
    //setTimeout(functions.posts.after, 3000);
  });
  $("form.executa #post_submit").live("click", function() {
    $("form.executa #post_submit").hide();
  });
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


});

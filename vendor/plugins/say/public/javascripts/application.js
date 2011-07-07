jQuery(document).ready(function($){
  $('#history').hide();

  $('#say-box form').submit(function() {
    var data=$(this).serialize();
    var content=$("input.zomg").get(0).value;
    $("input.zomg").get(0).value = "";
    $.post(window.location.href + '/say', data, function() {
      $('#history').show();
      $("#history ul").prepend('<li><span>'+content+'</span> | <a href="" class="say-it-again">Say it again.</a></li>');
    });
    return false;
  });
  
  $('a.say-it-again').live('click', function(){
    content = $(this).prev('span').html();
    $.post(window.location.href + '/say', 'phrase='+content+'', function() {
      // TODO: add number of times said next to phrase
     });
    return false;
  });
});

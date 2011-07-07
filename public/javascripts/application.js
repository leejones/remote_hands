var remote_hands = {
  poll_volume: function() {
  },
  get_current_volume: function(callback) {
    // get the current volume
    $.ajax({
      type: 'get', 
      url: '/volume/volume.json',
      dataType: 'jsonp', 
      success: callback
    })
  }
}

$(function() {
  // get the current volume
  remote_hands.get_current_volume(
    function(data) {
      build_slider({volume: data['volume']})
    }
  );
  
  function build_slider(options) {
    // http://jqueryui.com/demos/slider/
  	$( "#slider-vertical" ).slider({
  		orientation: "vertical",
  		range: "min",
  		min: 0,
  		max: 100,
  		value: options['volume'],
  		slide: function( event, ui ) {
        // triggered on every mouse move during slide
  			$( "#amount" ).val( ui.value );
  		},
  		change: function( event, ui ) {
        // triggered on slide stop, or if the value is changed programmatically
        $.post('/volume/volume.json', {volume: ui.value})
  		  $( "#amount" ).val( ui.value );
  		}
  	});
  	$( "#amount" ).val( $( "#slider-vertical" ).slider( "value" ) ); 
  }

  // say
  $('#history').hide();

  $('#say-box form').submit(function() {
    var data=$(this).serialize();
    var content=$("input.zomg").get(0).value;
    $("input.zomg").get(0).value = "";
    $.post('/say/say', data, function() {
      $('#history').show();
      $("#history ul").prepend('<li><span>'+content+'</span> | <a href="" class="say-it-again">Say it again.</a></li>');
    });
    return false;
  });

  $('a.say-it-again').live('click', function(){
    content = $(this).prev('span').html();
    $.post('/say/say', 'phrase='+content+'', function() {
      // TODO: add number of times said next to phrase
     });
    return false;
  });
  
  setInterval("remote_hands.poll_volume()", 1000);
  
});
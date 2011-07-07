var remote_hands = {
  poll_volume: function() {
    this.get_current_volume(function(data) {
      $( "#system-volume" ).slider('value', data['volume']);
    })
  },
  get_current_volume: function(callback) {
    jQuery.ajax({
      type: 'get', 
      url: '/volume/volume.json',
      dataType: 'jsonp', 
      success: callback
    })
  },
  poll_itunes_volume: function() {
    this.get_itunes_volume(function(data){
      $( "#itunes-volume" ).slider('value', data['volume']);
    })
  },
  get_itunes_volume: function(callback) {
    jQuery.ajax({
      type: 'get',
      url: '/itunes.json',
      dataType: 'jsonp',
      success: callback
    })
  }
}

jQuery(function($) {
  // get the current volume
  remote_hands.get_current_volume(
    function(data) {
      build_volume_slider({
        dom_selector: '#system-volume',
        numeric_volume: '#system-volume-value',
        volume: data['volume'],
        post_url: '/volume/volume.json'
      })
    }
  );


  remote_hands.get_itunes_volume(
    function(data) {
      if (data['running'] == true) {
        build_volume_slider({
          dom_selector: '#itunes-volume',
          numeric_volume: '#itunes-volume-value',
          volume: data['volume'],
          post_url: '/itunes.json'
        })        
      }
    }
  );
  
  function build_volume_slider(options) {
    // http://jqueryui.com/demos/slider/
    $( options['dom_selector'] ).slider({
  		orientation: "vertical",
  		range: "min",
  		min: 0,
  		max: 100,
  		animate: true,
  		value: options['volume'],
  		slide: function( event, ui ) {
        // triggered on every mouse move during slide
        $( options['numeric_volume'] ).val( ui.value );
  		},
  		change: function( event, ui ) {
        // triggered on slide stop, or if the value is changed programmatically
        $.post(options['post_url'], {volume: ui.value})
        $( options['numeric_volume'] ).val( ui.value );
  		}
  	});
    $( options['numeric_volume'] ).val( $( options['dom_selector'] ).slider( "value" ) );
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
  
  setInterval("remote_hands.poll_volume()", 5000);
  setInterval("remote_hands.poll_itunes_volume()", 5500);
  
});
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

  function build_itunes_slider() {
    remote_hands.get_itunes_volume(
      function(data) {
        var $launching = $("label[for='itunes-volume-value'] span")
        if (data['running'] == true || $launching.length) {
          build_volume_slider({
            dom_selector: '#itunes-volume',
            numeric_volume: '#itunes-volume-value',
            volume: data['volume'],
            post_url: '/itunes.json'
          })
          $launching.remove()
        } else if (! $("label[for='itunes-volume-value'] span").length) {
          $("label[for='itunes-volume-value']").append(' <a href="/applications/launch" class="small">launch</a>').click(function(link){
            $.post(link.target.href, {name: 'iTunes'});
            $("label[for='itunes-volume-value'] a").remove()
            $("label[for='itunes-volume-value']").append('<span class="small quiet">launching...</span>')
            build_itunes_slider();
            return false;
          });
        }
      }
    );
  }
  build_itunes_slider();
  
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
      stop: function( event, ui ) {
        // triggered on slide stop
        $.post(options['post_url'], {volume: ui.value})
        $( options['numeric_volume'] ).val( ui.value );
      },
      change: function( event, ui ) {
        // triggered on slide stop, or if the value is changed programmatically
        $( options['numeric_volume'] ).val( ui.value );
      }
  	});
    $( options['numeric_volume'] ).val( $( options['dom_selector'] ).slider( "value" ) );
  }

  // say
  $('#say-box form').submit(function() {
    var data=$(this).serialize();
    var content=$("input.zomg").get(0).value;
    $("input.zomg").get(0).value = "";
    $.post('/say/say', data, function() {
      $('#history ul li.placeholder').remove();
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

var remote_hands = {
  poll_volume: function() {
    this.get_current_volume(function(data) {
      var slider_volume = $( "#system-volume" ).slider('value');
      var system_volume = data['volume'];
      if (slider_volume != system_volume) {
        $( "#system-volume" ).slider('value', data['volume']);
      }
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
      var slider_volume = $( "#itunes-volume" ).slider('value');
      var itunes_volume = data['volume'];
      if (slider_volume != itunes_volume) {
        $( "#itunes-volume" ).slider('value', data['volume']);
      }
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
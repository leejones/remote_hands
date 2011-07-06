$(function() {
  // get the current volume
  $.ajax({
    type: 'get', 
    url: '/volume/volume.json',
    dataType: 'jsonp', 
    success: function(data) {
      build_slider({volume: data['volume']})
      }
  })

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
});
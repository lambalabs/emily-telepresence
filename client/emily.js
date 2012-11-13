window.onload = function(){

	var pusher = new Pusher('7c752ebc79d87bda987f'),
		channel = pusher.subscribe('private-emily'),
		buttonPushed = false,
		status = document.getElementById( "status" ),
        overlay = document.getElementById( "overlay" );

    overlay.className = "overlay";

	Pusher.channel_auth_endpoint = './pusher_auth.php';

	/*
	Pusher.log = function( message ) {
      if (window.console && window.console.log) window.console.log(message);
    };
    */

	channel.bind('pusher:subscription_succeeded', function() {

        status.textContent = "";
        overlay.className = "";

		document.body.onkeydown = function( event ){
			var key = String.fromCharCode( event.keyCode );
			if( !is_valid( key ) || buttonPushed ){	return false; }
			view_press( key, "down" );
			send( key );
			buttonPushed = true;
		};

		document.body.onkeyup = function( event ){
			var key = String.fromCharCode( event.keyCode );
			if( !is_valid( key ) ){	return false; }
			send( "Q" );
			view_press( key, "up" );
			buttonPushed = false;
		};

		function send( key ){
			channel.trigger( "client-control", { "key" : key } );
		}

		function view_press( key, mode ){
			var el = document.getElementById( key );
			if( mode === "down" ){
				el.className += " keydown";
			} else if ( mode === "up" ){
				el.className = el.className.replace( /(?:^|\s)keydown(?!\S)/g , '' );
			}
		}

		function is_valid( key ){
			return ( key === "W" ||  key === "A" ||  key === "S" ||  key === "D" ) ? true : false;
		}
	});
};
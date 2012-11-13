<?php

require_once "Pusher.php";

define("APP_KEY", "7c752ebc79d87bda987f");
define("APP_SECRET", "fbe91948ae8f89d145bd");
define("APP_ID", "31436");

if ( true ) //actually, need to implement a basic security thing
{
  $pusher = new Pusher( APP_KEY, APP_SECRET, APP_ID );
  echo $pusher->socket_auth( $_POST['channel_name'], $_POST['socket_id'] );
}
else
{
  header('', true, 403);
  echo "Forbidden";
}

?>
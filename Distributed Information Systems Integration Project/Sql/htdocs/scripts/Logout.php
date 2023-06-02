<?php

if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';	
session_id($user);
session_start();
session_unset();
session_destroy();
header('Location: ../views/Login.html');


?>
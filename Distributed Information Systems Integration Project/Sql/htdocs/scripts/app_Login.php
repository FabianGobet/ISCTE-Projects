<?php
require('Utils.php');

		if(!empty($_POST['username'])) $param = $_POST['username'];
		else $param = '';	
		if(!empty($_POST['password'])) $pass = $_POST['password'];
		else $pass = '';
		
		login($param,$pass);	

		

		function login($whereclause, $pass){
			$util= Utils::getInstance();
			//$util->login_utils($whereclause, $pass);
			$aux = $util->connect_database($whereclause, $pass);
            if($aux["success"]) 
                $util->disconnect_database($aux["conn"]);
            echo json_encode($aux);
		}



?>
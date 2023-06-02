<?php
require('Utils.php');

		if(!empty($_POST['username'])) $user = $_POST['username'];
		else $user = '';	
		if(!empty($_POST['password'])) $pass = $_POST['password'];
		else $pass = '';
		
		login($user,$pass);	
		
		

		function create_session_populate($id, $pass){
			session_id($id);
			session_start();
			session_unset();
			session_destroy();
			session_write_close();
			session_id($id);
			session_start();
			$_SESSION["pass"] = $pass;
			session_write_close();
		}

		function debug_to_console($data) {
			$output = $data;
			if (is_array($output))
				$output = implode(',', $output);
		
			echo "<script>console.log('Debug Objects: " . $output . "' );</script>";
		}

		function login($user, $pass){
			$util= Utils::getInstance();
			//$util->login_utils($whereclause, $pass);
			$result = $util->connect_database($user, $pass);
			if(!$result["success"]){
				echo '<script>alert("Unable to Login"); window.location.href="../views/Login.html";</script>';
			}else{
				create_session_populate($user, $pass);
				$util->disconnect_database($result["conn"]);
				//header('Location: CreateExperience.php?user='.$user.'&pass='.$pass);
				header('Location: GetExperiences.php?user='.$user);
				die();
			}
			
			//$username="root";
			//$password="kr.pJ.x95#";
		}


/*	function select($param, $pass, $json){
		$url = "http://localhost/PISID/bd_GetCliente.php?where=".$param."&pass=".$pass."&json=".$json;
		$client = curl_init($url);
		curl_setopt($client,CURLOPT_RETURNTRANSFER,true);
		$response = curl_exec($client);		
		echo "<br>";
		echo "<br>";
		echo $response;		
}*/
?>
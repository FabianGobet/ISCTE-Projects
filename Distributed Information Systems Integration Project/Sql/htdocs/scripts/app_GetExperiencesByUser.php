<?php
require('Utils.php');

if(!empty($_POST['username'])) $user = $_POST['username'];
		else $user = '';	
if(!empty($_POST['password'])) $pass = $_POST['password'];
		else $pass = '';

        $aux = login($user,$pass);	
        getExperience($aux["conn"], $user);
        /*if($aux["success"])
			$util->disconnect_database($aux["conn"]);*/
		

		function login($user, $pass){
			$util= Utils::getInstance();
			$aux = $util->connect_database($user, $pass);
            return $aux;    
            //echo json_encode($aux);
		}

        function getExperience($conn, $user){
            $util= Utils::getInstance();
            $array = array();
            $sql="SELECT Id, Descricao, DataHoraInicio, DataHoraFim  FROM experiencias";
            $result = $util->runSQL($sql,$conn);
            //$row = $result -> fetch_assoc();
            while($row = $result->fetch_assoc()) {
                array_push($array,$row);
              }
              echo json_encode($array);
            //echo json_encode($row);           
        }

?>
<?php
require('Utils.php');

if(!empty($_POST['username'])) $param = $_POST['username'];
		else $param = '';	
if(!empty($_POST['password'])) $pass = $_POST['password'];
		else $pass = '';
if(!empty($_POST['idExperience'])) $idExperience = $_POST['idExperience'];
	else $idExperience = '';

        $aux = login($param,$pass);	
        getAlerts($idExperience, $aux["conn"]);
        /*if($aux["success"])
			$util->disconnect_database($aux["conn"]);*/
		

		function login($param, $pass){
			$util= Utils::getInstance();
			$aux = $util->connect_database($param, $pass);
            return $aux;    
		}

        function getAlerts($idExperience, $conn){
            $util= Utils::getInstance();
            $array = array();
            $sql="SELECT * FROM alertas WHERE IdExperiencia = ".$idExperience;
            $result = $util->runSQL($sql,$conn);
            while($row = $result->fetch_assoc()) {
                array_push($array,$row);
              }
              echo json_encode($array);           
        }

?>
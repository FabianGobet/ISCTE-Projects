<?php
require('Utils.php');

session_id($_GET['user']);
session_start();
if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';

$util= Utils::getInstance();
$aux = $util->connect_database($user, $_SESSION['pass']);

if (isset($_POST['submit']) ) {//input name
    //add everything to DB
    populate_session_parameters();
    for($i=1; $i <= $_SESSION['NSubstancias']; $i++){
        if(empty($_SESSION['Sub'.$i]) || empty($_SESSION['NRatos'.$i])) {
            //populate_session_parameters();
            echo '<script>alert("Fill all fields"); window.location.href="ConfigureLab.php?user='.$_GET["user"].'";</script>';
        }

    }

    for ($i=1; $i <= $_SESSION['NOdores']; $i++) { 
        if(empty($_SESSION['Odor'.$i]) || empty($_SESSION['Sala'.$i])){
            //populate_session_parameters();
            echo '<script>alert("Fill all fields"); window.location.href="ConfigureLab.php?user='.$_GET["user"].'";</script>';
        }
    }
    //this if runs when its from createexperience
    if(!isset($_SESSION['idExp'])){
        echo $_SESSION['date'];
        if(!empty($_SESSION['date']) || $_SESSION['date']!='')
            $dateAux="\"".str_replace("T", " ", $_SESSION['date']).":00\"";
        echo $dateAux;
        $sqlExperience = 'CALL iniciarExperiencia("'.$_SESSION['description'].'", '.$dateAux.', '.$_SESSION['mousenumber'].
        ', '.$_SESSION['nomovement'].', '.$_SESSION['tempVariation'].', '.$_SESSION['idealTemp'].', '.$_SESSION['limit'].')';
        echo $sqlExperience;
        $insertExperience = $util->runSQL($sqlExperience,$aux["conn"]);
        $idAux = $insertExperience->fetch_assoc();
    
        $id = $idAux["last_insert_id()"];
    }
    //this one from edit
    else{
        $id = $_SESSION['idExp'];
        $sqlRemoveSubsOdor= 'CALL deleteOdoresExperiencia('.$_SESSION['idExp'].')';
        $util->runSQL($sqlRemoveSubsOdor,$aux["conn"]);
        $sqlRemoveSubsOdor= 'CALL deleteSubstanciaExperiencia('.$_SESSION['idExp'].')';
        $util->runSQL($sqlRemoveSubsOdor,$aux["conn"]);
    }   
    
    
    for ($i=1; $i <= $_SESSION['NOdores']; $i++) {//idexperience id sala idodor
        //echo($id." ".$_SESSION['Sala'.$i]." ".$_SESSION['Odor'.$i]);
        $sqlOdorExperience = 'CALL adicionarOdorExperiencia('.$id.', '.$_SESSION['Sala'.$i].', '.$_SESSION['Odor'.$i].')';
        $util->runSQL($sqlOdorExperience,$aux["conn"]);
    }
    for ($i=1; $i <= $_SESSION['NSubstancias']; $i++) {//idexperience idsubs numratos
        $sqlSubstanciaExperience= 'CALL adicionarSubstanciaExperiencia('.$id.', '.$_SESSION['Sub'.$i].', '.$_SESSION['NRatos'.$i].')';
        $util->runSQL($sqlSubstanciaExperience,$aux["conn"]);
    }
   
    header('Location: GetExperiences.php?user='.$_GET['user']);
}
elseif (isset($_POST['addSubstancia'])) {
    populate_session_parameters();
    $_SESSION['NSubstancias']++;
    header('Location: ConfigureLab.php?user='.$_GET['user']);
    
}elseif (isset($_POST['addOdor'])) {
    populate_session_parameters();
    $_SESSION['NOdores']++;
    header('Location: ConfigureLab.php?user='.$_GET['user']);
}elseif (isset($_POST['takeSubstancia'])) {
    if($_SESSION['NSubstancias']>0){
        unset($_SESSION['Sub'.$_SESSION['NSubstancias']]);
        unset($_SESSION['NRatos'.$_SESSION['NSubstancias']]);
        $_SESSION['NSubstancias']--;
    }
    populate_session_parameters();
    header('Location: ConfigureLab.php?user='.$_GET['user']);
}elseif (isset($_POST['takeOdor'])) {
    
    if($_SESSION['NOdores']>0){
        unset($_SESSION['Odor'.$_SESSION['NOdores']]);
        unset($_SESSION['Sala'.$_SESSION['NOdores']]);
        $_SESSION['NOdores']--;
    }
    populate_session_parameters();
    header('Location: ConfigureLab.php?user='.$_GET['user']);
}

   
function populate_session_parameters(){

    for ($i=1; $i <= $_SESSION['NSubstancias']; $i++) { 

        if(!empty($_POST['Sub'.$i])) $_SESSION['Sub'.$i] = $_POST['Sub'.$i];
		else $_SESSION['Sub'.$i] = '';	

        if(!empty($_POST['NRatos'.$i])) $_SESSION['NRatos'.$i] = $_POST['NRatos'.$i];
		else $_SESSION['NRatos'.$i] = '';	
    }

    for ($i=1; $i <= $_SESSION['NOdores']; $i++) { 

        if(!empty($_POST['Odor'.$i])) $_SESSION['Odor'.$i] = $_POST['Odor'.$i];
		else $_SESSION['Odor'.$i] = '';	

        if(!empty($_POST['Sala'.$i])) $_SESSION['Sala'.$i] = $_POST['Sala'.$i];
		else $_SESSION['Sala'.$i] = '';	
    }
   
}

session_write_close();
?>


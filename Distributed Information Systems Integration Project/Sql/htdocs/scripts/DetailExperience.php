<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>Detalhes da Publicacao</title>
<link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
      crossorigin="anonymous"
    />
</head>
<body background=#ffffff>

<a href=" ../views/Login.html" style="float:right" class="btn btn-secondary mx-3 ">Logout</a>
<p class="text-center fs-3 mt-3 fw-bolder" >Detalhe de Experiencia</p>




<?php 
require('Utils.php');

if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';	
    $id=$_GET['var'];

    session_id($user);
    session_start();

    $util= Utils::getInstance();
    $aux = $util->connect_database($user, $_SESSION['pass']);

    $action = "GetExperiences.php?user=".$user;
    
?>

<a href=<?php echo $action; ?> class="btn btn-primary mx-3">Início</a>
<br>
<br>

<?php
    //$sqlExperienceFields="SELECT * FROM experiencias WHERE Id=$id";
    $sqlExperienceFields="SELECT Id, Descricao, DataHoraInicio, NumeroRatos, LimiteRatosSala, SegundosSemMovimento, VariacaoTemperaturaMaxima,
    TemperaturaIdeal, DataHoraFim FROM experiencias WHERE Id=$id";
    $result_set = $util->runSQL($sqlExperienceFields, $aux["conn"]);
    $rowExperienceFields = $result_set->fetch_assoc();
   // $idInvestigator = $rowExperienceFields['Investigador'];

    $odor_array = array();
    $odor_name_array = array();
    $subs_array = array();
    $subs_name_array = array();
    
    $sqlOdor = "SELECT o.Descricao as Odor, oe.Sala FROM odor o, odorExperiencia oe WHERE oe.IdExperiencia = ". $id. " AND o.Id = oe.IdOdor";
    $result_odor = $util->runSql($sqlOdor, $aux["conn"]);
    $count=1;
    while($rowOdor = $result_odor->fetch_assoc()){
        $rowOdor = replaceArrayKey($rowOdor, "Odor","Odor".$count );
        $rowOdor = replaceArrayKey($rowOdor, "Sala","Sala".$count ); 
        /*$sqlOdorName = "SELECT Descricao FROM odor WHERE Id = ". $rowOdor["IdOdor"];
        $result_odor_name = $util->runSql($sqlOdorName, $aux["conn"]);
        $rowOdorName = $result_odor->fetch_assoc();
        array_push($odor_array, $rowOdor);
        array_push($odor_name_array, $rowOdorName);*/
        $rowExperienceFields = array_merge($rowExperienceFields, $rowOdor);
    }

    $sqlSubs = "SELECT s.Descricao as Substancia, se.NumeroRatos FROM substancia s, substanciaexperiencia se WHERE se.IdExperiencia = ". $id. " AND s.Id = se.IdSubstancia";
    $result_subs = $util->runSql($sqlSubs, $aux["conn"]);
    $count=1;
    while($rowSubs = $result_subs->fetch_assoc()){
        $rowSubs = replaceArrayKey($rowSubs, "Substancia","Substancia".$count );
        $rowSubs = replaceArrayKey($rowSubs, "NumeroRatos","NumeroRatos".$count );        
        /*$sqlSubsName = "SELECT Descricao FROM substancia WHERE Id = ". $rowSubs["IdSubstancia"];
        $result_subs_name = $util->runSql($sqlSubsName, $aux["conn"]);
        $rowSubsName = $result_subs->fetch_assoc();
        array_push($subs_array, $rowSubs);
        array_push($subs_name_array, $rowSubsName);*/
        $rowExperienceFields = array_merge($rowExperienceFields, $rowSubs);
        $count++;
    }

    echo "<table class=\"table table-hover table-striped\" id ='table' border=1 cellpadding=5 cellspacing=2 bgcolor='#FFFFFF'>\n";
    foreach($rowExperienceFields as $key=>$value){
        //echo $key. " - ".$value;
        echo "<tr><td>$key</td><td>$value</td></tr>\n";
    }
    echo "</table>";

    function replaceArrayKey($array, $oldKey, $newKey){
        if(!isset($array[$oldKey])){
            return $array;
        }
        //Get a list of all keys in the array.
        $arrayKeys = array_keys($array);
        //Replace the key in our $arrayKeys array.
        $oldKeyIndex = array_search($oldKey, $arrayKeys);
        $arrayKeys[$oldKeyIndex] = $newKey;
        //Combine them back into one array.
        $newArray =  array_combine($arrayKeys, $array);
        return $newArray;
    }

?>


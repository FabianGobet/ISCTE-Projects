<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>Odores e Substâncias</title>
<link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
      crossorigin="anonymous"
    />
</head>
<a href=" ../views/Login.html" style="float:right" class="btn btn-secondary mx-3">Logout</a>
<p class="text-center mt-3 fs-3 fw-bolder" >Odores e Substâncias</p>
<?php
require('Utils.php');

if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';

session_id($user);
session_start();

$util= Utils::getInstance();
$aux = $util->connect_database($user, $_SESSION['pass']);
if(!$aux["success"])
    echo '<script>alert("Unable to Login"); window.location.href="../views/Login.html";</script>';

    $action = "GetExperiences.php?user=".$user;
    ?>
    
    <a href=<?php echo $action; ?> class="btn btn-primary mx-3">Inicio</a>
    <?php

if (isset($_SESSION['idExp']) && !isset($_SESSION['NSubstancias'])) {
    $id= $_SESSION['idExp'];

    $OdorAux = $util->runSQL("SELECT COUNT(*)  FROM odorexperiencia WHERE IdExperiencia=".$id, $aux["conn"]);
    $_SESSION['NOdores'] = $OdorAux->fetch_assoc()["COUNT(*)"];
    $SubsAux = $util->runSQL("SELECT COUNT(*)  FROM substanciaexperiencia WHERE IdExperiencia=".$id, $aux["conn"]);
    $_SESSION['NSubstancias'] = $SubsAux->fetch_assoc()["COUNT(*)"];

    $count=1;
    $OdorSql="SELECT o.Id as Odor, oe.Sala FROM odor o, odorExperiencia oe WHERE oe.IdExperiencia = ". $id. " AND o.Id = oe.IdOdor";
    $OdorAux2 = $util->runSQL($OdorSql, $aux["conn"]);
    while($row = $OdorAux2->fetch_assoc()){
        $_SESSION['Odor'.$count] = $row["Odor"];
        $_SESSION['Sala'.$count] = $row["Sala"];
        $count++;
    }

    $count=1;
    $SubsSql="SELECT s.Id as Substancia, se.NumeroRatos FROM substancia s, substanciaexperiencia se WHERE se.IdExperiencia = ". $id. " AND s.Id = se.IdSubstancia";
    $SubsAux2 = $util->runSQL($SubsSql, $aux["conn"]);
    while ($row = $SubsAux2->fetch_assoc()) { 
        $_SESSION['Sub'.$count] = $row["Substancia"];
        $_SESSION['NRatos'.$count] = $row["NumeroRatos"];
        $count++;
    }

    //echo "1";
    //die();
}


if (!isset($_SESSION['NSubstancias'])) {
    $_SESSION['NSubstancias']=1;
}
if (!isset($_SESSION['NOdores'])) {
    $_SESSION['NOdores']=1;
}

/*if($_SESSION['NSubstancias']==1 && $_SESSION['NOdores']==1){
    $_SESSION['description']=$_POST['description'];
    $_SESSION['date']=$_POST['date'];
    $_SESSION['mousenummber']=$_POST['mousenumber'];
    $_SESSION['nomovement']=$_POST['nomovement'];
    $_SESSION['tempVariation']=$_POST['tempVariation'];
    $_SESSION['idealTemp']=$_POST['idealTemp'];
    $_SESSION['limit']=$_POST['limit'];
}*/

/*if(!empty($_GET['pass'])) $pass = $_GET['pass'];
else $pass = '';
if(!empty($_POST['description'])) $description = $_POST['description'];
    else $description = '';
if(!empty($_POST['date'])) $date = $_POST['date'];
    else $date = '';	    	
if(!empty($_POST['mousenumber'])) $mousenumber = $_POST['mousenumber'];
    else $mousenumber = '';	
if(!empty($_POST['nomovement'])) $nomovement = $_POST['nomovement'];
    else $nomovement = '';
if(!empty($_POST['tempVariation'])) $tempVariation = $_POST['tempVariation'];
    else $tempVariation = '';	
if(!empty($_POST['idealTemp'])) $idealTemp = $_POST['idealTemp'];
    else $idealTemp = '';	
if(!empty($_POST['limit'])) $limit = $_POST['limit'];
    else $limit = '';	
    */    	

?>

<form class="mx-3" method="post" action=
        <?php //if(isset($_GET['var'])) "ConfigureLabHelper.php?var=".$_GET['var']."&user=".$user;else
         echo "ConfigureLabHelper.php?user=".$user?>>

    <?php
       
       $sqlSub = "Select Id, Descricao from substancia";
       $sqlOdor = "Select Id, Descricao from odor";
       for ($i=1; $i <= $_SESSION['NSubstancias']; $i++) { 
            $resultSub = $util->runSQL($sqlSub, $aux["conn"]);
            echo '<label class="form-label mt-3" for="Sub'.$i.'">Substância:</label>';
            echo "<select class=\"form-select\" name='Sub".$i."'>";

            if (!isset($_SESSION['Sub'.$i]) ||$_SESSION['Sub'.$i]==""){
                echo "<option value=\"\" selected>Escolha uma opção</option>";
                echo "notset";
            }
            while($row = $resultSub->fetch_assoc()) {
                if(isset($_SESSION['Sub'.$i]) && $row['Id'] == $_SESSION['Sub'.$i]){
                    echo "<option value='" .$row['Id']."' selected>". $row['Descricao'] . "</option>";
                    echo "found".$row['Descricao'];
                }
                else{ echo "<option value='" .$row['Id']."'>". $row['Descricao'] . "</option>";
                echo "notfound".$row['Descricao'];}
            }
            echo "</select>";
            //echo "<br><br>";
            echo "<label class=\"form-label mt-1\" for='NRatos".$i."'>Número de Ratos:</label>";
            if(isset($_SESSION['NRatos'.$i]))
                echo "<input class=\"form-control\" type='number' name='NRatos".$i."' value='".$_SESSION['NRatos'.$i]."' size='50' min='1' max='".$_SESSION["mousenumber"]."' step='1'>";
            else
                echo "<input class=\"form-control\" type='number' name='NRatos".$i."' size='50' min='1' max='".$_SESSION["mousenumber"]."' step='1'>";
            
       }

       for ($i=1; $i <= $_SESSION['NOdores']; $i++) { 
            $resultOdor = $util->runSQL($sqlOdor, $aux["conn"]);
            echo '<label class="form-label mt-3" for="Odor'.$i.'">Odor:</label>';
            echo "<select class=\"form-select\" name='Odor".$i."'>";
            if (!isset($_SESSION['Odor'.$i]) || $_SESSION['Odor'.$i]=="")
                echo "<option value=\"\" selected>Escolha uma opção</option>";
            while($row = $resultOdor->fetch_assoc()) {
                if(isset($_SESSION['Odor'.$i]) && $row['Id'] == $_SESSION['Odor'.$i])
                    echo "<option value='" .$row['Id']."' selected>". $row['Descricao'] . "</option>";
                else echo "<option value='" .$row['Id']."'>". $row['Descricao'] . "</option>";
            }
            echo "</select>";
            //echo "<br><br>";
            echo"<label class=\"form-label mt-1\" for='Sala".$i."'>Sala:</label><br/>";
            if(isset($_SESSION['Sala'.$i]))
                echo "<input class=\"form-control\" type='number' name='Sala".$i."' value='".$_SESSION['Sala'.$i]."' size='50' min='1' max='10' step='1'>";
            else
                echo "<input class=\"form-control\" type='number' name='Sala".$i."' size='50' min='1' max='10' step='1'>";
            
        //value="8" 
       }

        
        //$result = mysqli_query($db, $sql);
        
        
/*        while ($row = mysqli_fetch_array($result)) {
           echo "<option value='" .$row['Id']."'>". $row['Nome'] . "</option>"; 
        }*/
        session_write_close();
        $util->disconnect_database($aux["conn"]);
	?>
    <br><br>
    <input class="btn btn-primary " type="submit" name="submit" value="Confirmar">
	<input class="btn btn-primary ms-4" type="submit" name="addSubstancia" value="+ Substancia">
    <input class="btn btn-primary" type="submit" name="takeSubstancia" value="- Substancia">
    <input class="btn btn-primary ms-4" type="submit" name="addOdor" value="+ Odor">
    <input class="btn btn-primary" type="submit" name="takeOdor" value="- Odor">
    <br>
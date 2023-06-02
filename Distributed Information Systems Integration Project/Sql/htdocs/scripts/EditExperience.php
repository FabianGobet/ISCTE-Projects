<?php
require('Utils.php');

if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';	


    session_id($user);
	session_start();

    
if (isset($_GET['var']))
$_SESSION['idExp'] = $_GET['var'];

    $util= Utils::getInstance();
    $aux = $util->connect_database($user, $_SESSION['pass']);

	if (isset($_SESSION['check_experience'])){
        if($_SESSION['check_experience'] == 1){
            $dateSql = str_replace("T", " ", $_SESSION['date']);
            unset($_SESSION['check_experience']);
            $sqlEditExperience = 'CALL mudarExperiencia('.$_SESSION['idExp'].', \''.$_SESSION['description'].'\', \''
            .$dateSql.'\', '.$_SESSION['mousenumber'].', '.$_SESSION['limit'].', '.$_SESSION['nomovement'].', '
            .$_SESSION['tempVariation'].', '.$_SESSION['idealTemp'].')';
            $util->runSQL($sqlEditExperience,$aux["conn"]);
            unset($_SESSION['idExp']);
            header('Location: GetExperiences.php?user='.$user);
            die();

        }else if ($_SESSION['check_experience'] == 0){
            unset($_SESSION['check_experience']);
            echo '<script>alert("Bad fields");</script>';

        }else if ($_SESSION['check_experience'] == 2){
            unset($_SESSION['check_experience']);
            echo '<script>alert("Fill all required fields");</script>';
        }
    }

	session_write_close();


$action = "verifyExperience.php?user=".$user;
$action2 = "GetExperiences.php?user=".$user;

$sqlExperienceFields="SELECT * FROM experiencias WHERE Id=".$_SESSION['idExp'];
$result_set = $util->runSQL($sqlExperienceFields, $aux["conn"]);
$rowExperienceFields = $result_set->fetch_assoc();
$dateAux = str_replace(" ", "T", $rowExperienceFields["DataHoraInicio"]);


?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>EditExperience</title>
<link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
      crossorigin="anonymous"
    />
</head>
<body>
<a href=" ../views/Login.html" style="float:right" class="btn btn-secondary mx-3 ">Logout</a>
<p class="text-center mt-3 fs-3 fw-bolder">Editar Experiência</p>
<div class="row justify-content-between">
  <div class="col">
    <a href=<?php echo $action2; ?> class="btn btn-primary mx-3">Início</a>
  </div>
  <div class="col align-self-end">
    <?php printf("<form style=\"float:right\" action=\"verifyExperience.php?var=".$_SESSION['idExp']."&user=$user\" method=post><input class=\"btn btn-primary mx-3\" type=hidden name=EditLab value=".$_SESSION['idExp']."><input class=\"btn btn-primary mx-3\" type=submit name=EditLab value= \"Alterar Odores e Substância\"></form>");?>
  </div>
</div>


<form method="post" class="mx-3"  action=<?php echo $action; ?>>
	<label class="form-label mt-1" for="description">Descrição:</label>
    <input class="form-control" type="textfield" name="description" size="50" maxlength="255" value=<?php echo $rowExperienceFields["Descricao"]?> required>

	<label class="form-label mt-3" for="date">DataHoraInício:</label><br/>
    <input class="form-control" type="datetime-local" name="date" size="50" maxlength="255" value=<?php echo $dateAux?>>

    <label class="form-label mt-3" for="mousenumber">Número de Ratos:</label><br/>
    <input class="form-control" type="number" name="mousenumber" size="11" min="0" step="1" value=<?php echo $rowExperienceFields["NumeroRatos"]?> required>

    <label class="form-label mt-3" for="nomovement">Segundos sem Movimento:</label><br/>
    <input class="form-control" type="number" name="nomovement" size="11" min="0" step="1" value=<?php echo $rowExperienceFields["SegundosSemMovimento"]?> required>

	<label class="form-label mt-3" for="tempVariation">Variaçao Temperatura Máxima:</label><br/>
    <input class="form-control" type="number" name="tempVariation" size="8" min="0" step="0.01" value=<?php echo $rowExperienceFields["VariacaoTemperaturaMaxima"]?> required>

	<label class="form-label mt-3" for="idealTemp">Temperatura Ideal:</label><br/>
    <input class="form-control" type="number" name="idealTemp" size="6" maxlength="6" step="0.01" value=<?php echo $rowExperienceFields["TemperaturaIdeal"]?> required>

	<label class="form-label mt-3" for="limit">Limite ratos Sala:</label><br/>
    <input class="form-control" type="number" name="limit" size="6" min="0" step="1" value=<?php echo $rowExperienceFields["LimiteRatosSala"]?> required>

	    <input class="btn btn-primary mt-3" type="submit" name="Edit" value="Submit">
		<input class="btn btn-primary mx-3 mt-3" type="reset" name="Reset" value="Reset">
</p>
</form>

</body>
</html>
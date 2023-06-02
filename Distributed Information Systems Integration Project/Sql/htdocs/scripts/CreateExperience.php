<?php

if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';	
if(!empty($_GET['pass'])) $pass = $_GET['pass'];
else $pass = '';

    session_id($user);
	session_start();
	if (isset($_SESSION['check_experience'])){
        if($_SESSION['check_experience'] == 1){
            unset($_SESSION['check_experience']);
            header('Location: ConfigureLab.php?user='.$user);

        }else if ($_SESSION['check_experience'] == 0){
            unset($_SESSION['check_experience']);
            echo '<script>alert("Bad fields");</script>';
        }else if ($_SESSION['check_experience'] == 2){
            unset($_SESSION['check_experience']);
            echo '<script>alert("Fill all required fields");</script>';
        }
    }

	session_write_close();


//$util= Utils::getInstance();
//$result = $util->connect_database($user, $pass);
$action = "verifyExperience.php?user=".$user;
$action2 = "GetExperiences.php?user=".$user;


/*        $db = mysqli_connect('localhost', 'root', '', 'sistemabiblioteca');
        $sql = "Select Nome, Id from area_tematica";
        $result = mysqli_query($db, $sql);

        echo "<select name='areatematica'>";
        echo "<option value=\"0\" selected>Escolha uma opção</option>";
        while ($row = mysqli_fetch_array($result)) {
           echo "<option value='" .$row['Id']."'>". $row['Nome'] . "</option>"; 
        }
        echo "</select>";
        */

        echo "<a href=\" ../views/Login.html\" style=\"float:right\" class=\"btn btn-secondary mx-3  \">Logout</a>";
?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>Create Experience</title>
<link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
      crossorigin="anonymous"
    />
</head>
<body>
<p class="text-center mt-3 fs-3 fw-bolder">Criar Experiência</p>

<a href=<?php echo $action2; ?> class="btn btn-primary mx-3">Início</a>

<form method="post" class="mx-3" action=<?php echo $action; ?>>
	<label class="form-label mt-3" for="description">Descrição:</label>
    <input class="form-control " type="textfield" name="description" size="50" maxlength="255" required>

	<label class="form-label mt-3" for="date">DataHoraInício:</label>
    <input class="form-control" type="datetime-local" name="date" size="50" maxlength="255">

    <label class="form-label mt-3" for="mousenumber">Número de Ratos:</label>
    <input class="form-control " type="number" name="mousenumber" size="11" min="0" step="1" required>

    <label class="form-label mt-3" for="nomovement">Segundos sem Movimento:</label>
    <input class="form-control " type="number" name="nomovement" size="11" min="0" step="1" required>

	<label class="form-label mt-3" for="tempVariation">Variaçao Temperatura Máxima:</label>
    <input class="form-control " type="number" name="tempVariation" size="8" min="0" step="0.01" required>

	<label class="form-label mt-3" for="idealTemp">Temperatura Ideal:</label>
    <input class="form-control " type="number" name="idealTemp" size="6" maxlength="6" step="0.01" required>

	<label class="form-label mt-3" for="limit">Limite ratos Sala:</label>
    <input class="form-control " type="number" name="limit" size="6" min="0" step="1" required>
    <br>
	
	    <input class="btn btn-primary" type="submit" name="Submit" value="Configuração Lab">
		<input class="btn btn-primary" type="reset" name="Submit2" value="Limpar">
</p>
</form>
<script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN"
      crossorigin="anonymous">
    </script>

</body>
</html>
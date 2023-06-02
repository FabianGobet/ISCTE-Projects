<html>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<head><title>Create Experience</title>
</head>

<body>
<?php
require('Utils.php');


if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';

session_id($user);
session_start();
$_SESSION['check_experience'] = 1;


//print_r($_POST);
//if(!is_int($_POST["limit"]))

//if(!is_int($_POST["nomovement"]))

//if(!is_int($_POST["mousenumber"]))

//$_POST["idealTemp"];

if(empty($_POST['description']) || empty($_POST['mousenumber']) || empty($_POST['nomovement'])
|| empty($_POST['tempVariation'])|| empty($_POST['idealTemp'])|| empty($_POST['limit'])){
    $_SESSION['check_experience'] = 2;
}


$_SESSION['description']=$_POST['description'];
if(empty($_POST['date'])) $_SESSION['date']="''";
else
$_SESSION['date']=$_POST['date'];
$_SESSION['mousenumber']=$_POST['mousenumber'];
$_SESSION['nomovement']=$_POST['nomovement'];
$_SESSION['tempVariation']=$_POST['tempVariation'];
$_SESSION['idealTemp']=$_POST['idealTemp'];
$_SESSION['limit']=$_POST['limit'];


if(isset($_SESSION['idExp']) && isset($_POST['EditLab'])){
    unset($_SESSION['check_experience']);
    session_write_close();
    header('Location: ConfigureLab.php?user='.$_GET['user']);
}
else session_write_close();

if(isset($_POST['Submit']))
    header('Location: CreateExperience.php?user='.$_GET['user']);
else if(isset($_POST['Edit']))
    header('Location: EditExperience.php?user='.$_GET['user']);

?>
</body>
</html>
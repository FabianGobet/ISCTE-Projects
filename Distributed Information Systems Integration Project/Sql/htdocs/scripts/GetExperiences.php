<!DOCTYPE html>
<html>
<head>
  <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
      crossorigin="anonymous"
    />
  </head>
<body>


<?php
require('Utils.php');

if(!empty($_GET['user'])) $user = $_GET['user'];
else $user = '';	
session_id($user);
session_start();
$pass = $_SESSION['pass'];
session_unset() ;
$_SESSION['pass']=$pass;
/*unset($_SESSION['idExp']);
unset($_SESSION['NSubstancias']);
unset($_SESSION['NOdores']);*/

$util= Utils::getInstance();
$aux = $util->connect_database($user, $_SESSION['pass']);

echo "<a href=\" ../views/Login.html\" style=\"float:right\" class=\"btn btn-secondary mx-3  \">Logout</a>";
?>

<p class="text-center mt-3 fs-3 fw-bolder">Experiências de <?php echo $user?></p>

<?php

date_default_timezone_set('Europe/Lisbon');

if(!$aux["success"])
    echo '<script>alert("Unable to Login"); window.location.href="../views/Login.html";</script>';


    function writeLine($coluna1, $coluna2, $coluna3, $coluna4,$user) {
      printf("<td>$coluna1</td><td><a href='DetailExperience.php?var=$coluna1&user=$user'>$coluna2</a></td><td>$coluna3</td><td>$coluna4</td><form action=\"DetailExperience.php?var=$coluna1&user=$user\" method=post><td><input type=hidden name=id value=$coluna1><input class=\"btn btn-primary\" type=submit  value=Detalhe></td></form>");
      $dataatual = date('Y-m-d'); // 2016-12-24
      $horaatual = date('H:i:s');
      $array = explode(" ",$coluna3);
      $array = array_values($array);
      $datainicio=$array[0];
      $horainicio=$array[1];
      $datainicio=str_replace("-","",$datainicio);
      $dataatual=str_replace("-","",$dataatual);
      $horaatual=str_replace(":","",$horaatual);
      $horainicio=str_replace(":","",$horainicio);
      if($datainicio > $dataatual ||($datainicio == $dataatual && $horainicio>$horaatual)){
        printf("<form action=\"EditExperience.php?var=$coluna1&user=$user\" method=post><td><input type=hidden name=id value=$coluna1><input class=\"btn btn-primary\" type=submit value=Alterar></td></form>");
      }else
        printf("<td></td>");
      printf("\n");
      //echo $dataatual ." - ". $horaatual. " : ". $datainicio. " - ". $horainicio;
    }


    echo"<a class=\"btn btn-primary mx-3 mt-3\" href='CreateExperience.php?user=".$user."'>Começar Experiência</a>";
    echo"<form class=\"mx-3\" action=\"GetExperiences.php?user=".$user."\" style=\"float:right\" method=post><input class=\"form-control \" name=\"filter\" type=\"text\"></form>";
    //echo"<a class=\"btn btn-primary mx-3 mt-3\"style=\"float:right\" href='GetExperiences.php?user=".$user."'>Começar Experiência</a>";

echo "<br><br>";
echo "<table class=\"table table-hover table-striped\" id='tablebig'  border=1 cellpadding=5 cellspacing=2 bgcolor='#FFFFFF'>\n";

if(!isset($_POST["filter"]) || empty($_POST["filter"])){
  $linesAux = $util->runSQL("SELECT COUNT(*)  FROM experiencias", $aux["conn"]);
  $lines = $linesAux->fetch_assoc()["COUNT(*)"];
  $result_set = $util->runSQL("SELECT Id, Descricao, DataHoraInicio, DataHoraFim  FROM experiencias", $aux["conn"]);
}
else if(isset($_POST["filter"]) && !empty($_POST["filter"])){
  $f=$_POST["filter"];
  $linesAux = $util->runSQL("SELECT COUNT(*)  FROM experiencias WHERE Id LIKE '%$f%' OR Descricao LIKE '%$f%' OR DataHoraInicio LIKE '%$f%'
  OR DataHoraFim LIKE '%$f%' OR NumeroRatos LIKE '%$f%' OR LimiteRatosSala LIKE '%$f%' OR SegundosSemMovimento LIKE '%$f%'
   OR VariacaoTemperaturaMaxima LIKE '%$f%' OR TemperaturaIdeal LIKE '%$f%'", $aux["conn"]);
  $lines = $linesAux->fetch_assoc()["COUNT(*)"];
  $result_set = $util->runSQL("SELECT Id, Descricao, DataHoraInicio, DataHoraFim  FROM experiencias WHERE Id LIKE '%$f%' OR Descricao LIKE '%$f%' 
  OR DataHoraInicio LIKE '%$f%' OR DataHoraFim LIKE '%$f%' OR NumeroRatos LIKE '%$f%' OR LimiteRatosSala LIKE '%$f%' OR SegundosSemMovimento LIKE '%$f%'
   OR VariacaoTemperaturaMaxima LIKE '%$f%' OR TemperaturaIdeal LIKE '%$f%'", $aux["conn"]);
}
  
  printf("<tr>\n<th><b>Id</th><th><b>Descrição</th><th><b>DataHoraInicio</th><th><b>DataHoraFim</b></th><th></th><th></th></tr>\n");
  for($registo=0; $registo<$lines; $registo++) {
    echo "<tr>\n";
    $row = $result_set->fetch_assoc();
    /*$this->getArea(1);

    if($this->getArea($row["Id"]) != NULL){
      $area=$this->getArea($row["Id"]);
      $this->escrevePublicacao($row["Id"], $row["Nome1"], $area, $row["Data_de_publicacao"], $row["Qtd_Emprestimos"]);
    }
    else*/  //checks for null and go get name of userr by its id
    writeLine($row["Id"], $row["Descricao"], $row["DataHoraInicio"], $row["DataHoraFim"], $user);
    echo "</tr>\n";    
  }

?>
<script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-w76AqPfDkMBDXo30jS1Sgez6pr3x5MlQ1ZAGC+nuZB+EYdgRZgiwxhTBTkF7CXvN"
      crossorigin="anonymous"
    ></script>
</body>		
</html>

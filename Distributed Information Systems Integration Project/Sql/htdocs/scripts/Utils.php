<?php
class Utils {


    /**Variável da classe que permite guardar a ligação à base de dados.*/
  //var $conn;
  var $url="46.189.143.63";
  var $database="micelab";
  //var $username;
  //var $password;

  private static $instance;

  public static function getInstance()
  {
      if(self::$instance === null){
          self::$instance = new self;
      }
      return self::$instance;
  }

  function Utils() {
    //$this->conn = new Utils;
	//$this->conn->connect_database($url, $database, $username, $password); 
 }

 /*function login_utils($username, $password){
    $this->username = $username;
    $this->password = $password;
 }*/


  /**Função para ligar à BD da Loja
   @return Um valor indicando qual o resultado da ligação à base de dados.*/
   function connect_database($username, $password) {
    $result["success"]=false;
    $result["message"]="";
    $result["conn"]=false;
    try{
      $result["conn"] = mysqli_connect($this->url, $username, $password, $this->database);
      if(!$result["conn"]){
        $result["message"]="Credenciais erradas";
        return $result;
      //header('Location: http://localhost/PISID/ui_GetClient.html');
          //die("Connection failed");
      }
      $result["success"] = true;
      $result["message"]="Login efetuado com sucesso";
      return $result;
    }catch(mysqli_sql_exception $e){
      $result["message"]= $e->getMessage();
      return $result;
    }
      
	}
 
 /**Executa um determinado comando SQL, retornando o seu resultado.  
 @param sql_command Comando SQL a ser executado pela função
 @return O resultado do comando SQL.*/
  function runSQL($sql_command, $conn) {
    try {   
      $resultado = mysqli_query( $conn, $sql_command);
      if(!$resultado){
        echo "Erro na Query" . mysqli_error($conn);
        echo $sql_command;
      }
      //mysqli_free_result($resultado); 
      mysqli_next_result($conn);
  } catch (Exception $e) {
    echo '<script>alert("'.$e->getMessage().'"); window.location.href="GetExperiences.php?user='.$_GET["user"].'";</script> \n';
}
    
    return $resultado;
 }
 
 
 /**Fecha a ligação à base de dados*/
 function disconnect_database($conn) {
    mysqli_close($conn);
 }

 /*public function getUsername(){
    return $this->username;
 }*/
}
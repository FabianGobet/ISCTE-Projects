-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 29, 2023 at 03:18 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `micelab`
--
CREATE DATABASE IF NOT EXISTS `micelab` DEFAULT CHARACTER SET latin1 COLLATE latin1_bin;
USE `micelab`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `adicionarOdorExperiencia` (IN `idExp` INT, IN `idSala` INT, IN `idOdo` INT)   BEGIN

DECLARE username VARCHAR(30);
DECLARE idUser INT;

SELECT SUBSTRING_INDEX(USER(),'@',1) INTO username;

SELECT utilizador.Id INTO idUser
	FROM utilizador
	WHERE utilizador.Username = username;


IF EXISTS(SELECT *
			FROM experiencia
			WHERE experiencia.Investigador = idUser AND experiencia.Id = idExp) THEN

INSERT INTO odorexperiencia(Sala, IdExperiencia, IdOdor) 
VALUES (idSala, idExp, idOdo);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `adicionarSubstanciaExperiencia` (IN `idExp` INT, IN `idSub` INT, IN `NumRatos` INT)   BEGIN

DECLARE username VARCHAR(30);
DECLARE idUser INT;

SELECT SUBSTRING_INDEX(USER(),'@',1) INTO username;

SELECT utilizador.Id INTO idUser
	FROM utilizador
	WHERE utilizador.Username = username;


IF EXISTS(SELECT *
			FROM experiencia
			WHERE experiencia.Investigador = idUser AND experiencia.Id = idExp) THEN

INSERT INTO substanciaexperiencia (IdSubstancia, IdExperiencia, NumeroRatos) 
VALUES (idSub, idExp, NumRatos);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `alterarParametrosAdicionais` (IN `Agrupador` VARCHAR(30), IN `Identificador` VARCHAR(30), IN `Valor` VARCHAR(30))   BEGIN
DECLARE val INT;

SET val = CAST(Valor AS UNSIGNED INTEGER);

IF(EXISTS(SELECT * FROM parametrosadicionais p WHERE p.Agrupador=Agrupador AND p.Identificador=Identificador) AND isNumeric(Valor)=1) THEN

	 IF(
        ((Agrupador='FATOR_ALERTA_TEMPERATURA' OR Agrupador='TAMANHO_OUTLIER_SAMPLE') AND val>0 AND val<=1) OR
         ((Agrupador='NUM_MAX_ALERTA' OR Agrupador='NUM_MIN_ERROS') AND val>=0) OR
         ((Agrupador='NUM_MAX_SENSORES' OR Agrupador='PARAMETRO_PERIODICIDADE' OR Agrupador LIKE 'TEMPO_%') AND val>0)
         ) THEN 
         
            UPDATE parametrosadicionais p SET p.Valor=Valor WHERE p.Agrupador=Agrupador AND p.Identificador=Identificador;

            IF (Agrupador='TEMPO_ENTRE_CHECK_MOVIMENTO' AND Identificador='TEMPO') THEN
                ALTER EVENT checkMovimento ON SCHEDULE EVERY Valor SECOND;
            ELSEIF(Agrupador='TEMPO_CHECK_FINS' AND Identificador='TEMPO') THEN
                ALTER EVENT finalizarExperienciaAuto ON SCHEDULE EVERY Valor SECOND;
            END IF;
   END IF;
    
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `consultarInformaçãoPessoal` ()   SELECT u.Nome, u.Username, u.Email, u.Telefone, u.Tipo
FROM utilizador u
where u.Username=(SELECT SUBSTRING_INDEX(USER(),'@',1))$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `criarUtilizador` (IN `Username` VARCHAR(30), IN `TPassword` LONGTEXT, IN `Nome` VARCHAR(100), IN `Telefone` VARCHAR(20), IN `Tipo` ENUM('AppAdmin','Investigador','Java','Tecnico'), IN `Email` VARCHAR(50))   BEGIN
SET @query1 = CONCAT('CREATE USER "',Username,'"@"%" IDENTIFIED BY "',TPassword,'"');
SET @query2 = CONCAT('GRANT "',Tipo,'" TO "', Username,'"@"%"');
SET @query3 = CONCAT('SET DEFAULT ROLE "', Tipo ,'" FOR "', Username,'"@"%"');


IF !(Username  IS  NULL AND  Username = '') AND !EXISTS(SELECT * FROM mysql.user WHERE user.User=Username) AND
	!(TPassword IS  NULL AND  TPassword = '' )AND
    !(Nome IS  NULL AND  Nome = '' )AND
    !(Telefone IS  NULL AND  Telefone = '')AND
    !(Tipo IS  NULL AND  Tipo = '' )AND EXISTS(SELECT * FROM tipoutilizador WHERE tipoutilizador.TipoUtilizador = Tipo) AND
    !(Email IS  NULL AND  Email = '')  THEN
    
    PREPARE stmt FROM @query1; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    PREPARE stmt1 FROM @query2; EXECUTE stmt1; DEALLOCATE PREPARE stmt1;
    PREPARE stmt2 FROM @query3; EXECUTE stmt2; DEALLOCATE PREPARE stmt2; 
    INSERT INTO `utilizador` ( Nome, Telefone, Tipo, Email, Ativo, Username) VALUES (Nome, Telefone, Tipo, Email, '1', Username);
    
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteLogicoExperiencia` (IN `idExperiencia` INT)   BEGIN
UPDATE `experiencia` SET `Anulada` = '1' WHERE `experiencia`.`Id` = idExperiencia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `experienciaPopulada` (IN `idExperiencia` INT)   UPDATE experiencia SET experiencia.Populada=1 WHERE experiencia.Id=idExperiencia$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `finalizarExperiencia` (IN `IdExperiencia` INT(11))   BEGIN

    update experiencia set DataHoraFim = current_timestamp where Id = IdExperiencia;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciarExperiencia` (IN `Descricao` TEXT, IN `DataHoraInicio` DATETIME, IN `NumeroRatos` INT, IN `SegundosSemMovimento` INT, IN `VariacaoTemperaturaMaxima` DECIMAL(4,2), IN `TemperaturaIdeal` DECIMAL(4,2), IN `LimiteRatosSala` INT)   BEGIN

DECLARE idUtilizador INT;
DECLARE idExp INT;


SELECT u.id INTO idUtilizador
FROM utilizador u
WHERE u.Username=SUBSTRING_INDEX(USER(),'@',1);

INSERT INTO `experiencia` (`Id`, `Descricao`, `Investigador`, `DataHoraInicio`, `NumeroRatos`, `LimiteRatosSala`, `SegundosSemMovimento`, `VariacaoTemperaturaMaxima`, `TemperaturaIdeal`, `DataHoraFim`, `Populada`, `Anulada`) VALUES (NULL, Descricao, idUtilizador, nvl(DataHoraInicio, CURRENT_TIMESTAMP), NumeroRatos, LimiteRatosSala, SegundosSemMovimento, VariacaoTemperaturaMaxima, TemperaturaIdeal, NULL, '0', '0');



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `introduzirAlerta` (IN `IdTipoAlerta` INT(11), IN `IdExperiencia` INT(11), IN `Descricao` VARCHAR(150))   BEGIN

IF(podeInserirAlerta(IdTipoAlerta)) THEN
     INSERT INTO alerta (IdExperiencia, IdTipoAlerta, Descricao) VALUES (IdExperiencia, IdTipoAlerta, Descricao);
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `introduzirErroExperiencia` (IN `IdExperiencia` INT, IN `DataHora` DATETIME, IN `Valor` VARCHAR(250))   BEGIN

IF(EXISTS(SELECT * FROM experiencia WHERE experiencia.Id=IdExperiencia)) THEN
	INSERT INTO erroexperiencia(IdExperiencia,DataHora,Valor) VALUES(IdExperiencia,DataHora,Valor);
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `introduzirPassagem` (IN `idExp` INT, IN `salaDeSaida` INT(11), IN `salaDeEntrada` INT(11), IN `horaPassagem` DATETIME)   BEGIN

DECLARE valor VARCHAR(150);
DECLARE corredor INT;

SELECT COUNT(*) INTO corredor
       FROM corredor
       WHERE corredor.SalaEntrada = salaDeEntrada AND corredor.SalaSaida = salaDeSaida ;

IF(corredor > 0)  THEN

  INSERT INTO medicaopassagem (idExperiencia, DataHora, SalaSaida, SalaEntrada)
  VALUES (iDExp, horaPassagem, salaDeSaida, salaDeEntrada);

ELSE

SET valor = CONCAT('Corredor nao existe na experiencia: ', idExp ,'; entrada: ', salaDeEntrada, '; saida: ',salaDeSaida);

CALL introduzirErroExperiencia(idExp,horaPassagem,valor);

END IF;   

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarExperiencia` (IN `idExperiencia` INT, IN `Descricao` TEXT, IN `LimiteRatosSala` INT, IN `SegundosSemMovimento` INT)   BEGIN

IF(!(Descricao IS NULL OR Descricao='')) THEN
	UPDATE experiencia e SET e.Descricao=Descricao WHERE e.Id=idExperiencia;
END IF;

IF(!(LimiteRatosSala IS NULL OR LimiteRatosSala=0)) THEN
	UPDATE experiencia e SET e.LimiteRatosSala=LimiteRatosSala WHERE e.Id=idExperiencia;
END IF;

IF(!(SegundosSemMovimento IS NULL OR SegundosSemMovimento=0)) THEN
	UPDATE experiencia e SET e.SegundosSemMovimento=SegundosSemMovimento WHERE e.Id=idExperiencia;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarOutraExperiencia` (IN `idExperiencia` INT, IN `Investigador` INT, IN `Finalizada` TINYINT(1), IN `Anulada` TINYINT(1), IN `Populada` TINYINT(1))   BEGIN

IF(!(Investigador IS NULL OR Investigador = 0)) THEN
	UPDATE experiencia SET experiencia.Investigador=Investigador WHERE experiencia.Id=idExperiencia;
END IF;

IF(!(Finalizada IS NULL OR Finalizada = 0)) THEN
	UPDATE experiencia SET experiencia.DataHoraFim=CURRENT_TIMESTAMP WHERE experiencia.Id=idExperiencia;
END IF;

IF(!(Anulada IS NULL OR Anulada = 0)) THEN
	UPDATE experiencia SET experiencia.Anulada=1 WHERE experiencia.Id=idExperiencia;
END IF;

IF(!(Populada IS NULL OR Populada = 1)) THEN
	UPDATE experiencia SET experiencia.Populada=Populada WHERE experiencia.Id=idExperiencia;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarOutroUser` (IN `idUtilizador` INT, IN `Ativo` TINYINT(1), IN `Username` VARCHAR(30), IN `Tipo` VARCHAR(100))   BEGIN

DECLARE tempUsername VARCHAR(30);
DECLARE tempTipo VARCHAR(100);

SELECT u.Username, u.Tipo INTO tempUsername, tempTipo 
FROM utilizador u 
WHERE utilizador.Id=idUtilizador;

IF(Ativo IS NOT NULL) THEN
	UPDATE utilizador SET utilizador.Ativo=Ativo WHERE utilizador.Id=idUtilizador;
    IF(Ativo=0) THEN
    	ALTER USER tempUsername ACCOUNT LOCK;
    ELSE 
    	ALTER USER tempUsername ACCOUNT UNLOCK;
    END IF;
END IF;

IF EXISTS(SELECT * FROM tipoutilizador WHERE tipoutilizador.TipoUtilizador = Tipo) THEN
	UPDATE utilizador SET utilizador.Tipo=Tipo WHERE utilizador.Id=idUtilizador;
    REVOKE tempTipo FROM tempUsername;
    GRANT Tipo TO tempUsername;
END IF;

IF( !(Username IS NULL OR Username='') AND !(EXISTS(SELECT * FROM mysql.user WHERE user.User=Username)) ) THEN
	UPDATE utilizador SET utilizador.Username=Username WHERE utilizador.Id=idUtilizador;
    RENAME USER tempUsername TO Username;
END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarProprioUser` (IN `Nome` VARCHAR(100), IN `Telefone` VARCHAR(20), IN `Email` VARCHAR(50))   BEGIN
DECLARE username VARCHAR(30);
SELECT SUBSTRING_INDEX(USER(),'@',1) INTO username;

IF(!(Nome IS NULL OR Nome='')) THEN
	UPDATE utilizador SET utilizador.Nome=Nome WHERE utilizador.Username=username;
END IF;

IF(!(Telefone IS NULL OR Telefone='')) THEN
	UPDATE utilizador SET utilizador.Telefone=Telefone WHERE utilizador.Username=username;
END IF;

IF(!(Email IS NULL OR Email='')) THEN
	UPDATE utilizador SET utilizador.Email=Email WHERE utilizador.Username=username;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `resetDadosExperiencia` (IN `idExperiencia` INT, IN `confirmacao` VARCHAR(50))   BEGIN
DECLARE resultado VARCHAR(50);

IF(NOT(EXISTS(SELECT * FROM experiencia WHERE experiencia.Id = idExperiencia))) THEN
SET resultado = 'Experiencia não existe';

ELSEIF(EXISTS(SELECT * FROM experiencia WHERE experiencia.Id = idExperiencia AND experiencia.Populada = 0 AND experiencia.DataHoraFim IS NULL)) THEN
SET resultado = 'Experiencia ainda não populada/terminada.';

ELSEIF(confirmacao = 'Apagar e repor os dados') THEN
UPDATE experiencia SET experiencia.Populada=0 WHERE experiencia.Id=idExperiencia;
DELETE FROM alerta WHERE alerta.IdExperiencia = idExperiencia;
DELETE FROM medicaopassagem WHERE medicaopassagem.IdExperiencia = idExperiencia;
DELETE FROM medicaotemperatura WHERE medicaotemperatura.IdExperiencia = idExperiencia;
DELETE FROM medicaosala WHERE medicaosala.IdExperiencia = idExperiencia;
INSERT INTO medicaosala (IdExperiencia,Sala,NumeroRatos) (SELECT experiencia.Id,1,experiencia.NumeroRatos FROM experiencia WHERE experiencia.Id=idExperiencia);
SET resultado = 'Operação concluida com sucesso';

ELSE
SET resultado = 'Frase de confirmação errada';
END IF;

SELECT resultado;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `checkUsernameExiste` (`username` VARCHAR(30)) RETURNS TINYINT(1)  BEGIN

RETURN EXISTS( SELECT *
             	FROM utilizador
             	WHERE utilizador.Username = username);

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `IsNumeric` (`sIn` VARCHAR(1024)) RETURNS TINYINT(4)  RETURN sIn REGEXP '^(-|\\+){0,1}([0-9]+\\.[0-9]*|[0-9]*\\.[0-9]+|[0-9]+)$'$$

CREATE DEFINER=`root`@`localhost` FUNCTION `podeInserirAlerta` (`IdTipoAlerta` INT(11)) RETURNS TINYINT(1) UNSIGNED ZEROFILL  BEGIN 

RETURN ((SELECT COUNT(*)
FROM ALERTA 
WHERE IdTipoAlerta = IdTipoAlerta AND TIMESTAMPDIFF(SECOND, DataHora, current_timestamp) <= (SELECT CAST(VALOR AS INT)
FROM PARAMETROSADICIONAIS 
WHERE Agrupador = 'NUM_MAX_ALERTA' AND Identificador = 'TEMPO')) < (SELECT CAST(VALOR AS INT)
FROM PARAMETROSADICIONAIS 
WHERE Agrupador = 'NUM_MAX_ALERTA' AND Identificador = IdTipoAlerta));

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `alerta`
--

CREATE TABLE `alerta` (
  `Id` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `IdTipoAlerta` int(11) NOT NULL,
  `DataHora` datetime NOT NULL DEFAULT current_timestamp(),
  `Descricao` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Stand-in structure for view `alertas`
-- (See below for the actual view)
--
CREATE TABLE `alertas` (
`Id` int(11)
,`IdExperiencia` int(11)
,`DataHora` datetime
,`title` text
,`Valor` varchar(50)
,`Descricao` varchar(150)
);

-- --------------------------------------------------------

--
-- Table structure for table `configuracaolabirinto`
--

CREATE TABLE `configuracaolabirinto` (
  `TemperaturaProgramada` decimal(4,2) NOT NULL,
  `SegundosAberturaPortasExterior` int(11) NOT NULL,
  `NumeroSalas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Dumping data for table `configuracaolabirinto`
--

INSERT INTO `configuracaolabirinto` (`TemperaturaProgramada`, `SegundosAberturaPortasExterior`, `NumeroSalas`) VALUES
(15.00, 30, 10);

-- --------------------------------------------------------

--
-- Table structure for table `corredor`
--

CREATE TABLE `corredor` (
  `SalaSaida` int(11) NOT NULL,
  `SalaEntrada` int(11) NOT NULL,
  `Cumprimento` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Dumping data for table `corredor`
--

INSERT INTO `corredor` (`SalaSaida`, `SalaEntrada`, `Cumprimento`) VALUES
(1, 1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `erroexperiencia`
--

CREATE TABLE `erroexperiencia` (
  `IdExperiencia` int(11) NOT NULL,
  `Id` int(11) NOT NULL,
  `DataHora` datetime NOT NULL,
  `Valor` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `erroexperiencia`
--
DELIMITER $$
CREATE TRIGGER `introduzirAlertaErro` AFTER INSERT ON `erroexperiencia` FOR EACH ROW BEGIN
IF((SELECT count(*) from erroexperiencia where IdExperiencia = new.IdExperiencia) > (SELECT valor from parametrosadicionais where agrupador = 'NUM_MIN_ERROS' and identificador = 'NUM_ERROS')) THEN
CALL introduzirAlerta(6, new.IdExperiencia, 'Dados provenientes dos sensores com erro');
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `experiencia`
--

CREATE TABLE `experiencia` (
  `Id` int(11) NOT NULL,
  `Descricao` text NOT NULL,
  `Investigador` int(11) NOT NULL,
  `DataHoraInicio` datetime NOT NULL DEFAULT current_timestamp(),
  `NumeroRatos` int(11) NOT NULL,
  `LimiteRatosSala` int(11) NOT NULL,
  `SegundosSemMovimento` int(11) NOT NULL,
  `VariacaoTemperaturaMaxima` decimal(4,2) NOT NULL,
  `TemperaturaIdeal` decimal(4,2) NOT NULL,
  `DataHoraFim` datetime DEFAULT NULL,
  `Populada` tinyint(1) NOT NULL DEFAULT 0,
  `Anulada` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `experiencia`
--
DELIMITER $$
CREATE TRIGGER `criarExperienciaLimiteAfter` AFTER INSERT ON `experiencia` FOR EACH ROW BEGIN

INSERT INTO medicaosala (medicaosala.IdExperiencia, medicaosala.Sala, medicaosala.NumeroRatos)
VALUES (new.Id, 1, new.NumeroRatos);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `criarExperienciaLimiteBefore` BEFORE INSERT ON `experiencia` FOR EACH ROW BEGIN

DECLARE lastDate DATETIME;
DECLARE minTemp INT;

SELECT experiencia.DataHoraFim INTO lastDate
FROM experiencia
WHERE experiencia.Anulada = 0 AND experiencia.DataHoraFim >= ALL(SELECT DataHoraFim FROM experiencia WHERE DataHoraFim IS NOT NULL);

SELECT CAST(parametrosadicionais.Valor AS INTEGER ) INTO minTemp
FROM parametrosadicionais
WHERE parametrosadicionais.Agrupador = 'TEMPO_ENTRE_EXPERIENCIA' AND parametrosadicionais.Identificador = 'TEMPO';

IF EXISTS( SELECT *
			FROM experiencia
            WHERE Anulada = 0 AND DataHoraFim IS NULL )THEN
            	SIGNAL SQLSTATE '45000' 
				SET MESSAGE_TEXT = "Nao foi possivel completar a operacao, existe uma experiencia a decorrer";
END IF;

IF ABS (TIMESTAMPDIFF(MINUTE, lastDate, new.DataHoraInicio) ) < minTemp THEN
	SIGNAL SQLSTATE '45000' 
	SET MESSAGE_TEXT = "Nao foi possivel completar a operacao, por favor aguarde o tempo minimo entre experiencias";
END IF;

IF new.DataHoraInicio < CURRENT_TIMESTAMP THEN
	SIGNAL SQLSTATE '45000' 
	SET MESSAGE_TEXT = "Nao foi possivel completar a operacao, nao é possivel comecar uma experiencia no passado";
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tipoUtilizadorExperienciaInsert` BEFORE INSERT ON `experiencia` FOR EACH ROW BEGIN

	if(SELECT 1 from utilizador where id = new.Investigador and tipo <> 'Investigador') then 
    SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'Erro ao tentar associar um utilizador não investigador à experiência';
    end IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tipoUtilizadorExperienciaUpdate` BEFORE UPDATE ON `experiencia` FOR EACH ROW BEGIN

if(SELECT 1 from utilizador where id = new.Investigador and tipo <> 'Investigador') then 
    SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'Erro ao tentar associar um utilizador não investigador à experiência';
    end IF;
    
    END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validarDadosExperiencia` BEFORE INSERT ON `experiencia` FOR EACH ROW BEGIN

SET new.Id = NULL;
SET new.Populada = 0;
SET new.Anulada = 0;

IF(new.NumeroRatos<=0 OR new.LimiteRatosSala<=0 OR new.SegundosSemMovimento <= 0 OR new.VariacaoTemperaturaMaxima <=0 OR new.TemperaturaIdeal <= 0 OR new.DataHoraInicio >= new.DataHoraFim) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Os dados inseridos não são válidos.';
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `experiencias`
-- (See below for the actual view)
--
CREATE TABLE `experiencias` (
`Id` int(11)
,`Descricao` text
,`Investigador` int(11)
,`DataHoraInicio` datetime
,`NumeroRatos` int(11)
,`LimiteRatosSala` int(11)
,`SegundosSemMovimento` int(11)
,`VariacaoTemperaturaMaxima` decimal(4,2)
,`TemperaturaIdeal` decimal(4,2)
,`DataHoraFim` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `javaop`
-- (See below for the actual view)
--
CREATE TABLE `javaop` (
`id_experiencia` int(11)
,`data_hora_inicio` datetime
,`data_hora_fim` datetime
,`temperatura_ideal` decimal(4,2)
,`variacao_temperatura` decimal(4,2)
,`fator_alerta_vermelho` varchar(30)
,`fator_alerta_laranja` varchar(30)
,`fator_alerta_amarelho` varchar(30)
,`num_sensores` varchar(30)
,`fator_periodicidade` varchar(30)
,`tempo_max_periodicidade` varchar(30)
,`fator_tamanho_outlier_sample` varchar(30)
,`temperatura_maxima` varchar(30)
,`temperatura_minima` varchar(30)
,`tempo_entre_experiencia` varchar(30)
,`segundos_abertura_portas_exterior` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `DataHora` datetime NOT NULL DEFAULT current_timestamp(),
  `Tipo` enum('Dado corrompido','Dado Invalido') NOT NULL,
  `Valor` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `medicaopassagem`
--

CREATE TABLE `medicaopassagem` (
  `IdMedicaoPassagem` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `DataHora` datetime NOT NULL,
  `SalaSaida` int(11) NOT NULL,
  `SalaEntrada` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `medicaopassagem`
--
DELIMITER $$
CREATE TRIGGER `atualizarMedicaoSala` AFTER INSERT ON `medicaopassagem` FOR EACH ROW BEGIN

INSERT INTO medicaosala (IdExperiencia, Sala, NumeroRatos) VALUES(new.IdExperiencia, new.SalaEntrada, 1) ON DUPLICATE KEY UPDATE NumeroRatos = NumeroRatos + 1;

INSERT INTO medicaosala (IdExperiencia, Sala, NumeroRatos) VALUES(new.IdExperiencia, new.SalaSaida, -1) ON DUPLICATE KEY UPDATE NumeroRatos = NumeroRatos - 1;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `validarDadosPassagem` BEFORE INSERT ON `medicaopassagem` FOR EACH ROW BEGIN

SET new.IdMedicaoPassagem = NULL;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `medicaosala`
--

CREATE TABLE `medicaosala` (
  `IdExperiencia` int(11) NOT NULL,
  `Sala` int(11) NOT NULL,
  `NumeroRatos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `medicaosala`
--
DELIMITER $$
CREATE TRIGGER `alertaMedicaoSalaInsert` AFTER INSERT ON `medicaosala` FOR EACH ROW BEGIN
DECLARE limite INT;
DECLARE aviso varchar(150);

SELECT e.LimiteRatosSala into limite
FROM experiencia e
WHERE e.Id = new.IdExperiencia;

IF(new.NumeroRatos > limite && new.Sala<>1) THEN
	SET aviso = CONCAT('Experiencia ',new.IdExperiencia,': Numero de ratos na sala ',new.Sala,' excedido.');
    CALL introduzirAlerta(4,new.IdExperiencia,aviso);
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `alertaMedicaoSalaUpdate` AFTER UPDATE ON `medicaosala` FOR EACH ROW BEGIN
DECLARE limite INT;
DECLARE aviso varchar(150);

SELECT e.LimiteRatosSala into limite
FROM experiencia e
WHERE e.Id = new.IdExperiencia;

IF(new.NumeroRatos > limite  && new.Sala<>1) THEN
	SET aviso = CONCAT('Experiencia ',new.IdExperiencia,': Numero de ratos na sala ',new.Sala,' excedido.');
	CALL introduzirAlerta(4,new.IdExperiencia,aviso);
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `medicaotemperatura`
--

CREATE TABLE `medicaotemperatura` (
  `Id` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `DataHora` datetime NOT NULL,
  `Leitura` decimal(4,2) NOT NULL,
  `Sensor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `medicaotemperatura`
--
DELIMITER $$
CREATE TRIGGER `validarDadosMedicaoTemperatura` BEFORE INSERT ON `medicaotemperatura` FOR EACH ROW BEGIN

Set new.Id = NULL;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `odor`
--

CREATE TABLE `odor` (
  `Id` int(11) NOT NULL,
  `Descricao` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `odor`
--
DELIMITER $$
CREATE TRIGGER `validarDadosOdor` BEFORE INSERT ON `odor` FOR EACH ROW BEGIN

SET new.Id = NULL;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `odorexperiencia`
--

CREATE TABLE `odorexperiencia` (
  `Sala` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `IdOdor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `parametrosadicionais`
--

CREATE TABLE `parametrosadicionais` (
  `Agrupador` varchar(30) NOT NULL,
  `Identificador` varchar(30) NOT NULL,
  `Valor` varchar(30) NOT NULL,
  `Descricao` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Dumping data for table `parametrosadicionais`
--

INSERT INTO `parametrosadicionais` (`Agrupador`, `Identificador`, `Valor`, `Descricao`) VALUES
('FATOR_ALERTA_TEMPERATURA', '1', '0.8', 'Fator \'valor\' que determina quando um alerta vermelho é lançado para temperatura T tal que T > tempIdeal+valor*varTemp ou T < tempIdeal-valor*varTemp'),
('FATOR_ALERTA_TEMPERATURA', '2', '0.6', 'Fator \'valor\' que determina quando um alerta laranja é lançado para temperatura T tal que T > tempIdeal+valor*varTemp ou T < tempIdeal-valor*varTemp'),
('FATOR_ALERTA_TEMPERATURA', '3', '0.5', 'Fator \'valor\' que determina quando um alerta amarelo é lançado para temperatura T tal que T > tempIdeal+valor*varTemp ou T < tempIdeal-valor*varTemp'),
('NUM_MAX_ALERTA', '1', '3', 'Número máximo de alertas (3) para o Tipo de Alerta (1)'),
('NUM_MAX_ALERTA', '2', '2', 'Número máximo de alertas (2) para o Tipo de Alerta (2)'),
('NUM_MAX_ALERTA', '3', '1', 'Número máximo de alertas (1) para o Tipo de Alerta (3)'),
('NUM_MAX_ALERTA', '4', '1', 'Número máximo de alertas (1) para o Tipo de Alerta (4)'),
('NUM_MAX_ALERTA', '5', '1', 'Número máximo de alertas (1) para o Tipo de Alerta (5)'),
('NUM_MAX_ALERTA', '6', '1', 'Número máximo de alertas (1) para o Tipo de Alerta (6)'),
('NUM_MAX_ALERTA', 'TEMPO', '120', 'Numero máximo de alerta no intervalo de VALOR expresso em segundos'),
('NUM_MAX_SENSORES', 'NUM_SENSORES', '2', 'Numero maximo de sensores no labirinto. Os sensores terão a nomecultura de \'1\' até ao numero maximo de sensores. Este numero deve ser >0'),
('NUM_MIN_ERROS', 'NUM_ERROS', '3', 'Número mínimo de erros inseridos na tabela erroexperiencia para despoletar a tentativa de alerta'),
('PARAMETRO_PERIODICIDADE', 'FATOR', '4', 'Fator multiplicativo de proporcionalidade direta em relação à periodicidade, sem que esta consiga exceder TEMPO maximo de periodicidade. Enquanto maior este numero, mais rapido a periodicidade se aproxima do tempo maximo permitido em função de SegundosAberturaPortasExterior'),
('PARAMETRO_PERIODICIDADE', 'TEMPO', '120', 'Tempo máximo entre cada receção de dados do mongo, em segundos'),
('TAMANHO_OUTLIER_SAMPLE', 'FATOR', '0.5', 'O tamanho máximo de uma amostra para calculo de outliers é calculado através da formula fator*segundosaberturaportaexterior*dadosporsegundo. Este valor deve estar em ]0,1['),
('TEMPERATURA', 'MAXIMA', '60', 'Temperatura máxima admitida no ambito de uma experiencia'),
('TEMPERATURA', 'MINIMA', '5', 'Temperatura minima admitida no ambito de uma experiencia'),
('TEMPO_CHECK_FINS', 'TEMPO', '15', 'Tempo entre verificações de final de experiências em segundos'),
('TEMPO_ENTRE_CHECK_MOVIMENTO', 'TEMPO', '5', 'Verificar se o tempo sem movimento dos ratos da ultima experiencia a ocorrer de [valor] em [valor] segundos.'),
('TEMPO_ENTRE_EXPERIENCIA', 'TEMPO', '10', 'Tempo minimo entre experiencias em minutos.');

-- --------------------------------------------------------

--
-- Stand-in structure for view `parametrosjavaop`
-- (See below for the actual view)
--
CREATE TABLE `parametrosjavaop` (
`fator_alerta_vermelho` varchar(30)
,`fator_alerta_laranja` varchar(30)
,`fator_alerta_amarelho` varchar(30)
,`num_sensores` varchar(30)
,`fator_periodicidade` varchar(30)
,`tempo_max_periodicidade` varchar(30)
,`fator_tamanho_outlier_sample` varchar(30)
,`temperatura_maxima` varchar(30)
,`temperatura_minima` varchar(30)
,`tempo_entre_experiencia` varchar(30)
,`segundos_abertura_portas_exterior` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `substancia`
--

CREATE TABLE `substancia` (
  `Id` int(11) NOT NULL,
  `Descricao` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `substancia`
--
DELIMITER $$
CREATE TRIGGER `validarDadosSubstancia` BEFORE INSERT ON `substancia` FOR EACH ROW BEGIN

SET new.Id = NULL;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `substanciaexperiencia`
--

CREATE TABLE `substanciaexperiencia` (
  `IdSubstancia` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `NumeroRatos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `substanciaexperiencia`
--
DELIMITER $$
CREATE TRIGGER `validarDadosSubsExpr` BEFORE INSERT ON `substanciaexperiencia` FOR EACH ROW BEGIN

IF(new.NumeroRatos<=0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numero de ratos tem de ser maior que 0.';
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tipoalerta`
--

CREATE TABLE `tipoalerta` (
  `Id` int(11) NOT NULL,
  `Descricao` text NOT NULL,
  `Valor` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Dumping data for table `tipoalerta`
--

INSERT INTO `tipoalerta` (`Id`, `Descricao`, `Valor`) VALUES
(1, 'Alerta Vermelho', NULL),
(2, 'Alerta Laranja', NULL),
(3, 'Alerta Amarelo', NULL),
(4, 'Limite Ratos', NULL),
(5, 'Segundos Sem Movimento', NULL),
(6, 'Erros de dados', NULL);

--
-- Triggers `tipoalerta`
--
DELIMITER $$
CREATE TRIGGER `dadosValidosTipoAlertaInsert` BEFORE INSERT ON `tipoalerta` FOR EACH ROW BEGIN

SET new.Id = NULL;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `dadosValidosTipoAlertaUpdate` BEFORE UPDATE ON `tipoalerta` FOR EACH ROW BEGIN

Set new.Id = old.Id;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tipoutilizador`
--

CREATE TABLE `tipoutilizador` (
  `TipoUtilizador` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Dumping data for table `tipoutilizador`
--

INSERT INTO `tipoutilizador` (`TipoUtilizador`) VALUES
('AppAdmin'),
('Investigador'),
('Java'),
('Tecnico');

-- --------------------------------------------------------

--
-- Table structure for table `utilizador`
--

CREATE TABLE `utilizador` (
  `Id` int(11) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Telefone` varchar(20) NOT NULL,
  `Tipo` varchar(100) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Ativo` tinyint(1) NOT NULL DEFAULT 1,
  `Username` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Triggers `utilizador`
--
DELIMITER $$
CREATE TRIGGER `tipoUtilizadorExperiencias` BEFORE UPDATE ON `utilizador` FOR EACH ROW BEGIN

if(old.tipo = 'Investigador' and new.tipo not like old.tipo and (SELECT COUNT(*) from experiencia where investigador = new.id) != 0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possivel mudar o tipo de utilizador pois este já tem experiencias associadas';
end if;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `alertas`
--
DROP TABLE IF EXISTS `alertas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `alertas`  AS SELECT `a`.`Id` AS `Id`, `a`.`IdExperiencia` AS `IdExperiencia`, `a`.`DataHora` AS `DataHora`, `ta`.`Descricao` AS `title`, `ta`.`Valor` AS `Valor`, `a`.`Descricao` AS `Descricao` FROM (`alerta` `a` join `tipoalerta` `ta` on(`ta`.`Id` = `a`.`IdTipoAlerta`)) ;

-- --------------------------------------------------------

--
-- Structure for view `experiencias`
--
DROP TABLE IF EXISTS `experiencias`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `experiencias`  AS SELECT `e`.`Id` AS `Id`, `e`.`Descricao` AS `Descricao`, `e`.`Investigador` AS `Investigador`, `e`.`DataHoraInicio` AS `DataHoraInicio`, `e`.`NumeroRatos` AS `NumeroRatos`, `e`.`LimiteRatosSala` AS `LimiteRatosSala`, `e`.`SegundosSemMovimento` AS `SegundosSemMovimento`, `e`.`VariacaoTemperaturaMaxima` AS `VariacaoTemperaturaMaxima`, `e`.`TemperaturaIdeal` AS `TemperaturaIdeal`, `e`.`DataHoraFim` AS `DataHoraFim` FROM `experiencia` AS `e` WHERE `e`.`Anulada` <> 1 ;

-- --------------------------------------------------------

--
-- Structure for view `javaop`
--
DROP TABLE IF EXISTS `javaop`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `javaop`  AS SELECT `e`.`Id` AS `id_experiencia`, `e`.`DataHoraInicio` AS `data_hora_inicio`, `e`.`DataHoraFim` AS `data_hora_fim`, `e`.`TemperaturaIdeal` AS `temperatura_ideal`, `e`.`VariacaoTemperaturaMaxima` AS `variacao_temperatura`, `pj`.`fator_alerta_vermelho` AS `fator_alerta_vermelho`, `pj`.`fator_alerta_laranja` AS `fator_alerta_laranja`, `pj`.`fator_alerta_amarelho` AS `fator_alerta_amarelho`, `pj`.`num_sensores` AS `num_sensores`, `pj`.`fator_periodicidade` AS `fator_periodicidade`, `pj`.`tempo_max_periodicidade` AS `tempo_max_periodicidade`, `pj`.`fator_tamanho_outlier_sample` AS `fator_tamanho_outlier_sample`, `pj`.`temperatura_maxima` AS `temperatura_maxima`, `pj`.`temperatura_minima` AS `temperatura_minima`, `pj`.`tempo_entre_experiencia` AS `tempo_entre_experiencia`, `pj`.`segundos_abertura_portas_exterior` AS `segundos_abertura_portas_exterior` FROM (`experiencia` `e` join `parametrosjavaop` `pj`) WHERE `e`.`Anulada` = 0 AND `e`.`Populada` = 0 AND `e`.`DataHoraInicio` <= current_timestamp() AND `e`.`DataHoraInicio` >= all (select `tempexp`.`DataHoraInicio` from `experiencia` `tempexp` where `tempexp`.`Anulada` = 0 AND `tempexp`.`Populada` = 0 AND `tempexp`.`DataHoraInicio` <= current_timestamp()) LIMIT 0, 1 ;

-- --------------------------------------------------------

--
-- Structure for view `parametrosjavaop`
--
DROP TABLE IF EXISTS `parametrosjavaop`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `parametrosjavaop`  AS SELECT (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'FATOR_ALERTA_TEMPERATURA' and `pa`.`Identificador` = 1) AS `fator_alerta_vermelho`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'FATOR_ALERTA_TEMPERATURA' and `pa`.`Identificador` = 2) AS `fator_alerta_laranja`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'FATOR_ALERTA_TEMPERATURA' and `pa`.`Identificador` = 3) AS `fator_alerta_amarelho`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'NUM_MAX_SENSORES' and `pa`.`Identificador` = 'NUM_SENSORES') AS `num_sensores`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'PARAMETRO_PERIODICIDADE' and `pa`.`Identificador` = 'FATOR') AS `fator_periodicidade`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'PARAMETRO_PERIODICIDADE' and `pa`.`Identificador` = 'TEMPO') AS `tempo_max_periodicidade`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'TAMANHO_OUTLIER_SAMPLE' and `pa`.`Identificador` = 'FATOR') AS `fator_tamanho_outlier_sample`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'TEMPERATURA' and `pa`.`Identificador` = 'MAXIMA') AS `temperatura_maxima`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'TEMPERATURA' and `pa`.`Identificador` = 'MINIMA') AS `temperatura_minima`, (select `pa`.`Valor` from `parametrosadicionais` `pa` where `pa`.`Agrupador` = 'TEMPO_ENTRE_EXPERIENCIA' and `pa`.`Identificador` = 'TEMPO') AS `tempo_entre_experiencia`, (select `cf`.`SegundosAberturaPortasExterior` from `configuracaolabirinto` `cf` limit 1) AS `segundos_abertura_portas_exterior` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerta`
--
ALTER TABLE `alerta`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ALERTA_TIPOALERTA` (`IdTipoAlerta`),
  ADD KEY `FK_ALERTA_EXPERIENCIA` (`IdExperiencia`);

--
-- Indexes for table `corredor`
--
ALTER TABLE `corredor`
  ADD PRIMARY KEY (`SalaEntrada`,`SalaSaida`);

--
-- Indexes for table `erroexperiencia`
--
ALTER TABLE `erroexperiencia`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ERROEXPERIENCIA_EXPERIENCIA` (`IdExperiencia`);

--
-- Indexes for table `experiencia`
--
ALTER TABLE `experiencia`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_EXPERIENCIA_UTILIZADOR` (`Investigador`);

--
-- Indexes for table `medicaopassagem`
--
ALTER TABLE `medicaopassagem`
  ADD PRIMARY KEY (`IdMedicaoPassagem`),
  ADD KEY `FK_MEDICAOPASSAGEM_EXPERIENCIA` (`IdExperiencia`);

--
-- Indexes for table `medicaosala`
--
ALTER TABLE `medicaosala`
  ADD PRIMARY KEY (`IdExperiencia`,`Sala`);

--
-- Indexes for table `medicaotemperatura`
--
ALTER TABLE `medicaotemperatura`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_MEDICAOTEMPERATURA_EXPERIENCIA` (`IdExperiencia`);

--
-- Indexes for table `odor`
--
ALTER TABLE `odor`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Descricao` (`Descricao`) USING HASH;

--
-- Indexes for table `odorexperiencia`
--
ALTER TABLE `odorexperiencia`
  ADD PRIMARY KEY (`Sala`,`IdExperiencia`),
  ADD KEY `FK_ODOREXPERIENCIA_EXPERIENCIA` (`IdExperiencia`),
  ADD KEY `FK_ODOREXPERIENCIA_ODOR` (`IdOdor`);

--
-- Indexes for table `parametrosadicionais`
--
ALTER TABLE `parametrosadicionais`
  ADD PRIMARY KEY (`Agrupador`,`Identificador`);

--
-- Indexes for table `substancia`
--
ALTER TABLE `substancia`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Descricao` (`Descricao`) USING HASH;

--
-- Indexes for table `substanciaexperiencia`
--
ALTER TABLE `substanciaexperiencia`
  ADD PRIMARY KEY (`IdSubstancia`,`IdExperiencia`),
  ADD KEY `FK_SUBSTANCIAEXPERIENCIA_EXPERIENCIA` (`IdExperiencia`);

--
-- Indexes for table `tipoalerta`
--
ALTER TABLE `tipoalerta`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Descricao` (`Descricao`) USING HASH;

--
-- Indexes for table `tipoutilizador`
--
ALTER TABLE `tipoutilizador`
  ADD PRIMARY KEY (`TipoUtilizador`);

--
-- Indexes for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD KEY `FK_UTILIZADOR_TIPOUTILIZADOR` (`Tipo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerta`
--
ALTER TABLE `alerta`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `erroexperiencia`
--
ALTER TABLE `erroexperiencia`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `experiencia`
--
ALTER TABLE `experiencia`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `medicaopassagem`
--
ALTER TABLE `medicaopassagem`
  MODIFY `IdMedicaoPassagem` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicaotemperatura`
--
ALTER TABLE `medicaotemperatura`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `odor`
--
ALTER TABLE `odor`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `substancia`
--
ALTER TABLE `substancia`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tipoalerta`
--
ALTER TABLE `tipoalerta`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `utilizador`
--
ALTER TABLE `utilizador`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alerta`
--
ALTER TABLE `alerta`
  ADD CONSTRAINT `FK_ALERTA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ALERTA_TIPOALERTA` FOREIGN KEY (`IdTipoAlerta`) REFERENCES `tipoalerta` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `erroexperiencia`
--
ALTER TABLE `erroexperiencia`
  ADD CONSTRAINT `FK_ERROEXPERIENCIA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `experiencia`
--
ALTER TABLE `experiencia`
  ADD CONSTRAINT `FK_EXPERIENCIA_UTILIZADOR` FOREIGN KEY (`Investigador`) REFERENCES `utilizador` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `medicaopassagem`
--
ALTER TABLE `medicaopassagem`
  ADD CONSTRAINT `FK_MEDICAOPASSAGEM_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medicaosala`
--
ALTER TABLE `medicaosala`
  ADD CONSTRAINT `FK_MEDICAOSALA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `medicaotemperatura`
--
ALTER TABLE `medicaotemperatura`
  ADD CONSTRAINT `FK_MEDICAOTEMPERATURA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`);

--
-- Constraints for table `odorexperiencia`
--
ALTER TABLE `odorexperiencia`
  ADD CONSTRAINT `FK_ODOREXPERIENCIA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ODOREXPERIENCIA_ODOR` FOREIGN KEY (`IdOdor`) REFERENCES `odor` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `substanciaexperiencia`
--
ALTER TABLE `substanciaexperiencia`
  ADD CONSTRAINT `FK_SUBSTANCIAEXPERIENCIA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_SUBSTANCIAEXPERIENCIA_SUBSTANCIA` FOREIGN KEY (`IdSubstancia`) REFERENCES `substancia` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD CONSTRAINT `FK_UTILIZADOR_TIPOUTILIZADOR` FOREIGN KEY (`Tipo`) REFERENCES `tipoutilizador` (`TipoUtilizador`) ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `finalizarExperienciaAuto` ON SCHEDULE EVERY 15 SECOND STARTS '2023-04-23 15:58:55' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

UPDATE experiencia
SET experiencia.DataHoraFim=CURRENT_TIMESTAMP
WHERE e.DataHoraFim IS NULL AND e.DataHoraInicio<CURRENT_TIMESTAMP AND TIMESTAMPDIFF(MINUTE,CURRENT_TIMESTAMP,e.DataHoraInicio)>=(SELECT pa.Valor FROM parametrosadicionais pa WHERE pa.Agrupador = 'TEMPO_ENTRE_EXPERIENCIA' AND pa.Identificador='TEMPO');

END$$

CREATE DEFINER=`root`@`localhost` EVENT `checkMovimento` ON SCHEDULE EVERY 5 SECOND STARTS '2023-04-23 13:54:19' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN 

DECLARE idExp INT;
DECLARE lastTime DATETIME;
DECLARE segSemMov INT;

SELECT e.id, e.SegundosSemMovimento INTO idExp, segSemMov
FROM experiencia e
WHERE e.Anulada=0 AND e.DataHoraFim IS NULL AND e.DataHoraInicio <= CURRENT_TIMESTAMP;

IF(idExp<>NULL) THEN
	SELECT mp.DataHora INTO lastTime
    FROM medicaopassagem mp
    WHERE mp.IdExperiencia=idExp AND mp.DataHora >= ALL(
        SELECT tmp.DataHora
   		FROM medicaopassagem tmp
    	WHERE tmp.IdExperiencia=idExp);
    IF(TIMESTAMPDIFF(SECOND,CURRENT_TIMESTAMP,lastTime)>segSemMov) THEN
    	CALL introduzirAlerta(idExp, 5, CONCAT('Ratos sem movimento durante mais de ', segSemMov,' na experiencia ',idExp,'.'));
    END IF;
END IF;

END$$

DELIMITER ;
SET FOREIGN_KEY_CHECKS=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

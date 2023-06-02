/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alerta` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdExperiencia` int(11) NOT NULL,
  `IdTipoAlerta` int(11) NOT NULL,
  `DataHora` datetime NOT NULL DEFAULT current_timestamp(),
  `Descricao` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_ALERTA_TIPOALERTA` (`IdTipoAlerta`),
  KEY `FK_ALERTA_EXPERIENCIA` (`IdExperiencia`),
  CONSTRAINT `FK_ALERTA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ALERTA_TIPOALERTA` FOREIGN KEY (`IdTipoAlerta`) REFERENCES `tipoalerta` (`Id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuracaolabirinto` (
  `TemperaturaProgramada` decimal(4,2) NOT NULL,
  `SegundosAberturaPortasExterior` int(11) NOT NULL,
  `NumeroSalas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `corredor` (
  `SalaSaida` int(11) NOT NULL,
  `SalaEntrada` int(11) NOT NULL,
  `Cumprimento` int(11) NOT NULL,
  PRIMARY KEY (`SalaEntrada`,`SalaSaida`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `experiencia` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
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
  `Anulada` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `FK_EXPERIENCIA_UTILIZADOR` (`Investigador`),
  CONSTRAINT `FK_EXPERIENCIA_UTILIZADOR` FOREIGN KEY (`Investigador`) REFERENCES `utilizador` (`Id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `criarExperienciaLimiteBefore` BEFORE INSERT ON `experiencia` FOR EACH ROW BEGIN

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

IF new.DataHoraInicio < CURRENT_DATE THEN
	SIGNAL SQLSTATE '45000' 
	SET MESSAGE_TEXT = "Nao foi possivel completar a operacao, nao é possivel comecar uma experiencia no passado";
END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tipoUtilizadorExperienciaInsert` BEFORE INSERT ON `experiencia` FOR EACH ROW BEGIN

	if(SELECT 1 from utilizador where id = new.Investigador and tipo <> 'Investigador') then 
    SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'Erro ao tentar associar um utilizador não investigador à experiência';
    end IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `criarExperienciaLimiteAfter` AFTER INSERT ON `experiencia` FOR EACH ROW BEGIN

INSERT INTO medicaosala (medicaosala.IdExperiencia, medicaosala.Sala, medicaosala.NumeroRatos)
VALUES (new.Id, 1, new.NumeroRatos);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tipoUtilizadorExperienciaUpdate` BEFORE UPDATE ON `experiencia` FOR EACH ROW BEGIN

if(SELECT 1 from utilizador where id = new.Investigador and tipo <> 'Investigador') then 
    SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'Erro ao tentar associar um utilizador não investigador à experiência';
    end IF;
    
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `javaop` AS SELECT
 1 AS `DataHoraInicio`,
  1 AS `DataHoraFim`,
  1 AS `LimiteRatosSala`,
  1 AS `SegundosSemMovimento`,
  1 AS `SegundosAberturaPortasExterior` */;
SET character_set_client = @saved_cs_client;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `DataHora` datetime NOT NULL DEFAULT current_timestamp(),
  `Tipo` enum('Dado corrompido','Dado Invalido') NOT NULL,
  `Valor` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicaopassagem` (
  `IdMedicaoPassagem` int(11) NOT NULL AUTO_INCREMENT,
  `IdExperiencia` int(11) NOT NULL,
  `DataHora` datetime NOT NULL,
  `SalaSaida` int(11) NOT NULL,
  `SalaEntrada` int(11) NOT NULL,
  PRIMARY KEY (`IdMedicaoPassagem`),
  KEY `FK_MEDICAOPASSAGEM_EXPERIENCIA` (`IdExperiencia`),
  CONSTRAINT `FK_MEDICAOPASSAGEM_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `atualizarMedicaoSala` AFTER INSERT ON `medicaopassagem` FOR EACH ROW BEGIN

INSERT INTO medicaosala (IdExperiencia, Sala, NumeroRatos) VALUES(new.IdExperiencia, new.SalaEntrada, 1) ON DUPLICATE KEY UPDATE NumeroRatos = NumeroRatos + 1;

INSERT INTO medicaosala (IdExperiencia, Sala, NumeroRatos) VALUES(new.IdExperiencia, new.SalaSaida, -1) ON DUPLICATE KEY UPDATE NumeroRatos = NumeroRatos - 1;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicaosala` (
  `IdExperiencia` int(11) NOT NULL,
  `Sala` int(11) NOT NULL,
  `NumeroRatos` int(11) NOT NULL,
  PRIMARY KEY (`IdExperiencia`,`Sala`),
  CONSTRAINT `FK_MEDICAOSALA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `alertaMedicaoSalaInsert` AFTER INSERT ON `medicaosala` FOR EACH ROW BEGIN
DECLARE limite INT;
DECLARE aviso varchar(150);

SELECT e.LimiteRatosSala into limite
FROM experiencia e
WHERE e.Id = new.IdExperiencia;

IF(new.NumeroRatos > limite) THEN
	SET aviso = CONCAT('Experiencia ',new.IdExperiencia,': Numero de ratos na sala ',new.Sala,' excedido.');
    CALL introduzirAlerta(4,new.IdExperiencia,aviso);
END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `alertaMedicaoSalaUpdate` AFTER UPDATE ON `medicaosala` FOR EACH ROW BEGIN
DECLARE limite INT;
DECLARE aviso varchar(150);

SELECT e.LimiteRatosSala into limite
FROM experiencia e
WHERE e.Id = new.IdExperiencia;

IF(new.NumeroRatos > limite) THEN
	SET aviso = CONCAT('Experiencia ',new.IdExperiencia,': Numero de ratos na sala ',new.Sala,' excedido.');
	CALL introduzirAlerta(4,new.IdExperiencia,aviso);
END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `medicaotemperatura` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IdExperiencia` int(11) NOT NULL,
  `DataHora` datetime NOT NULL,
  `Leitura` decimal(4,2) NOT NULL,
  `Sensor` int(11) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_MEDICAOTEMPERATURA_EXPERIENCIA` (`IdExperiencia`),
  CONSTRAINT `FK_MEDICAOTEMPERATURA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `odor` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Descricao` text NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `odorexperiencia` (
  `Sala` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `IdOdor` int(11) NOT NULL,
  PRIMARY KEY (`Sala`,`IdExperiencia`),
  KEY `FK_ODOREXPERIENCIA_EXPERIENCIA` (`IdExperiencia`),
  KEY `FK_ODOREXPERIENCIA_ODOR` (`IdOdor`),
  CONSTRAINT `FK_ODOREXPERIENCIA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ODOREXPERIENCIA_ODOR` FOREIGN KEY (`IdOdor`) REFERENCES `odor` (`Id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parametrosadicionais` (
  `Agrupador` varchar(30) NOT NULL,
  `Identificador` varchar(30) NOT NULL,
  `Valor` varchar(30) NOT NULL,
  `Descricao` text NOT NULL,
  PRIMARY KEY (`Agrupador`,`Identificador`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `substancia` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Descricao` text NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `substanciaexperiencia` (
  `IdSubstancia` int(11) NOT NULL,
  `IdExperiencia` int(11) NOT NULL,
  `NumeroRatos` int(11) NOT NULL,
  PRIMARY KEY (`IdSubstancia`,`IdExperiencia`),
  KEY `FK_SUBSTANCIAEXPERIENCIA_EXPERIENCIA` (`IdExperiencia`),
  CONSTRAINT `FK_SUBSTANCIAEXPERIENCIA_EXPERIENCIA` FOREIGN KEY (`IdExperiencia`) REFERENCES `experiencia` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SUBSTANCIAEXPERIENCIA_SUBSTANCIA` FOREIGN KEY (`IdSubstancia`) REFERENCES `substancia` (`Id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipoalerta` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Descricao` text NOT NULL,
  `Valor` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipoutilizador` (
  `TipoUtilizador` varchar(100) NOT NULL,
  PRIMARY KEY (`TipoUtilizador`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `utilizador` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `Telefone` varchar(20) NOT NULL,
  `Tipo` varchar(100) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Ativo` tinyint(1) NOT NULL DEFAULT 1,
  `Username` varchar(30) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Username` (`Username`),
  KEY `FK_UTILIZADOR_TIPOUTILIZADOR` (`Tipo`),
  CONSTRAINT `FK_UTILIZADOR_TIPOUTILIZADOR` FOREIGN KEY (`Tipo`) REFERENCES `tipoutilizador` (`TipoUtilizador`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tipoUtilizadorExperiencias` BEFORE UPDATE ON `utilizador` FOR EACH ROW BEGIN

if(old.tipo = 'Investigador' and new.tipo not like old.tipo and (SELECT COUNT(*) from experiencia where investigador = new.id) != 0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possivel mudar o tipo de utilizador pois este já tem experiencias associadas';
end if;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `checkUsernameExiste`(`username` VARCHAR(30)) RETURNS int(11)
BEGIN

RETURN EXISTS( SELECT *
             	FROM utilizador
             	WHERE utilizador.Username = username);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `podeInserirAlerta`(`IdTipoAlerta` INT(11)) RETURNS tinyint(1) unsigned zerofill
BEGIN 

RETURN ((SELECT COUNT(*)
FROM ALERTA 
WHERE IdTipoAlerta = IdTipoAlerta AND TIMESTAMPDIFF(SECOND, DataHora, current_timestamp) <= (SELECT CAST(VALOR AS INT)
FROM PARAMETROSADICIONAIS 
WHERE Agrupador = 'NUM_MAX_ALERTA' AND Identificador = 'TEMPO')) < (SELECT CAST(VALOR AS INT)
FROM PARAMETROSADICIONAIS 
WHERE Agrupador = 'NUM_MAX_ALERTA' AND Identificador = IdTipoAlerta));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `adicionarOdorExperiencia`(IN `idExp` INT, IN `idSala` INT, IN `idOdo` INT)
BEGIN

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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `adicionarSubstanciaExperiencia`(IN `idExp` INT, IN `idSub` INT, IN `NumRatos` INT)
BEGIN

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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `consultarInformaçãoPessoal`()
SELECT u.Nome, u.Username, u.Email, u.Telefone, u.Tipo
FROM utilizador u
where u.Username=(SELECT SUBSTRING_INDEX(USER(),'@',1)) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteLogicoExperiencia`(IN `idExperiencia` INT)
BEGIN
UPDATE `experiencia` SET `Ativa` = '0' WHERE `experiencia`.`Id` = idExperiencia;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `experienciaNaoPopulada`(IN `idExperiencia` INT)
UPDATE experiencia SET experiencia.Populada=0 WHERE experiencia.Id=idExperiencia ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `experienciaPopulada`(IN `idExperiencia` INT)
UPDATE experiencia SET experiencia.Populada=1 WHERE experiencia.Id=idExperiencia ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `finalizarExperiencia`(IN `IdExperiencia` INT(11))
BEGIN

    update experiencia set DataHoraFim = current_timestamp where Id = IdExperiencia;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciarExperiencia`(IN `Descricao` VARCHAR(100000), IN `DataHoraInicio` DATETIME, IN `NumeroRatos` INT, IN `SegundosSemMovimento` INT, IN `VariacaoTemperaturaMaxima` DECIMAL(4,2), IN `TemperaturaIdeal` DECIMAL(4,2), IN `LimiteRatosSala` INT)
BEGIN

DECLARE idUtilizador INT;

SELECT u.id INTO idUtilizador
FROM utilizador u
WHERE u.Username=SUBSTRING_INDEX(USER(),'@',1);

IF(DataHoraInicio IS NULL) THEN
	SET DataHoraInicio = CURRENT_TIMESTAMP;
END IF;

INSERT INTO `experiencia` (`Id`, `Descricao`, `Investigador`, `DataHoraInicio`, `NumeroRatos`, `LimiteRatosSala`, `SegundosSemMovimento`, `VariacaoTemperaturaMaxima`, `TemperaturaIdeal`, `DataHoraFim`, `Populada`, `Anulada`) VALUES (NULL, Descricao, idUtilizador, DataHoraInicio, NumeroRatos, LimiteRatosSala, SegundosSemMovimento, VariacaoTemperaturaMaxima, TemperaturaIdeal, NULL, '0', '0');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `introduzirAlerta`(IN `IdTipoAlerta` INT(11), IN `IdExperiencia` INT(11), IN `Descricao` VARCHAR(150))
BEGIN

IF(podeInserirAlerta(IdTipoAlerta)) THEN
     INSERT INTO alerta (IdExperiencia, IdTipoAlerta, Descricao) VALUES (IdExperiencia, IdTipoAlerta, Descricao);
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `introduzirPassagem`(IN `idExp` INT, IN `salaDeSaida` INT(11), IN `salaDeEntrada` INT(11))
BEGIN

DECLARE valor VARCHAR(150);
DECLARE corredor INT;

SELECT COUNT(*) INTO corredor
       FROM corredor
       WHERE corredor.SalaEntrada = salaDeEntrada AND corredor.SalaSaida = salaDeSaida ;

IF(corredor > 0)  THEN

  INSERT INTO medicaopassagem (idExperiencia, DataHora, SalaSaida, SalaEntrada)
  VALUES (iDExp, CURRENT_TIMESTAMP, salaDeSaida, salaDeEntrada);

ELSE

SET valor = CONCAT('Corredor nao existe na experiencia: ', idExp ,'; entrada: ', salaDeEntrada, '; saida: ',salaDeSaida);

  INSERT INTO log(DataHora, Tipo, Valor)
  VALUES (CURRENT_TIMESTAMP,'Dado Invalido', valor);


END IF;   

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarExperiencia`(IN `idExperiencia` INT, IN `Descricao` TEXT, IN `LimiteRatosSala` INT, IN `SegundosSemMovimento` INT)
BEGIN

IF(!(Descricao IS NULL OR Descricao='')) THEN
	UPDATE experiencia e SET e.Descricao=Descricao WHERE e.Id=idExperiencia;
END IF;

IF(!(LimiteRatosSala IS NULL OR LimiteRatosSala=0)) THEN
	UPDATE experiencia e SET e.LimiteRatosSala=LimiteRatosSala WHERE e.Id=idExperiencia;
END IF;

IF(!(SegundosSemMovimento IS NULL OR SegundosSemMovimento=0)) THEN
	UPDATE experiencia e SET e.SegundosSemMovimento=SegundosSemMovimento WHERE e.Id=idExperiencia;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarOutraExperiencia`(IN `idExperiencia` INT, IN `Investigador` INT, IN `Finalizada` TINYINT(1), IN `Anulada` TINYINT(1), IN `Populada` TINYINT(1))
BEGIN

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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarOutroUser`(IN `idUtilizador` INT, IN `Ativo` INT, IN `Username` VARCHAR(30), IN `Tipo` VARCHAR(100))
BEGIN

IF(Ativo IS NOT NULL) THEN
	UPDATE utilizador SET utilizador.Ativo=Ativo WHERE utilizador.Id=idUtilizador;
END IF;

IF(!(Username IS NULL OR Username='')) THEN
	UPDATE utilizador SET utilizador.Username=Username WHERE utilizador.Id=idUtilizador;
END IF;

IF EXISTS(SELECT * FROM tipoutilizador WHERE tipoutilizador.TipoUtilizador = Tipo) THEN
	UPDATE utilizador SET utilizador.Tipo=Tipo WHERE utilizador.Id=idUtilizador;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarProprioUser`(IN `Nome` VARCHAR(100), IN `Telefone` VARCHAR(20), IN `Email` VARCHAR(50))
BEGIN
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50001 DROP VIEW IF EXISTS `javaop`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `javaop` AS select `e`.`DataHoraInicio` AS `DataHoraInicio`,`e`.`DataHoraFim` AS `DataHoraFim`,`e`.`LimiteRatosSala` AS `LimiteRatosSala`,`e`.`SegundosSemMovimento` AS `SegundosSemMovimento`,`cfglab`.`SegundosAberturaPortasExterior` AS `SegundosAberturaPortasExterior` from (`configuracaolabirinto` `cfglab` join `experiencia` `e`) where `e`.`DataHoraInicio` >= all (select `experiencia`.`DataHoraInicio` from `experiencia`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

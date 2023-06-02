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
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `alertas` AS SELECT
 1 AS `Id`,
  1 AS `IdExperiencia`,
  1 AS `DataHora`,
  1 AS `title`,
  1 AS `Valor`,
  1 AS `Descricao` */;
SET character_set_client = @saved_cs_client;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `criarExperienciaLimiteBefore` BEFORE INSERT ON `experiencia`
 FOR EACH ROW BEGIN

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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tipoUtilizadorExperienciaInsert` BEFORE INSERT ON `experiencia`
 FOR EACH ROW BEGIN

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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarDadosExperiencia` BEFORE INSERT ON `experiencia`
 FOR EACH ROW BEGIN

SET new.Id = NULL;
SET new.Populada = 0;
SET new.Anulada = 0;

IF(new.NumeroRatos<=0 OR new.LimiteRatosSala<=0 OR new.SegundosSemMovimento <= 0 OR new.VariacaoTemperaturaMaxima <=0 OR new.TemperaturaIdeal <= 0 OR new.DataHoraInicio >= new.DataHoraFim) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Os dados inseridos não são válidos.';
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `criarExperienciaLimiteAfter` AFTER INSERT ON `experiencia`
 FOR EACH ROW BEGIN

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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tipoUtilizadorExperienciaUpdate` BEFORE UPDATE ON `experiencia`
 FOR EACH ROW BEGIN

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
/*!50001 CREATE VIEW `experiencias` AS SELECT
 1 AS `Id`,
  1 AS `Descricao`,
  1 AS `Investigador`,
  1 AS `DataHoraInicio`,
  1 AS `NumeroRatos`,
  1 AS `LimiteRatosSala`,
  1 AS `SegundosSemMovimento`,
  1 AS `VariacaoTemperaturaMaxima`,
  1 AS `TemperaturaIdeal`,
  1 AS `DataHoraFim` */;
SET character_set_client = @saved_cs_client;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `javaop` AS SELECT
 1 AS `Id`,
  1 AS `DataHoraInicio`,
  1 AS `VariacaoTemperaturaMaxima`,
  1 AS `TemperaturaIdeal`,
  1 AS `DataHoraFim` */;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarDadosPassagem` BEFORE INSERT ON `medicaopassagem`
 FOR EACH ROW BEGIN

SET new.IdMedicaoPassagem = NULL;

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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `atualizarMedicaoSala` AFTER INSERT ON `medicaopassagem`
 FOR EACH ROW BEGIN

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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `alertaMedicaoSalaInsert` AFTER INSERT ON `medicaosala`
 FOR EACH ROW BEGIN
DECLARE limite INT;
DECLARE aviso varchar(150);

SELECT e.LimiteRatosSala into limite
FROM experiencia e
WHERE e.Id = new.IdExperiencia;

IF(new.NumeroRatos > limite && new.Sala<>1) THEN
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `alertaMedicaoSalaUpdate` AFTER UPDATE ON `medicaosala`
 FOR EACH ROW BEGIN
DECLARE limite INT;
DECLARE aviso varchar(150);

SELECT e.LimiteRatosSala into limite
FROM experiencia e
WHERE e.Id = new.IdExperiencia;

IF(new.NumeroRatos > limite  && new.Sala<>1) THEN
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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarDadosMedicaoTemperatura` BEFORE INSERT ON `medicaotemperatura`
 FOR EACH ROW BEGIN

Set new.Id = NULL;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `odor` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Descricao` text NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Descricao` (`Descricao`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarDadosOdor` BEFORE INSERT ON `odor`
 FOR EACH ROW BEGIN

SET new.Id = NULL;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Descricao` (`Descricao`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarDadosSubstancia` BEFORE INSERT ON `substancia`
 FOR EACH ROW BEGIN

SET new.Id = NULL;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validarDadosSubsExpr` BEFORE INSERT ON `substanciaexperiencia`
 FOR EACH ROW BEGIN

IF(new.NumeroRatos<=0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Numero de ratos tem de ser maior que 0.';
END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipoalerta` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Descricao` text NOT NULL,
  `Valor` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Descricao` (`Descricao`) USING HASH
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `dadosValidosTipoAlertaInsert` BEFORE INSERT ON `tipoalerta`
 FOR EACH ROW BEGIN

SET new.Id = NULL;

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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `dadosValidosTipoAlertaUpdate` BEFORE UPDATE ON `tipoalerta`
 FOR EACH ROW BEGIN

Set new.Id = old.Id;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tipoUtilizadorExperiencias` BEFORE UPDATE ON `utilizador`
 FOR EACH ROW BEGIN

if(old.tipo = 'Investigador' and new.tipo not like old.tipo and (SELECT COUNT(*) from experiencia where investigador = new.id) != 0) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possivel mudar o tipo de utilizador pois este já tem experiencias associadas';
end if;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `checkMovimento` ON SCHEDULE EVERY 5 SECOND STARTS '2023-04-23 13:54:19' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN 

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

END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `finalizarExperienciaAuto` ON SCHEDULE EVERY 15 SECOND STARTS '2023-04-23 15:58:55' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN

UPDATE experiencia
SET experiencia.DataHoraFim=CURRENT_TIMESTAMP
WHERE e.DataHoraFim IS NULL AND e.DataHoraInicio<CURRENT_TIMESTAMP AND TIMESTAMPDIFF(MINUTE,CURRENT_TIMESTAMP,e.DataHoraInicio)>=(SELECT pa.Valor FROM parametrosadicionais pa WHERE pa.Agrupador = 'TEMPO_ENTRE_EXPERIENCIA' AND pa.Identificador='TEMPO');

END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `checkUsernameExiste`(`username` VARCHAR(30)) RETURNS tinyint(1)
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `alterarParametrosAdicionais`(IN `Agrupador` VARCHAR(30), IN `Identificador` VARCHAR(30), IN `Valor` VARCHAR(30))
BEGIN

IF(EXISTS(SELECT * FROM parametrosadicionais p WHERE p.Agrupador=Agrupador AND p.Identificador=Identificador)) THEN

	UPDATE parametrosadicionais p SET p.Valor=Valor WHERE p.Agrupador=Agrupador AND p.Identificador=Identificador;
    
    IF (Agrupador='TEMPO_ENTRE_CHECK_MOVIMENTO' AND Identificador='TEMPO') THEN
    	ALTER EVENT checkMovimento ON SCHEDULE EVERY Valor SECOND;
    ELSEIF(Agrupador='TEMPO_CHECK_FINS' AND Identificador='TEMPO') THEN
        ALTER EVENT finalizarExperienciaAuto ON SCHEDULE EVERY Valor SECOND;
    END IF;
    
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `criarUtilizador`(IN `Username` VARCHAR(30), IN `TPassword` LONGTEXT, IN `Nome` VARCHAR(100), IN `Telefone` VARCHAR(20), IN `Tipo` VARCHAR(100), IN `Email` VARCHAR(50))
BEGIN
SET @query1 = CONCAT('CREATE USER "',Username,'"@"%" IDENTIFIED BY "',TPassword,'" ');
SET @query2 = CONCAT('GRANT ',Tipo,' TO ', Username);
SET @query3 = CONCAT('SET DEFAULT ROLE ', Tipo ,' FOR ', Username);


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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteLogicoExperiencia`(IN `idExperiencia` INT)
BEGIN
UPDATE `experiencia` SET `Anulada` = '1' WHERE `experiencia`.`Id` = idExperiencia;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciarExperiencia`(IN `Descricao` TEXT, IN `DataHoraInicio` DATETIME, IN `NumeroRatos` INT, IN `SegundosSemMovimento` INT, IN `VariacaoTemperaturaMaxima` DECIMAL(4,2), IN `TemperaturaIdeal` DECIMAL(4,2), IN `LimiteRatosSala` INT)
BEGIN

DECLARE idUtilizador INT;
DECLARE idExp INT;


SELECT u.id INTO idUtilizador
FROM utilizador u
WHERE u.Username=SUBSTRING_INDEX(USER(),'@',1);

INSERT INTO `experiencia` (`Id`, `Descricao`, `Investigador`, `DataHoraInicio`, `NumeroRatos`, `LimiteRatosSala`, `SegundosSemMovimento`, `VariacaoTemperaturaMaxima`, `TemperaturaIdeal`, `DataHoraFim`, `Populada`, `Anulada`) VALUES (NULL, Descricao, idUtilizador, nvl(DataHoraInicio, CURRENT_TIMESTAMP), NumeroRatos, LimiteRatosSala, SegundosSemMovimento, VariacaoTemperaturaMaxima, TemperaturaIdeal, NULL, '0', '0');



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `introduzirPassagem`(IN `idExp` INT, IN `salaDeSaida` INT(11), IN `salaDeEntrada` INT(11), IN `horaPassagem` DATETIME)
BEGIN

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

  INSERT INTO log(DataHora, Tipo, Valor)
  VALUES (horaPassagem,'Dado Invalido', valor);


END IF;   

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mudarOutroUser`(IN `idUtilizador` INT, IN `Ativo` TINYINT(1), IN `Username` VARCHAR(30), IN `Tipo` VARCHAR(100))
BEGIN

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



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `resetDadosExperiencia`(IN `idExperiencia` INT, IN `confirmacao` VARCHAR(50))
BEGIN
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50001 DROP VIEW IF EXISTS `alertas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `alertas` AS select `a`.`Id` AS `Id`,`a`.`IdExperiencia` AS `IdExperiencia`,`a`.`DataHora` AS `DataHora`,`ta`.`Descricao` AS `title`,`ta`.`Valor` AS `Valor`,`a`.`Descricao` AS `Descricao` from (`micelab`.`alerta` `a` join `micelab`.`tipoalerta` `ta` on(`ta`.`Id` = `a`.`IdTipoAlerta`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `experiencias`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `experiencias` AS select `e`.`Id` AS `Id`,`e`.`Descricao` AS `Descricao`,`e`.`Investigador` AS `Investigador`,`e`.`DataHoraInicio` AS `DataHoraInicio`,`e`.`NumeroRatos` AS `NumeroRatos`,`e`.`LimiteRatosSala` AS `LimiteRatosSala`,`e`.`SegundosSemMovimento` AS `SegundosSemMovimento`,`e`.`VariacaoTemperaturaMaxima` AS `VariacaoTemperaturaMaxima`,`e`.`TemperaturaIdeal` AS `TemperaturaIdeal`,`e`.`DataHoraFim` AS `DataHoraFim` from `micelab`.`experiencia` `e` where `e`.`Anulada` <> 1 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!50001 DROP VIEW IF EXISTS `javaop`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `javaop` AS select `micelab`.`experiencia`.`Id` AS `Id`,`micelab`.`experiencia`.`DataHoraInicio` AS `DataHoraInicio`,`micelab`.`experiencia`.`VariacaoTemperaturaMaxima` AS `VariacaoTemperaturaMaxima`,`micelab`.`experiencia`.`TemperaturaIdeal` AS `TemperaturaIdeal`,`micelab`.`experiencia`.`DataHoraFim` AS `DataHoraFim` from `micelab`.`experiencia` where `micelab`.`experiencia`.`Anulada` = 0 and `micelab`.`experiencia`.`Populada` = 0 and `micelab`.`experiencia`.`DataHoraInicio` <= current_timestamp() and `micelab`.`experiencia`.`DataHoraInicio` >= all (select `tempexp`.`DataHoraInicio` from `micelab`.`experiencia` `tempexp` where `tempexp`.`Anulada` = 0 and `tempexp`.`Populada` = 0 and `tempexp`.`DataHoraInicio` <= current_timestamp()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

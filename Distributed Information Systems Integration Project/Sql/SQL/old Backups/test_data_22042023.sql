/*!40000 ALTER TABLE `alerta` DISABLE KEYS */;
/*!40000 ALTER TABLE `alerta` ENABLE KEYS */;
/*!40000 ALTER TABLE `configuracaolabirinto` DISABLE KEYS */;
/*!40000 ALTER TABLE `configuracaolabirinto` ENABLE KEYS */;
/*!40000 ALTER TABLE `corredor` DISABLE KEYS */;
/*!40000 ALTER TABLE `corredor` ENABLE KEYS */;
/*!40000 ALTER TABLE `experiencia` DISABLE KEYS */;
INSERT INTO `experiencia` VALUES (1,'dfxgcvhbjnkml',1,'2023-04-18 14:19:00',4,4,4,4.00,4.00,'2023-04-18 14:53:00',0,0);
/*!40000 ALTER TABLE `experiencia` ENABLE KEYS */;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
/*!40000 ALTER TABLE `medicaopassagem` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicaopassagem` ENABLE KEYS */;
/*!40000 ALTER TABLE `medicaosala` DISABLE KEYS */;
INSERT INTO `medicaosala` VALUES (1,1,4);
/*!40000 ALTER TABLE `medicaosala` ENABLE KEYS */;
/*!40000 ALTER TABLE `medicaotemperatura` DISABLE KEYS */;
/*!40000 ALTER TABLE `medicaotemperatura` ENABLE KEYS */;
/*!40000 ALTER TABLE `odor` DISABLE KEYS */;
/*!40000 ALTER TABLE `odor` ENABLE KEYS */;
/*!40000 ALTER TABLE `odorexperiencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `odorexperiencia` ENABLE KEYS */;
/*!40000 ALTER TABLE `parametrosadicionais` DISABLE KEYS */;
INSERT INTO `parametrosadicionais` VALUES ('NUM_MAX_ALERTA','1','3','Número máximo de alertas (3) para o Tipo de Alerta (1)'),('NUM_MAX_ALERTA','2','2','Número máximo de alertas (1) para o Tipo de Alerta (2)'),('NUM_MAX_ALERTA','3','1','Número máximo de alertas (1) para o Tipo de Alerta (3)'),('NUM_MAX_ALERTA','TEMPO','120','Numero máximo de alerta no intervalo de VALOR expresso em segundos'),('TEMPO_ENTRE_EXPERIENCIA','TEMPO','10','Tempo minimo entre experiencias em minutos.');
/*!40000 ALTER TABLE `parametrosadicionais` ENABLE KEYS */;
/*!40000 ALTER TABLE `substancia` DISABLE KEYS */;
/*!40000 ALTER TABLE `substancia` ENABLE KEYS */;
/*!40000 ALTER TABLE `substanciaexperiencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `substanciaexperiencia` ENABLE KEYS */;
/*!40000 ALTER TABLE `tipoalerta` DISABLE KEYS */;
INSERT INTO `tipoalerta` VALUES (1,'Alerta Vermelho',NULL),(2,'Alerta Amarelo',NULL),(3,'Alerta Verde',NULL),(4,'Limite Ratos',NULL);
/*!40000 ALTER TABLE `tipoalerta` ENABLE KEYS */;
/*!40000 ALTER TABLE `tipoutilizador` DISABLE KEYS */;
INSERT INTO `tipoutilizador` VALUES ('AppAdmin'),('Investigador'),('JavaOp'),('Tecnico');
/*!40000 ALTER TABLE `tipoutilizador` ENABLE KEYS */;
/*!40000 ALTER TABLE `utilizador` DISABLE KEYS */;
INSERT INTO `utilizador` VALUES (1,'test','123456','Investigador','sdfghjk',1,'test');
/*!40000 ALTER TABLE `utilizador` ENABLE KEYS */;
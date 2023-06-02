TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `introduzirAlertaErro` AFTER INSERT ON `erroexperiencia` FOR EACH ROW BEGIN\n\nIF((SELECT count(*) from erroexperiencia where\nIdExperiencia = new.IdExperiencia) > (SELECT valor from\nparametrosadicionais where agrupador = \'NUM_MIN_ERROS\'\nand identificador = \'NUM_ERROS\')) THEN\n\nCALL introduzirAlerta(6, new.IdExperiencia, \'Dados\\r\\nprovenientes dos sensores com erro\');\n\nEND IF;\n\nEND'
sql_modes=524288
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_general_ci'
db_cl_names='latin1_bin'
created=1684088299274227

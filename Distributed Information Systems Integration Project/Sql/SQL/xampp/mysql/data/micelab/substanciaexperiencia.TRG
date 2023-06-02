TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `validarDadosSubsExpr` BEFORE INSERT ON `substanciaexperiencia` FOR EACH ROW BEGIN\n\nIF(new.NumeroRatos<=0) THEN\nSIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Numero de ratos tem de ser maior que 0.\';\nEND IF;\n\nEND'
sql_modes=524288
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_general_ci'
db_cl_names='latin1_bin'
created=1684088299455756

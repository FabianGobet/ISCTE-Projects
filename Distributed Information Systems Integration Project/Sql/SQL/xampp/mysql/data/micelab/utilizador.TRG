TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `tipoUtilizadorExperiencias` BEFORE UPDATE ON `utilizador` FOR EACH ROW BEGIN\n\nif(old.tipo = \'Investigador\' and new.tipo not like\nold.tipo and (SELECT COUNT(*) from experiencia where\ninvestigador = new.id) != 0) THEN\n\nSIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT = \'Não é\\r\\npossivel mudar o tipo de utilizador pois este já tem\\r\\nexperiencias associadas\';\n\nend if;\n\nEND'
sql_modes=524288
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_general_ci'
db_cl_names='latin1_bin'
created=1684088299489950

TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `dadosValidosTipoAlertaInsert` BEFORE INSERT ON `tipoalerta` FOR EACH ROW BEGIN\n\nSET new.Id = NULL;\n\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `dadosValidosTipoAlertaUpdate` BEFORE UPDATE ON `tipoalerta` FOR EACH ROW BEGIN\n\nSet new.Id = old.Id;\n\nEND'
sql_modes=524288 524288
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
db_cl_names='latin1_bin' 'latin1_bin'
created=1684088299468086 1684088299471460

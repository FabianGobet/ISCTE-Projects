TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `validarDadosOdor` BEFORE INSERT ON `odor` FOR EACH ROW BEGIN\n\nSET new.Id = NULL;\n\nEND'
sql_modes=524288
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_general_ci'
db_cl_names='latin1_bin'
created=1684088299407244

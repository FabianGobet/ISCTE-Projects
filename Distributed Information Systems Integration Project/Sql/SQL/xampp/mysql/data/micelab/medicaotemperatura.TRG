TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `validarDadosMedicaoTemperatura` BEFORE INSERT ON `medicaotemperatura` FOR EACH ROW BEGIN\n\nSet new.Id = NULL;\n\nEND'
sql_modes=524288
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_general_ci'
db_cl_names='latin1_bin'
created=1684088299397414

TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `validarDadosPassagem` BEFORE INSERT ON `medicaopassagem` FOR EACH ROW BEGIN\n\nSET new.IdMedicaoPassagem = NULL;\n\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `atualizarMedicaoSala` AFTER INSERT ON `medicaopassagem` FOR EACH ROW BEGIN\n\nINSERT INTO medicaosala (IdExperiencia, Sala,\nNumeroRatos) VALUES(new.IdExperiencia, new.SalaEntrada,\n1) ON DUPLICATE KEY UPDATE NumeroRatos = NumeroRatos + 1;\n\nINSERT INTO medicaosala (IdExperiencia, Sala,\nNumeroRatos) VALUES(new.IdExperiencia, new.SalaSaida, -1)\nON DUPLICATE KEY UPDATE NumeroRatos = NumeroRatos - 1;\n\nEND'
sql_modes=524288 524288
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
db_cl_names='latin1_bin' 'latin1_bin'
created=1684088299371100 1684088299366067

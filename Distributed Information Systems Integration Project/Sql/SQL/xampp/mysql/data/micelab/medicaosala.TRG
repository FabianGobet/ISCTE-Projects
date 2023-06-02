TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `alertaMedicaoSalaInsert` AFTER INSERT ON `medicaosala` FOR EACH ROW BEGIN\n\nDECLARE limite INT;\nDECLARE aviso varchar(150);\n\nSELECT e.LimiteRatosSala into limite\nFROM experiencia e\nWHERE e.Id = new.IdExperiencia;\nIF(new.NumeroRatos > limite && new.Sala<>1) THEN\nSET aviso = CONCAT(\'Experiencia \',new.IdExperiencia,\':\\r\\nNumero de ratos na sala \',new.Sala,\' excedido.\');\n\nCALL introduzirAlerta(4,new.IdExperiencia,aviso);\n\nEND IF;\n\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `alertaMedicaoSalaUpdate` AFTER UPDATE ON `medicaosala` FOR EACH ROW BEGIN\n\nDECLARE limite INT;\nDECLARE aviso varchar(150);\n\nSELECT e.LimiteRatosSala into limite\nFROM experiencia e\nWHERE e.Id = new.IdExperiencia;\nIF(new.NumeroRatos > limite && new.Sala<>1) THEN\nSET aviso = CONCAT(\'Experiencia \',new.IdExperiencia,\':\\r\\nNumero de ratos na sala \',new.Sala,\' excedido.\');\n\nCALL introduzirAlerta(4,new.IdExperiencia,aviso);\n\nEND IF;\n\nEND'
sql_modes=524288 524288
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
db_cl_names='latin1_bin' 'latin1_bin'
created=1684088299381933 1684088299386533

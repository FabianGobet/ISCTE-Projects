TYPE=VIEW
query=select `a`.`Id` AS `Id`,`a`.`IdExperiencia` AS `IdExperiencia`,`a`.`DataHora` AS `DataHora`,`ta`.`Descricao` AS `title`,`ta`.`Valor` AS `Valor`,`a`.`Descricao` AS `Descricao` from (`micelab`.`alerta` `a` join `micelab`.`tipoalerta` `ta` on(`ta`.`Id` = `a`.`IdTipoAlerta`))
md5=ca39b2348d0a12634419dd60ab008f34
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=1
with_check_option=0
timestamp=0001684088299501215
create-version=2
source=SELECT `a`.`Id` AS `Id`, `a`.`IdExperiencia` AS `IdExperiencia`, `a`.`DataHora` AS `DataHora`, `ta`.`Descricao` AS `title`, `ta`.`Valor` AS `Valor`, `a`.`Descricao` AS `Descricao` FROM (`alerta` `a` join `tipoalerta` `ta` on(`ta`.`Id` = `a`.`IdTipoAlerta`))
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_general_ci
view_body_utf8=select `a`.`Id` AS `Id`,`a`.`IdExperiencia` AS `IdExperiencia`,`a`.`DataHora` AS `DataHora`,`ta`.`Descricao` AS `title`,`ta`.`Valor` AS `Valor`,`a`.`Descricao` AS `Descricao` from (`micelab`.`alerta` `a` join `micelab`.`tipoalerta` `ta` on(`ta`.`Id` = `a`.`IdTipoAlerta`))
mariadb-version=100427

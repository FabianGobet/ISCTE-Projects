Não é possivel gerar um schedule job dentro do phpmyadmin para fazer os backups. 

A unica maneira de fazer backups usando qualquere tipo de comando é pelo statement 'mysqldump', mas
este statement só pode ser corrido via shell MySQL.

Posto isto, a solução é arranjar uma aplicação externa que faça os backups ou criar replicas.
Nós decidimos utilizar dois scrips .bat que correm mensalmente e diariamente para a estrutura e os dados, respetivamente.
Estes scrips podem ficam associados a um scheduled job que corre no Windows Scheduler.

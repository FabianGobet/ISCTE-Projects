:: pôr ./xampp/mysql/bin nas variaveis de ambiente do windows
@ECHO OFF
mysqldump --user=root --password=kr.pJ.x95# micelab_test --compact --no-data --events --routines --triggers> test_structure_%date:/=%.sql
mysqldump --user=root --password=kr.pJ.x95# micelab --compact --no-data --events --routines --triggers > structure_%date:/=%.sql
mysqldump --user=root --password=kr.pJ.x95# micelab_test --no-create-info --skip-triggers --compact --disable-keys > test_data_%date:/=%.sql
mysqldump --user=root --password=kr.pJ.x95# micelab --no-create-info --skip-triggers --compact --disable-keys > data_%date:/=%.sql





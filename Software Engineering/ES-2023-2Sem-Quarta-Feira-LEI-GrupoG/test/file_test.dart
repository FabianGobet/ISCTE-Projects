import 'package:calendar_manager/utils/conversion.dart';
import 'package:calendar_manager/utils/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io' as io;

void main() {
  test('getEventsFromURL() - test with non CSV/JSON file', () async {
    var data = await File.getEventsFromUrl(
        'https://filesamples.com/samples/document/txt/sample3.txt');
    expect(data.lstEvents.length, 0);
  });

  test('getEventsFromURL() - test with CSV file', () async {
    var data = await File.getEventsFromUrl(
        'https://raw.githubusercontent.com/dmrraiscte/ES-2023-2Sem-Quarta-Feira-LEI-GrupoG/main/assets/files/horario-exemplo.csv');
    expect(data.lstEvents.length, 26003);
  });

  test('getEventsFromURL() - test with JSON file', () async {
    var data = await File.getEventsFromUrl(
        'https://raw.githubusercontent.com/dmrraiscte/ES-2023-2Sem-Quarta-Feira-LEI-GrupoG/main/assets/files/events.json');
    expect(data.lstEvents.length, 26003);
  });

  test('getEventsFromURL() - test with bad webpage', () async {
    var data = await File.getEventsFromUrl(
        'https://github.com/dmrraiscte/ES-2023-2Sem-Quarta-Feira-LEI-GrupoG/testeBadPageErrorCode');

    expect(data.lstEvents.length, 0);
  });

  test('isJsonFormat() - correct format', () {
    String test =
        '''{ "events": [{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "02/12/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "23/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "16/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "09/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" }] }''';
    expect(File.isJsonFormat(test), true);
  });

  test('isJsonFormat() - incorrect format', () {
    String test =
        '''{ "events": [{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", sdaa,"Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "02/12/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "23/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "16/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "09/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" }] }}''';
    expect(File.isJsonFormat(test), false);
  });

  test('isCsvFormat() - correct format', () {
    String test =
        '''Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,16/11/2022,AA2.25,34''';
    expect(File.isCsvFormat(test), true);
  });

  test('isCsvFormat() - incorrect format', () {
    String test =
        '''oks,Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34,99
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,16/11/2022,AA2.25,34''';
    expect(File.isCsvFormat(test), false);
  });

  test('isICalendarFormat() - correct format', () {
    String test = '''BEGIN:VCALENDAR
PRODID:-//ISCTE-IUL//fenix//EN
VERSION:2.0
CALSCALE:GREGORIAN
X-WR-CALNAME:ffgts@iscte.pt_iscte-iul
BEGIN:VEVENT''';
    expect(File.isICalendarFormat(test), true);
  });

  test('isICalendarFormat() - incorrect format', () {
    String test =
        '''oks,Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34,99
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,16/11/2022,AA2.25,34''';
    expect(File.isICalendarFormat(test), false);
  });

  test('urlFileType() - only need "invalid" test', () {
    String test = 'Random String';
    expect(File.urlFileType(test), 'invalid');
  });

  test('saveFile() - file exists', () async {
    String temp = await File.saveFile('test', Formato.json);
    bool temp2 = await io.File(temp).exists();
    expect(temp2, true);
  });

  test('saveFile() - check name', () async {
    String name = 'name';
    String temp = await File.saveFile('test', Formato.json, name);
    String result = temp.split('/').last.split('.').first;
    expect(result, name);
  });
}

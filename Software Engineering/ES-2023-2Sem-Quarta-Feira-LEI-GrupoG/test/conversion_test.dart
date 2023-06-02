import 'package:calendar_manager/models/event_model.dart';
import 'package:calendar_manager/utils/conversion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

void main() {
  test('fromCSVToJSON - String simple CSV conversion', () {
    var value = Conversion.fromCSVToJSON(
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34""");

    expect(value.representativeString,
        """{ "events": [{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "02/12/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "23/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" }]}""");
  });

  test(
      'fromCSVToJSON - String, CSV with unimportant empty fields and quotations conversion',
      () {
    var value2 = Conversion.fromCSVToJSON(
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
LP,CompetÃªncias AcadÃ©micas I,L5205PL05,PA3,23,Qua,11:00:00,12:30:00,14/12/2022,"2,00E+07",50
"LETI, LEI, LEI-PL, LIGE, LIGE-PL",Fundamentos de Arquitectura de Computadores,L0705TP23,"ET-A9, ET-A8, ET-A7, ET-A12, ET-A11, ET-A10",44,Sex,13:00:00,14:30:00,09/12/2022,C5.06,70
"LETI, LEI, LEI-PL",CÃ¡lculo I,03703TP02,"EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1",52,Qui,14:30:00,16:00:00,15/09/2022,AA2.25,""");

    expect(value2.representativeString,
        """{ "events": [{ "Curso": "LP", "Unidade Curricular": "CompetÃªncias AcadÃ©micas I", "Turno": "L5205PL05", "Turma": "PA3", "Inscritos no turno": "23", "Dia da semana": "Qua", "Hora início da aula": "11:00:00", "Hora fim da aula": "12:30:00", "Data da aula": "14/12/2022", "Sala atribuída à aula": "2,00E+07", "Lotação da sala": "50" },
{ "Curso": "LETI, LEI, LEI-PL, LIGE, LIGE-PL", "Unidade Curricular": "Fundamentos de Arquitectura de Computadores", "Turno": "L0705TP23", "Turma": "ET-A9, ET-A8, ET-A7, ET-A12, ET-A11, ET-A10", "Inscritos no turno": "44", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "09/12/2022", "Sala atribuída à aula": "C5.06", "Lotação da sala": "70" },
{ "Curso": "LETI, LEI, LEI-PL", "Unidade Curricular": "CÃ¡lculo I", "Turno": "03703TP02", "Turma": "EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1", "Inscritos no turno": "52", "Dia da semana": "Qui", "Hora início da aula": "14:30:00", "Hora fim da aula": "16:00:00", "Data da aula": "15/09/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "" }]}""");
  });

  test('fromCSVToJSON - String, CSV with important empty fields', () {
    var value2 = Conversion.fromCSVToJSON(
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
LP,CompetÃªncias AcadÃ©micas I,L5205PL05,PA3,23,Qua,11:00:00,12:30:00,14/12/2022,"2,00E+07",50
"LETI, LEI, LEI-PL, LIGE, LIGE-PL",Fundamentos de Arquitectura de Computadores,L0705TP23,"ET-A9, ET-A8, ET-A7, ET-A12, ET-A11, ET-A10",44,Sex,13:00:00,14:30:00,09/12/2022,C5.06,70
"LETI, LEI, LEI-PL",CÃ¡lculo I,03703TP02,"EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1",52,Qui,,16:00:00,15/09/2022,AA2.25,""");

    expect(value2.representativeString,
        """{ "events": [{ "Curso": "LP", "Unidade Curricular": "CompetÃªncias AcadÃ©micas I", "Turno": "L5205PL05", "Turma": "PA3", "Inscritos no turno": "23", "Dia da semana": "Qua", "Hora início da aula": "11:00:00", "Hora fim da aula": "12:30:00", "Data da aula": "14/12/2022", "Sala atribuída à aula": "2,00E+07", "Lotação da sala": "50" },
{ "Curso": "LETI, LEI, LEI-PL, LIGE, LIGE-PL", "Unidade Curricular": "Fundamentos de Arquitectura de Computadores", "Turno": "L0705TP23", "Turma": "ET-A9, ET-A8, ET-A7, ET-A12, ET-A11, ET-A10", "Inscritos no turno": "44", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "09/12/2022", "Sala atribuída à aula": "C5.06", "Lotação da sala": "70" }]}""");
  });

  test('fromCSVToJSON - List of Events ', () {
    var value = Conversion.fromCSVToJSON(
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
"LETI, LEI, LEI-PL",CÃ¡lculo I,03703TP02,"EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1",52,Qui,14:30:00,16:00:00,15/09/2022,AA2.25,
"LETI, LEI, LEI-PL",,03703TP02,"EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1",52,Qui,14:30:00,16:00:00,15/09/2022,,""");
    expect(value.lstEvents.length, 2);
    expect(value.lstEvents[0].curso, "ME");
    expect(value.lstEvents[1].lotacaoSala, "");
    expect(value.lstEvents[1].curso, "LETI, LEI, LEI-PL");
  });
  test('fromCSVToJSON - Empty File ', () {
    var value = Conversion.fromCSVToJSON(
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala""");
    expect(value.representativeString, "{ \"events\": []}");
    expect(value.lstEvents.length, 0);
  });

  test('fromCSVToJSON - Bad event format ', () {
    var value = Conversion.fromCSVToJSON(
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
"LETI, LEI, LEI-PL",CÃ¡lculo I,03703TP02,"EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1",52,Qui,14:30:00,16:00:00,15/09/2022,AA2.25
"LETI, LEI, LEI-PL",CÃ¡lculo I,03703TP02,"EI-A6, EI-A5, EI-A4, EI-A3, EI-A2, EI-A1",52,Qui,14:30:00,,15/09/2022,,""");
    expect(value.representativeString,
        """{ "events": [{ "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "02/12/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" }]}""");
    expect(value.lstEvents.length, 1);
    expect(value.numberOfErrors, 2);
  });

  test('eventsToCsv() - test: simple comparece of String content', () async {
    var value2 = Conversion.eventsToCsv(Conversion.fromCSVToJSON(
            """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34""")
        .lstEvents);

    expect(value2, """
Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora início da aula,Hora fim da aula,Data da aula,Sala atribuída à aula,Lotação da sala
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34""");
  });

  test('eventstoCsv() - test with a empty List<Events>', () async {
    expect(Conversion.eventsToCsv(List.empty()), Event.csvHeader);
  });

  test('eventsToJson() - test: simple comparece of String content', () async {
    var value2 = Conversion.eventsToJson(Conversion.fromCSVToJSON(
            """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34""")
        .lstEvents);

    expect(value2, """
{ "events": [{ "Curso": "  ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Sex", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "02/12/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
{ "Curso": "  ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "23/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" }]}""");
  });

  test('eventstoJson() - test with a empty List<Events>', () async {
    expect(Conversion.eventsToJson(List.empty()), '{ "events": []}');
  });

  test(
      """Conversão sem caracteres especiais nos valores recebidos (sem , ou "" )""",
      () {
    var value = Conversion.fromJsonToCSV(""" {
    "events": [
        { "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "23/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
        { "Curso": "DF", "Unidade Curricular": "Investimentos II", "Turno": "01074TP01", "Turma": "DFB1", "Inscritos no turno": "3", "Dia da semana": "Seg", "Hora início da aula": "17:30:00", "Hora fim da aula": "19:00:00", "Data da aula": "21/11/2022", "Sala atribuída à aula": "D1.07", "Lotação da sala": "27" }
        ]} """);

    expect(value.representativeString,
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora início da aula,Hora fim da aula,Data da aula,Sala atribuída à aula,Lotação da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34
DF,Investimentos II,01074TP01,DFB1,3,Seg,17:30:00,19:00:00,21/11/2022,D1.07,27""");
  });

  test("Conversão com vírgulas nos valores recebidos", () {
    var value = Conversion.fromJsonToCSV(""" {
    "events": [
        {
            "Curso": "ME",
            "Unidade Curricular": "Teoria dos Jogos,dos Contratos",
            "Turno": "01789TP01",
            "Turma": "MEA1",
            "Inscritos no turno": "30",
            "Dia da semana": "Sex",
            "Hora início da aula": "13:00:00",
            "Hora fim da aula": "14:30:00",
            "Data da aula": "02/12/2022",
            "Sala atribuída à aula": "2,00E+08",
            "Lotação da sala": "34"
        }]} """);

    expect(value.representativeString,
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora início da aula,Hora fim da aula,Data da aula,Sala atribuída à aula,Lotação da sala\nME,"Teoria dos Jogos,dos Contratos",01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,"2,00E+08",34""");
  });

  test(
      """Conversão com "" num dos valores recebidos que é necessário para criar um Evento""",
      () {
    var value = Conversion.fromJsonToCSV(""" {
    "events": [
        {
            "Curso": "LEI",
            "Unidade Curricular": "",
            "Turno": "01789TP01",
            "Turma": "MEA1",
            "Inscritos no turno": "30",
            "Dia da semana": "",
            "Hora início da aula": "13:00:00",
            "Hora fim da aula": "14:30:00",
            "Data da aula": "02/12/2022",
            "Sala atribuída à aula": "2,00E+08",
            "Lotação da sala": ""
        }]} """);

    expect(value.representativeString,
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora início da aula,Hora fim da aula,Data da aula,Sala atribuída à aula,Lotação da sala""");
  });

  test(
      """Conversão com "" num dos valores recebidos que não é necessário para criar um Evento""",
      () {
    var value = Conversion.fromJsonToCSV(""" {
    "events": [
        {
            "Curso": "ME",
            "Unidade Curricular": "Teoria dos Jogos,dos Contratos",
            "Turno": "01789TP01",
            "Turma": "MEA1",
            "Inscritos no turno": "30",
            "Dia da semana": "",
            "Hora início da aula": "13:00:00",
            "Hora fim da aula": "14:30:00",
            "Data da aula": "02/12/2022",
            "Sala atribuída à aula": "2,00E+08",
            "Lotação da sala": ""
        }]} """);

    expect(value.representativeString,
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora início da aula,Hora fim da aula,Data da aula,Sala atribuída à aula,Lotação da sala
ME,"Teoria dos Jogos,dos Contratos",01789TP01,MEA1,30,,13:00:00,14:30:00,02/12/2022,"2,00E+08",""");
  });

  test("Conversão sem objetos no ficheiro", () {
    var value = Conversion.fromJsonToCSV(""" {
    "events": []} """);

    expect(value.representativeString,
        """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora início da aula,Hora fim da aula,Data da aula,Sala atribuída à aula,Lotação da sala\n""");
    expect(value.lstEvents.length, 0);
  });

  test("Verificação dos Eventos criados", () {
    var value = Conversion.fromJsonToCSV("""{
    "events": [{ "Curso": "MGSS", "Unidade Curricular": "GestÃ£o de OperaÃ§Ãµes e Sistema LogÃ­stico", "Turno": "03475TP01", "Turma": "MGSSA1", "Inscritos no turno": "43", "Dia da semana": "Sex", "Hora início da aula": "09:30:00", "Hora fim da aula": "11:00:00", "Data da aula": "16/09/2022", "Sala atribuída à aula": "AA3.23", "Lotação da sala":"" },
{ "Curso": "LEI, LEI-PL", "Unidade Curricular": "Agentes AutÃ³nomos", "Turno": "03727T01", "Turma": "EI-PL-C2, EI-PL-C1", "Inscritos no turno": "51", "Dia da semana": "Seg", "Hora início da aula": "21:00:00", "Hora fim da aula": "22:30:00", "Data da aula": "05/12/2022", "Sala atribuída à aula": "C5.08", "Lotação da sala": "58" } ]}""");

    expect(value.lstEvents[0].lotacaoSala, "");
    expect(value.lstEvents[1].curso, "LEI, LEI-PL");
    expect(value.lstEvents[1].diaDaSemana, "Seg");
  });

  test("icdToEvent and icdToEventList - good input", () {
    String ics = r'''BEGIN:VCALENDAR
PRODID:-//ISCTE-IUL//fenix//EN
VERSION:2.0
CALSCALE:GREGORIAN
X-WR-CALNAME:ffgts@iscte.pt_iscte-iul
BEGIN:VEVENT
DTSTAMP:20230424T200358Z
DTSTART:20220913T133000Z
DTEND:20220913T150000Z
SUMMARY:Programação Concorrente e Distribuída - Concurrent and Parallel P
 rogramming
UID:847676220398161@fenix.iscte.pt
DESCRIPTION:Semestre: 2022/2023 - 1.º Semestre\nUnidade de execução: Prog
 ramação Concorrente e Distribuída\nCódigo: L5096\nTurno: L5096TP04\nIníc
 io: 2022-09-13 14:30\nFim: 2022-09-13 16:00\nDocente: Luís Henrique Rami
 lo Mota\n\nSemester: 2022/2023 - 1.º Semestre\nExecution course: Concurr
 ent and Parallel Programming\nCode: L5096\nShift: L5096TP04\nBegin: 2022
 -09-13 14:30\nEnd: 2022-09-13 16:00\nTeacher: Luís Henrique Ramilo Mota\
 n\n
LOCATION:0S01\, 0\, Edifício Sedas Nunes (ISCTE-IUL)\, ISCTE-IUL
END:VEVENT
END:VCALENDAR''';
    expect(
        Conversion.icdToEvent(ICalendar.fromString(ics).data.first).toString(),
        'EVENT[curso: , dataAula: 2022-09-13, diaDaSemana: , horaFimAula: 16:00, horaInicioAula: 14:30, inscritosNoTurno: , lotacaoSala: , salaAtribuidaAAula: 0S01, turma: , turno: L5096TP04, unidadeCurricular: Programação Concorrente e Distribuída]');

    var temp = Conversion.icsToEventList(ics);
    expect(temp.representativeString.length, 0);
    expect(temp.lstEvents.length, 1);
  });

  test("icdToEvent - bad input", () {
    String ics = r'''BEGIN:VCALENDAR
PRODID:-//ISCTE-IUL//fenix//EN
VERSION:2.0
CALSCALE:GREGORIAN
X-WR-CALNAME:ffgts@iscte.pt_iscte-iul
BsdEGIN:VEVENT
DTSTAMP:20230424T200358Z
DTSTART:20220913T133000Z
DTEND:20220913T150000Z
SUMMARY:Programação Concorrente e Distribuída - Concurrent and Parallel P
 rogramming
UID:847676220398161@fenix.iscte.pt
DESCRsIPTION:Semestre: 2022/2023 - 1.º Semestre\nUnidade de execução: Prog
 ramação Concorrente e Distribuída\nCódigo: L5096\nTurno: L5096TP04\nIníc
 io: 2022-09-13 14:30\nFim: 2022-09-13 16:00\nDocente: Luís Henrique Rami
 lo Mota\n\,Semester: 2022/2023 - 1.º Semestre\nExecution course: Concurr
 ent and Parallel Programming\nCode: L5096\nShift: L5096TP04\nBegin: 2022
 -09-13 14:30\nEnd: 202,2-09-13 16:00\nTeacher:, Luís Henrique Ramilo Mota\
 n\n
LOCA  qTION:0S01\, 0\, Edifício Sedas Nunes (ISCTE-IUL)\, ISCTE-IUL
END:VEVENT
END:VCALENDAR''';
    expect(
        Conversion.icdToEvent(ICalendar.fromString(ics).data.first).toString(),
        'Null');
    var temp = Conversion.icsToEventList(ics);
    expect(temp.lstEvents.length, 0);
    expect(temp.numberOfErrors, 1);
  });

  test("Verificação da contagem de eventos não criados por erros de sintax",
      () {
    var value = Conversion.fromJsonToCSV("""{
    "events": [{ "Curso": "MGSS", "Unidade Curricular": "GestÃ£o de OperaÃ§Ãµes e Sistema LogÃ­stico", "Turno": "03475TP01", "Turma": "MGSSA1", "Inscritos no turno": "43", "Dia da semana": "Sex", "Hora início da aula": "09:30:00", "Hora fim da aula": "11:00:00", "Data da aula": "16/09/2022", "Sala atribuída à aula": "AA3.23", "Lotação da sala":"" },
{ "Curso": "LEI", "Unidade Curricular": "Agentes AutÃ³nomos", "Turno": "", "Turma": "EI-PL-C2, EI-PL-C1", "Inscritos no turno": "51", "Dia da semana": "Seg", "Hora início da aula": "21:00:00", "Hora fim da aula": "22:30:00", "Data da aula": "05/12/2022", "Sala atribuída à aula": "C5.08", "Lotação da sala": "53" } ]}""");

    expect(value.numberOfErrors, 1);
  });
}

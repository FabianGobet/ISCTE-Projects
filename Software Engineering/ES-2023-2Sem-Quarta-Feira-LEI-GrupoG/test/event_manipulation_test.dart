import 'package:calendar_manager/utils/event_manipulation.dart';
import 'package:calendar_manager/utils/conversion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("eventListSegmentation - Map creation from Event List ", () {
    var eventList = Conversion.fromCSVToJSON(
            """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Seg,13:00:00,14:30:00,05/12/2022,AA2.25,34
LFC,Reporte Financeiro,M8642TP01,FCC2,35,Qua,11:00:00,12:30:00,07/12/2022,C5,52
LFC,Reporte Financeiro,M8642TP02,FCC2,35,Qua,11:00:00,12:30:00,30/11/2022,C4.06,68
LFC,Reporte Financeiro,M8642TP03,FCC2,35,Qua,11:00:00,12:30:00,23/11/2022,C4.06,68
MG,Contabilidade AvanÃ§ada,M8488TP01,MGA2,47,Seg,11:00:00,12:30:00,10/10/2022,B2.02,60""")
        .lstEvents;

    var map = EventManipulation.eventListSegmentation(eventList);

    expect(map.length, 3);

    expect(map["Teoria dos Jogos e dos Contratos"].length, 1);
    expect(map["Teoria dos Jogos e dos Contratos"]["01789TP01"].length, 2);

    expect(map["Reporte Financeiro"].length, 3);
  });

  test("getEventListFromMap - Get events from map", () {
    var eventList = Conversion.fromCSVToJSON(
            """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
LFC,Reporte Financeiro,M8642TP01,FCC2,35,Qua,11:00:00,12:30:00,07/12/2022,C5,52
LFC,Reporte Financeiro,M8642TP02,FCC2,35,Qua,11:00:00,12:30:00,30/11/2022,C4.06,68
LFC,Reporte Financeiro,M8642TP03,FCC2,35,Qua,11:00:00,12:30:00,23/11/2022,C4.06,68
MG,Contabilidade AvanÃ§ada,M8488TP01,MGA2,47,Seg,11:00:00,12:30:00,10/10/2022,B2.02,60""")
        .lstEvents;

    var map = EventManipulation.eventListSegmentation(eventList);

    expect(
        EventManipulation.getEventListFromMap(
            map, "Contabilidade AvanÃ§ada", "M8488TP01")[0],
        eventList[3]);

    expect(
        EventManipulation.getEventListFromMap(map, "Reporte Financeiro").length,
        3);
  });
}

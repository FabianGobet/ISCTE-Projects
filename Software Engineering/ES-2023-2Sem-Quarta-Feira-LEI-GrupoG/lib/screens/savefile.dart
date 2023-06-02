import 'package:flutter/material.dart';
import '../utils/conversion.dart';
import '../utils/file.dart';

class SaveFile extends StatefulWidget {
  const SaveFile({super.key});

  @override
  State<SaveFile> createState() => _SaveFileState();
}

class _SaveFileState extends State<SaveFile> {
  var value = Conversion.fromJsonToCSV(""" {
    "events": [
        { "Curso": "ME", "Unidade Curricular": "Teoria dos Jogos e dos Contratos", "Turno": "01789TP01", "Turma": "MEA1", "Inscritos no turno": "30", "Dia da semana": "Qua", "Hora início da aula": "13:00:00", "Hora fim da aula": "14:30:00", "Data da aula": "23/11/2022", "Sala atribuída à aula": "AA2.25", "Lotação da sala": "34" },
        { "Curso": "DF", "Unidade Curricular": "Investimentos II", "Turno": "01074TP01", "Turma": "DFB1", "Inscritos no turno": "3", "Dia da semana": "Seg", "Hora início da aula": "17:30:00", "Hora fim da aula": "19:00:00", "Data da aula": "21/11/2022", "Sala atribuída à aula": "D1.07", "Lotação da sala": "27" }
        ]} """);

  var value2 = Conversion.fromCSVToJSON(
      """Curso,Unidade Curricular,Turno,Turma,Inscritos no turno,Dia da semana,Hora inÃ­cio da aula,Hora fim da aula,Data da aula,Sala atribuÃ­da Ã  aula,LotaÃ§Ã£o da sala
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Sex,13:00:00,14:30:00,02/12/2022,AA2.25,34
  ME,Teoria dos Jogos e dos Contratos,01789TP01,MEA1,30,Qua,13:00:00,14:30:00,23/11/2022,AA2.25,34""");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  var txt = Conversion.eventsToJson(value2.lstEvents);
                  File.alert(context, 0);
                  File.saveFile(txt, Formato.json);
                },
                child: const Text('JSON')),
            TextButton(
                onPressed: () {
                  var txt = Conversion.eventsToCsv(value2.lstEvents);
                  File.alert(context, 3);
                  File.saveFile(txt, Formato.csv, 'joaoCalendario');
                },
                child: const Text('CSV'))
          ],
        ),
      ),
    );
  }
}

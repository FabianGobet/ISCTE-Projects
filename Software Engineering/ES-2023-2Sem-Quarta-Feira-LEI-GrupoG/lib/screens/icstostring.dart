import 'package:flutter/material.dart';

import '../utils/conversion.dart';

class IcsToString extends StatefulWidget {
  const IcsToString({super.key});

  @override
  State<IcsToString> createState() => _IcsToStringState();
}

class _IcsToStringState extends State<IcsToString> {
  final TextEditingController _input = TextEditingController();
  final TextEditingController _output = TextEditingController();

  @override
  void initState() {
    super.initState();
    _input.text = testString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ICS to String testing'),
      ),
      body: Center(
          child: Column(
        children: [
          Flexible(
              flex: 8,
              child: TextField(
                minLines: 30,
                maxLines: 35,
                decoration: borderDecoration(),
                controller: _input,
                onChanged: (text) {
                  _input.text = text;
                },
              )),
          Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsetsDirectional.symmetric(vertical: 5),
                child: ElevatedButton(
                    onPressed: () {
                      var data = Conversion.icsToEventList(_input.text);
                      _output.text =
                          'DATA:\n${data.lstEvents.map((e) => e.toString()).join('\n')}\n\n#MissingData:\n${data.numberOfErrors}';
                    },
                    child: const Text('Test')),
              )),
          Flexible(
              flex: 8,
              child: TextField(
                minLines: 30,
                maxLines: 35,
                decoration: borderDecoration(),
                controller: _output,
              )),
        ],
      )),
    );
  }

  InputDecoration borderDecoration() {
    return const InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.black)));
  }

  String testString = r'''BEGIN:VCALENDAR
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
 -09-13 14:30\nEnd: 2022-09-13 16:00\nTeacher: Luís Henrique Ramilo Mota
 n\n
LOCATION:0S01, 0, Edifício Sedas Nunes (ISCTE-IUL), ISCTE-IUL
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20230424T200358Z
DTSTART:20221206T093000Z
DTEND:20221206T110000Z
SUMMARY:Programação Concorrente e Distribuída - Concurrent and Parallel P
 rogramming
UID:1130336608060793@fenix.iscte.pt
DESCRIPTION:Semestre: 2022/2023 - 1.º Semestre\nUnidade de execução: Prog
 ramação Concorrente e Distribuída\nCódigo: L5096\nTurno: L5096TP04\nIníc
 io: 2022-12-06 09:30\nFim: 2022-12-06 11:00\nDocente: Luís Henrique Rami
 lo Mota\n\nSemester: 2022/2023 - 1.º Semestre\nExecution course: Concurr
 ent and Parallel Programming\nCode: L5096\nShift: L5096TP04\nBegin: 2022
 -12-06 09:30\nEnd: 2022-12-06 11:00\nTeacher: Luís Henrique Ramilo Mota
 n\n
LOCATION:D1.05, 1, Edifício II (ISCTE-IUL), ISCTE-IUL
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20230424T200358Z
DTSTART:20230316T143000Z
DTEND:20230316T160000Z
SUMMARY:Interacção Pessoa-Máquina - Human-Computer Interaction
UID:847676220417074@fenix.iscte.pt
DESCRIPTION:Semestre: 2022/2023 - 2.º Semestre\nUnidade de execução: Inte
 racção Pessoa-Máquina\nCódigo: L5316\nTurno: L5316TP05\nInício: 2023-03-
 16 14:30\nFim: 2023-03-16 16:00\nDocente: Pedro Figueiredo Santana\n\nSe
 mester: 2022/2023 - 2.º Semestre\nExecution course: Human-Computer Inter
 action\nCode: L5316\nShift: L5316TP05\nBegin: 2023-03-16 14:30\nEnd: 202
 3-03-16 16:00\nTeacher: Pedro Figueiredo Santana\n\n
LOCATION:C5.07, 5, Edifício II (ISCTE-IUL), ISCTE-IUL
END:VEVENT
END:VCALENDAR
''';
}

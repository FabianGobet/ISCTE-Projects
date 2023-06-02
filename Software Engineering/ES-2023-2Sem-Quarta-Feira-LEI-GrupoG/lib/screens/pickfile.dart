import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/file.dart';

class PickFile extends StatefulWidget {
  const PickFile({super.key});

  @override
  State<PickFile> createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  var myText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick file"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(myText),
            ElevatedButton.icon(
                onPressed: () async {
                  var data = await File.getEventsFromFile();
                  setState(() {
                    myText =
                        "Encontrados ${data.lstEvents.toString()} no ficheiro\nErros: ${data.numberOfErrors}";
                  });
                },
                icon: const Icon(CupertinoIcons.tray_arrow_down_fill),
                label: const Text("Escolher ficheiro")),
          ],
        ),
      ),
    );
  }
}

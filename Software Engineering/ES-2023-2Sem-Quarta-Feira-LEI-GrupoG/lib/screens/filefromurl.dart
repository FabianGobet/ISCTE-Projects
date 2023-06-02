import 'package:flutter/material.dart';
import '../utils/file.dart';

class FileFromUrl extends StatefulWidget {
  const FileFromUrl({super.key});

  @override
  State<FileFromUrl> createState() => _FileFromUrlState();
}

class _FileFromUrlState extends State<FileFromUrl> {
  var inputText = "";
  var outputText = "Start Flag";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text =
        'webcal://fenix.iscte-iul.pt/publico/publicPersonICalendar.do?method=iCalendar&username=ffgts@iscte.pt&password=SX4v4d8ydbeslYCCIgm4AyX34eKv7rM8znluCsj1EShymYzeRoEyLKY1fTs0A0IXlcG7xOnUyErtqIdC0DaATwh07UqvoVBmHcWD5lkVpleosKcBSs0yqxqyfEAn08UE';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('testing'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                onChanged: (text) {
                  setState(() {
                    inputText = text;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'URL',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  var data = await File.getEventsFromUrl(_controller.text);
                  //var result = lista.map((e) => e.toString()).join('\n');
                  var result = data.lstEvents;
                  setState(() {
                    outputText = result.isEmpty
                        ? 'Vazio'
                        : result.map((e) => e.toString()).join("\n");
                  });
                },
                child: const Text('Submit'),
              ),
              Text(outputText)
            ],
          ),
        ),
      ),
    );
  }
}

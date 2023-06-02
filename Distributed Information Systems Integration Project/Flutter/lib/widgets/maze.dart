import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/config.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class Maze extends StatefulWidget {
  final String idExp;
  const Maze({Key? key, required this.idExp}) : super(key: key);

  @override
  State<Maze> createState() => _MazeState();
}

class _MazeState extends State<Maze> {
  var tempData = <dynamic>[];
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getMaze());
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var i in List.generate(tempData.length, (index) => index))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width / 3 - 8 * 2,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Sala ${tempData[i]["Sala"]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    (tempData[i]["NumeroRatos"]).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ],
              )),
            ),
          ),
      ],
    );
  }

  Future<void> getMaze() async {
    String getTempUrl =
        "http://${sharedPreferences!.getString(Constants.shpIp)!}:${sharedPreferences!.getString(Constants.shpPort)!}/PISID_Sql/htdocs/scripts/app_GetRoomRats.php";
    try {
      var response = await http.post(Uri.parse(getTempUrl), body: {
        'username': sharedPreferences!.getString(Constants.shpUser)!,
        'password': sharedPreferences!.getString(Constants.shpPass)!,
        'idExperience': widget.idExp
      });

      if (response.statusCode == 200) {
        var newbody = jsonDecode(response.body);
        if (tempData != newbody) {
          setState(() {
            tempData = jsonDecode(response.body);
          });
        }
      }
    } catch (e) {}
  }
}

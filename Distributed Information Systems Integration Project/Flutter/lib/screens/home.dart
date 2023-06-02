import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pisid/main.dart';
import 'package:pisid/screens/experience_detail.dart';
import 'package:pisid/utils/config.dart';

import 'package:http/http.dart' as http;
import 'package:pisid/utils/constants.dart';
import 'package:pisid/utils/extensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Olá, ${sharedPreferences!.getString(Constants.shpUser)!.capitalize()}"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: const Icon(CupertinoIcons.refresh),
                onTap: () {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: const Icon(CupertinoIcons.square_arrow_left),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                  sharedPreferences!.remove(Constants.shpUser);
                  sharedPreferences!.remove(Constants.shpPass);
                  sharedPreferences!.remove(Constants.shpIp);
                  sharedPreferences!.remove(Constants.shpPort);
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
            future: getExperiences(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var elem in snapshot.data!)
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExperienceDetail(
                                        idExp: elem["Id"],
                                      )),
                            );

                            setState(() {});
                          },
                          child: Card(
                            color: elem["DataHoraFim"] != null
                                ? Colors.red.shade100
                                : Theme.of(context).cardColor,
                            child: ListTile(
                              title: Text(
                                elem["Descricao"].toString().capitalize(),
                              ),
                              subtitle: Text(elem["DataHoraFim"] != null
                                  ? "Finalizada em ${elem["DataHoraFim"].toString().formatToDate().toPatternString()}"
                                  : "A iniciar em ${elem["DataHoraInicio"].toString().formatToDate().toPatternString()}"),
                              leading: Text(
                                elem["Id"],
                                style: const TextStyle(fontSize: 36),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            }));
  }

  Future<List<dynamic>> getExperiences() async {
    String getTempUrl =
        "http://${sharedPreferences!.getString(Constants.shpIp)!}:${sharedPreferences!.getString(Constants.shpPort)!}/PISID_Sql/htdocs/scripts/app_GetExperiencesByUser.php";
    try {
      var response = await http.post(Uri.parse(getTempUrl), body: {
        'username': sharedPreferences!.getString(Constants.shpUser)!,
        'password': sharedPreferences!.getString(Constants.shpPass)!
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {}
    return [];
  }
}

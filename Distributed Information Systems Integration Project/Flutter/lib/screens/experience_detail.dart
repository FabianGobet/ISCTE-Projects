import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pisid/utils/config.dart';
import 'package:pisid/utils/constants.dart';
import 'package:pisid/widgets/maze.dart';
import 'package:pisid/widgets/temp.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

class ExperienceDetail extends StatefulWidget {
  final String idExp;
  const ExperienceDetail({Key? key, required this.idExp}) : super(key: key);

  @override
  State<ExperienceDetail> createState() => _ExperienceDetailState();
}

class _ExperienceDetailState extends State<ExperienceDetail> {
  List<dynamic> alerts = [];
  var checkedAlerts = 0;
  Timer? timer;

  @override
  void initState() {
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => getAlerts());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                checkedAlerts = alerts.length;
              });
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        children: [
                          for (var alert in alerts)
                            ListTile(
                              title: Text(alert["title"]),
                              subtitle: Text(alert["Descricao"]),
                              isThreeLine: true,
                            )
                        ],
                      ),
                    );
                  });
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                child: badges.Badge(
                  showBadge: checkedAlerts != alerts.length,
                  badgeContent:
                      Text((alerts.length - checkedAlerts).toString()),
                  child: const Icon(
                    CupertinoIcons.bell_fill,
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              finishExperience();
            },
            child: const Icon(
              CupertinoIcons.square_fill,
            ),
          ),
          const Padding(padding: EdgeInsets.all(8))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36.0),
        child: Column(
          children: [
            Temp(
              idExp: widget.idExp,
            ),
            Expanded(child: Container()),
            Maze(
              idExp: widget.idExp,
            ),
          ],
        ),
      ),
    );
  }

  void getAlerts() async {
    String getTempUrl =
        "http://${sharedPreferences!.getString(Constants.shpIp)!}:${sharedPreferences!.getString(Constants.shpPort)!}/PISID_Sql/htdocs/scripts/app_GetAlerts.php";
    try {
      var response = await http.post(Uri.parse(getTempUrl), body: {
        'username': sharedPreferences!.getString(Constants.shpUser)!,
        'password': sharedPreferences!.getString(Constants.shpPass)!,
        'idExperience': widget.idExp
      });

      if (response.statusCode == 200) {
        var temp = jsonDecode(response.body);
        if (alerts.length != temp.length) {
          setState(() {
            alerts = temp;
          });
        }
      }
    } catch (e) {}
  }

  void finishExperience() async {
    String getTempUrl =
        "http://${sharedPreferences!.getString(Constants.shpIp)!}:${sharedPreferences!.getString(Constants.shpPort)!}/PISID_Sql/htdocs/scripts/app_EndExperience.php";
    try {
      var response = await http.post(Uri.parse(getTempUrl), body: {
        'username': sharedPreferences!.getString(Constants.shpUser)!,
        'password': sharedPreferences!.getString(Constants.shpPass)!,
        'idExperience': widget.idExp
      });

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.up,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Sucesso!',
            message: 'Experiência finalizada com sucesso!',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {}
  }
}

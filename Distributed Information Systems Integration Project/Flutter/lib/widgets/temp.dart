import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pisid/utils/config.dart';
import 'package:pisid/utils/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Temp extends StatefulWidget {
  final String idExp;
  const Temp({Key? key, required this.idExp}) : super(key: key);

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  var tempData = <dynamic>[];
  Timer? timer;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getTemp());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: "Temperaturas"),
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(color: Colors.transparent)),
        series: _getDefaultLineSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<LineSeries<dynamic, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<dynamic, DateTime>>[
      for (var sensorId in tempData.map((e) => e["Sensor"]).toSet())
        LineSeries<dynamic, DateTime>(
            animationDuration: 2500,
            dataSource: tempData.where((w) {
              return w["Sensor"] == sensorId;
            }).toList(),
            xValueMapper: (dynamic temp, _) =>
                (DateFormat("yyyy-MM-dd HH:mm:ss").parse(temp["DataHora"])),
            yValueMapper: (dynamic temp, _) => double.parse(temp["Leitura"]),
            width: 2,
            name: 'Sensor $sensorId',
            markerSettings: const MarkerSettings(isVisible: true)),
    ];
  }

  Future<void> getTemp() async {
    String getTempUrl =
        "http://${sharedPreferences!.getString(Constants.shpIp)!}:${sharedPreferences!.getString(Constants.shpPort)!}/PISID_Sql/htdocs/scripts/app_GetTemp.php";
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

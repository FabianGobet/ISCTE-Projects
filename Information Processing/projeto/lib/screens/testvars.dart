import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projeto/auxiliar/calculus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Testvars extends StatefulWidget {
  const Testvars({super.key});

  @override
  State<Testvars> createState() => _Testvars();
}

class _Testvars extends State<Testvars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Variables test"),
        ),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: corpo()),
        ));
  }

  Widget rowCol(List<Widget> children) {
    if (MediaQuery.of(context).size.width >
        MediaQuery.of(context).size.height) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,
    );
  }

  SizedBox getPlot(String name, Function func) {
    DataBlock data = DataBlock();
    int numberElements = 1000;
    for (int i = 0; i < numberElements; i++) {
      data.addElement(func());
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width / 5,
      height: MediaQuery.of(context).size.width / 5,
      child: SfCartesianChart(
        title: ChartTitle(
            text: name, textStyle: const TextStyle(color: Colors.white)),
        series: <ChartSeries>[
          HistogramSeries<double, double>(
              dataSource: data.getData(),
              yValueMapper: (double element, _) => element)
        ],
      ),
    );
  }

  Widget corpo() {
    Duration del = 500.ms;
    Duration dur = 500.ms;
    List<SizedBox> graficos = [
      getPlot("Sleep Hours", Calculus.sleepHours),
      getPlot("Meditation", Calculus.meditation),
      getPlot("Core Circle", Calculus.coreCircle),
      getPlot("Flow State", Calculus.flowState),
      getPlot("Time for Passion", Calculus.timeForPassion),
      getPlot("Social Network", Calculus.socialNetwork),
      getPlot("Class of Age", Calculus.classOfAge),
      getPlot("Class of Steps", Calculus.classOfSteps),
    ];

    List<Animate> toShow = [];

    for (int i = 0; i < graficos.length; i++) {
      toShow.add(graficos[i].animate().flip(duration: dur, delay: del * i));
    }

    return Wrap(children: toShow);
  }
}

class DataBlock {
  List<double> data = [];

  void addElement(double ele) {
    data.add(ele);
  }

  double sumOfElements() {
    double sum = 0;
    for (double ele in data) {
      sum += ele;
    }
    return sum;
  }

  List<double> getData() {
    return data;
  }
}

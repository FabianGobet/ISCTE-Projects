import 'package:flutter/material.dart';

import '../auxiliar/calculus.dart';
import '../auxiliar/model.dart';
import '../auxiliar/person.dart';

class Evaluation extends StatefulWidget {
  final List<Person> persons;
  final double initialProductivity;
  const Evaluation(
      {super.key, required this.persons, required this.initialProductivity});

  @override
  State<Evaluation> createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  //IMPORTANTE: IDADE NÃO É MUTAVEL
  var values = [
    Model("Daily Steps", -10, 10, 0, "ds", 0, 0),
    Model("Sleep Hours", -10, 10, 0, "sh", 0, 0),
    Model("Core Circle", -10, 10, 0, "cc", 0, 0),
    Model("Flow State", -10, 10, 0, "fs", 0, 0),
    Model("Time For Passion", -10, 10, 0, "tp", 0, 0),
    Model("Social Network", -10, 10, 0, "sn", 0, 0)
  ];

  var productivity = 0.0;

  @override
  void initState() {
    productivity = widget.initialProductivity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Results & Modelation"),
        ),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: corpo()),
        ));
  }

  void alterValues(Model ele) {
    switch (ele.id) {
      case "ds":
        for (Person p in widget.persons) {
          p.classOfSteps += ele.value.toInt() - ele.oldValue.toInt();
        }
        break;
      case "sh":
        for (Person p in widget.persons) {
          p.sleepHours += ele.value - ele.oldValue;
        }
        break;
      case "cc":
        for (Person p in widget.persons) {
          p.coreCircle += ele.value.toInt() - ele.oldValue.toInt();
        }
        break;
      case "fs":
        for (Person p in widget.persons) {
          p.flowState += ele.value.toInt() - ele.oldValue.toInt();
        }
        break;
      case "tp":
        for (Person p in widget.persons) {
          p.timeForPassion += ele.value - ele.oldValue;
        }
        break;
      case "sn":
        for (Person p in widget.persons) {
          p.socialNetwork += ele.value - ele.oldValue;
        }
        break;
    }
    ele.oldValue = ele.value;
  }

  IntrinsicWidth manipulos() {
    return IntrinsicWidth(
      child: Column(
        children: [
          for (var ele in values)
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    ele.label,
                  ),
                ),
                Expanded(child: Container()),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ele.value = ele.initialValue;
                        alterValues(ele);
                        productivity =
                            Calculus.groupProductivityAverage(widget.persons);
                      });
                    },
                    child: const Text("Reset")),
                Slider(
                    divisions: (ele.max - ele.min) as int,
                    min: ele.min,
                    max: ele.max,
                    value: ele.value,
                    onChanged: (slideValue) {
                      setState(() {
                        ele.value = slideValue;
                        alterValues(ele);
                        productivity =
                            Calculus.groupProductivityAverage(widget.persons);
                      });
                    }),
                Expanded(child: Container()),
                Text(
                    "${ele.value > ele.initialValue ? "+" : ""} ${ele.value - ele.initialValue}",
                    style: TextStyle(
                        color: (ele.value < ele.initialValue
                            ? Colors.red
                            : ele.value > ele.initialValue
                                ? Colors.blue
                                : Colors.white),
                        fontSize: 12))
              ],
            )
        ],
      ),
    );
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

  Widget corpo() {
    return rowCol([
      manipulos(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 30),
            child: Text(
              "Population Size: ${widget.persons.length}",
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const Text(
            "Productivity Average % :",
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8),
            child: Text(
              "${productivity.toStringAsFixed(2)} %",
              style: TextStyle(
                  fontSize: 15,
                  color: (widget.initialProductivity > productivity
                      ? Colors.red
                      : widget.initialProductivity < productivity
                          ? Colors.green
                          : Colors.white)),
            ),
          )
        ],
      ),
    ]);
  }
}

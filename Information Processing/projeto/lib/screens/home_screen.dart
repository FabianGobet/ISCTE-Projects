import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projeto/screens/evaluation.dart';
import 'package:projeto/screens/testvars.dart';

import '../auxiliar/calculus.dart';
import '../auxiliar/person.dart';
import '../utils/extesions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var txtController = TextEditingController();

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    const int popLimit = 10000;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Image.asset(
                "assets/projetopi.png",
                scale: 1,
              ),
            ),
            Expanded(child: Container()),
            const Expanded(
                flex: 2, child: Text("Productivity parameterized modelation")),
          ],
        ),
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    const Text(
                      "Insert population Size",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                        .animate()
                        .fadeIn(duration: 750.ms)
                        .moveY(duration: 950.ms, begin: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width <
                              MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width / 5,
                      child: TextFormField(
                        controller: txtController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LimitRangeTextInputFormatter(1, popLimit)
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black))),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (!isNumeric(value)) return "Numero invalido.";
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width <
                              MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width / 6,
                      child: ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () {
                            var numPerson = int.parse(txtController.text);
                            List<Person> lst = [];
                            for (var i = 0; i < numPerson; i++) {
                              lst.add(Person());
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Evaluation(
                                    persons: lst,
                                    initialProductivity:
                                        Calculus.groupProductivityAverage(lst)),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(CupertinoIcons.function),
                              ),
                              Text("Evaluate")
                            ],
                          )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width <
                              MediaQuery.of(context).size.height
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.width / 6,
                      child: ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Testvars(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(CupertinoIcons.graph_circle_fill),
                              ),
                              Text("Test Variables")
                            ],
                          )),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

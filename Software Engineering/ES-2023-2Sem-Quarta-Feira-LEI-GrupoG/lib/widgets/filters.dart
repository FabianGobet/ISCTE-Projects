import 'package:calendar_manager/models/event_model.dart';
import 'package:calendar_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Filters extends StatefulWidget {
  final List<Event> eventsLst;
  final Function(List<Event>)? onFilterChangedList;
  const Filters({super.key, required this.eventsLst, this.onFilterChangedList});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  var tempLst = <Event>[];
  var mapEvents = <String, Map<String, List<Event>>>{};

  var selectedUcs = <String>[];
  var selectedTurnos = <String, List<String>>{};
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tempLst != widget.eventsLst) {
      updateMapValue();
    }
    tempLst = widget.eventsLst;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Utils.getSidePadding(context), vertical: 8),
      child: GFAccordion(
        collapsedIcon: mapEvents.isEmpty
            ? const Icon(Icons.filter_alt)
            : const Icon(Icons.filter_alt)
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1.7, 1.7),
                    duration: const Duration(milliseconds: 1000)),
        expandedIcon: mapEvents.isEmpty
            ? const Icon(Icons.filter_alt_outlined)
            : const Icon(Icons.filter_alt_outlined)
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1.7, 1.7),
                    duration: const Duration(milliseconds: 1000)),
        collapsedTitleBackgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        expandedTitleBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentChild: mapEvents.isEmpty
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MultiSelectDialogField<String>(
                      selectedColor: Theme.of(context).primaryColor,
                      chipDisplay: MultiSelectChipDisplay.none(),
                      buttonText: Text(selectedUcs.isEmpty
                          ? "Selecionar Unidades Curriculares"
                          : selectedUcs.length == 1 ||
                                  selectedUcs.length == 2 ||
                                  selectedUcs.length == 3
                              ? selectedUcs.join(", ")
                              : "${selectedUcs.length} UC's selecionadas"),
                      listType: MultiSelectListType.LIST,
                      searchable: true,
                      items: mapEvents.keys
                          .map((e) => MultiSelectItem<String>(e, e))
                          .toList(),
                      title: const Text("Unidades curriculares"),
                      onConfirm: (selectedLst) {
                        setState(() {
                          selectedUcs = selectedLst;
                        });
                        callback();
                      },
                    ),
                    for (var uc in selectedUcs)
                      Flexible(
                        fit: FlexFit.loose,
                        child: GFAccordion(
                            title: uc,
                            collapsedTitleBackgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            expandedTitleBackgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            contentBackgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            contentChild: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: mapEvents[uc]!.keys.map((turno) {
                                  if (!selectedTurnos.keys
                                      .toList()
                                      .contains(uc)) {
                                    selectedTurnos[uc] = <String>[];
                                  }

                                  var isThisSelected =
                                      selectedTurnos[uc]!.contains(turno);
                                  if (turno == "exam") return Container();
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isThisSelected) {
                                            selectedTurnos[uc]!.remove(turno);
                                          } else {
                                            selectedTurnos[uc]!.add(turno);
                                          }
                                        });

                                        callback();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            color: isThisSelected
                                                ? Theme.of(context).primaryColor
                                                : Colors.transparent,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              turno,
                                              style: TextStyle(
                                                  color: isThisSelected
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  /// Used when a new list is provided into the widget
  /// It clears our local variables and rebuilds or map with the follwoing structure:
  /// Unidade Curricular - [Turnos] - [Events that are from that UC and turno]
  Future<void> updateMapValue() async {
    if (widget.eventsLst.isNotEmpty) {
      selectedUcs = [];
      selectedTurnos = <String, List<String>>{};
      mapEvents = <String, Map<String, List<Event>>>{};

      for (var uc in widget.eventsLst
          .map((e) => e.unidadeCurricular)
          .toSet()
          .toList()) {
        Map<String, List<Event>> turnoMap = {};
        for (var turno in widget.eventsLst
            .where((e) => e.unidadeCurricular == uc && !e.isTestOrExam())
            .map((e) => e.turno)
            .toSet()
            .toList()) {
          turnoMap.addAll({
            turno: widget.eventsLst
                .where((e) => e.unidadeCurricular == uc && e.turno == turno)
                .toSet()
                .toList()
          });
        }
        turnoMap.addAll({
          "exam": widget.eventsLst
              .where((e) => e.unidadeCurricular == uc && e.isTestOrExam())
              .toList()
        });
        mapEvents.addAll({uc: turnoMap});
      }
    }
  }

  ///This function calls the function that was passed through parameters into this widget
  ///It first validates some local variables and then makes the call to the function with the respective parameters
  void callback() {
    var lst = <Event>[];
    for (var entry in selectedTurnos.entries) {
      for (String turno in entry.value) {
        lst.addAll(mapEvents[entry.key]![turno]!);
      }
    }

    for (var uc in selectedUcs) {
      lst.addAll(mapEvents[uc]!["exam"]!);
    }

    if (widget.onFilterChangedList != null) {
      widget.onFilterChangedList!(lst);
    }
  }
}

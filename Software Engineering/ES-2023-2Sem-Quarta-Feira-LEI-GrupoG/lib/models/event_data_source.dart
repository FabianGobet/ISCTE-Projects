import 'package:calendar_manager/models/event_model.dart';
import 'package:calendar_manager/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tuple/tuple.dart';


///__Class that edits all appointments to be placed in the Calendar__
///
///Responsable for detecting overlapping and overcrowded events
///
class EventDataSource extends CalendarDataSource {
  List<Tuple2<Event, Event>> overlapped = [];
  List<String> sobrelotation = [];

  EventDataSource(List<Event> source) {
    appointments = source;
    appointments?.asMap().forEach((index, element) {
      setOverlapAndSobrelotation(index, element);
    });
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].getEventStart();
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].getEventEnd();
  }

  @override
  String getSubject(int index) {
    return appointments![index].getDescription();
  }

  ///__Returns true if the event @ [index] overlaps any other event in the appointments list.__
  ///
  /// Iterates through eventsList and calls addToList function to add an event pair containing the event selected by [index] that are overlapping based on their datetime start and end times
  ///
  bool isOverlapped(int index) {
    return (appointments!.any((e) {
      var aux = (e != appointments![index] &&
          ((appointments![index].getEventStart() as DateTime).isInBetween(
                  (e.getEventStart() as DateTime), //not inclusive
                  (e.getEventEnd() as DateTime)) ||
              (appointments![index].getEventEnd() as DateTime).isInBetween(
                  (e.getEventStart() as DateTime), //not inclusive
                  (e.getEventEnd() as DateTime)) ||
              appointments![index].getEventEnd() == e.getEventEnd() ||
              appointments![index].getEventStart() == e.getEventStart()));
      if (aux == true) addToList(appointments![index], e);
      return aux;
    }));
  }

  ///__Adds a String containing a desciption of the event[element] to the List\<Event\> containing sobrelotation events__
  ///
  ///Conditions to the addition:
  /// * The event has maximum capacity defined;
  /// * The event has current capacity defined;
  /// * The event's maximum capacity has a lower limit than it's current capacity defined;
  ///
  void setOverlapAndSobrelotation(int index, dynamic element) {
    isOverlapped(index);
    if (int.tryParse(element.lotacaoSala) != null &&
        int.tryParse(element.inscritosNoTurno) != null &&
        int.parse(element.lotacaoSala) < int.parse(element.inscritosNoTurno)) {
      sobrelotation.add(element.getSobrelotationDescription());
    }
  }

  @override
  Color getColor(int index) {
    if (isOverlapped(index)) {
      return Colors.red;
    }
    return Colors.green;
  }

  ///__Adds a Tuple2 containing input events [e1], [e2] to the List\<Tuple2\<Event, Event\>\> overlapped containing overlapping events__
  ///
  ///Conditions to the addition:
  /// * The list doesn't contain the Tuple2\<[e1] ,[e2]\>;
  /// * The list doesn't contain the Tuple2\<[e2] ,[e1]\>;
  ///
  void addToList(Event e1, Event e2) {
    if (!overlapped.contains(Tuple2(e2, e1)) &&
        !overlapped.contains(Tuple2(e1, e2))) {
      overlapped.add(Tuple2(e1, e2));
    }
  }
}

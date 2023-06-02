import 'dart:convert';
import 'package:calendar_manager/models/event_model.dart';
import 'package:calendar_manager/models/events_file_model.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

enum Formato { csv, json }

class Conversion {
  /// __Returns a EventsFile, consisting of json formatted string and a event list, from a csv formatted [data] string.__
  /// * For each Event in the list generates a json formatted string and concatenates it to the string to be returned
  static EventsFile fromCSVToJSON(String data) {
    List<Event> events = [];
    var eventsStrings = data.split("\n");
    var badEvents = 0;
    for (int i = 1; i < eventsStrings.length; i++) {
      try {
        var currentEvent = Event.fromCSV(eventsStrings[i]);
        events.add(currentEvent);
      } catch (_) {
        badEvents++;
      }
    }

    var jsonString = eventsToJson(events);

    return EventsFile(jsonString, events, badEvents);
  }

  ///__Returns a Tuple \<String, List\<Event\>\>, consisting of a CSV formatted string
  ///and an event list, from a Json formatted [jsonString] string.__

  static EventsFile fromJsonToCSV(String jsonString) {
    final aux = json.decode(jsonString);
    List<Event> events = [];
    var csvData = Event.csvHeader;
    var numEvent = aux["events"].length;
    var erros = 0;

    for (int i = 0; i < numEvent - 1; i++) {
      try {
        var evento = Event.fromJson(aux["events"][i]);
        events.add(evento);
        csvData += "${evento.toCSV()}\n";
      } catch (e) {
        erros++;
      }
    }

    if (numEvent > 0) {
      try {
        var evento = Event.fromJson(aux["events"][numEvent - 1]);
        csvData += evento.toCSV();
        events.add(evento);
      } catch (e) {
        if (csvData.substring(csvData.length - 1) == "\n") {
          csvData = csvData.substring(0, csvData.length - 1);
        }
        erros++;
      }
    }

    return EventsFile(csvData, events, erros);
  }

  ///
  ///__Returns a String in a JSON Formate from a List<Event>.__
  ///
  ///  * First part of the String will be the JSON Header, followed by all events in JSON formate
  ///
  static String eventsToJson(List<Event> events) {
    String json = '{ "events": [';
    json += '${events.map((e) => e.toJson()).join(",\n")}]}';
    return json;
  }

  ///
  ///__Returns a String in a CSV Formate from a List<Event>.__
  ///
  ///  * First line of the String will be the CSV Header, followed by all events in CSV formate
  ///
  static String eventsToCsv(List<Event> events) {
    String csv = Event.csvHeader;
    csv += events.map((e) => e.toCSV()).join("\n");
    return csv;
  }

  /// __Returns a tupple containing an event list as item 1, and an integer indicating the number
  /// of events that couldnt be translated due to formating error in file as item 2.__
  ///
  /// * Receives a string [ics] as input representing the string text of the ics file
  static EventsFile icsToEventList(String ics) {
    int missingData = 0;
    List<Event> lista = [];
    ICalendar icd = ICalendar.fromString(ics);
    for (var ele in icd.data) {
      var obj = icdToEvent(ele);
      if (obj == Null) {
        missingData++;
      } else {
        lista.add(obj as Event);
      }
    }
    return EventsFile("", lista, missingData);
  }

  /// __Returns an Object type object in the realm of Event, Null.__
  /// * Input [icdData] is a String to Dynamic object mapping contaning the various objects in the data of an [ICalendar] object.
  /// * A Null return indicates that the conversion of the string data to Event wasnt possible due to formating errors
  static Object icdToEvent(Map<String, dynamic> icdData) {
    Map<String, String> ad = {};
    try {
      for (String v in icdData['description'].split('\\n')) {
        if (v.isEmpty) continue;
        var l = v.split(': ');
        ad.addAll({l[0]: l[1]});
      }
      List<String> begin = ad['Begin']!.split(' ');

      String desc = (ad.containsKey('Description') ? ad['Description'] : '')!;
      Event evento = Event(
          '',
          ad['Unidade de execução'] ?? '',
          ad['Turno'] ?? desc,
          '',
          '',
          '',
          begin.last,
          ad['End']!.substring(ad['End']!.length - 5),
          begin.first,
          icdData['location'].split(',').first,
          '');

      return evento;
    } catch (exception) {
      //print(exception);
      return Null;
    }
  }
}

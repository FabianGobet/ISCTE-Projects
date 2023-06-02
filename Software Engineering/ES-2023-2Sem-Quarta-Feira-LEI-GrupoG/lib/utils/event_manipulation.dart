import 'dart:collection';
import 'package:calendar_manager/models/event_model.dart';

class EventManipulation {

  ///__Returns a map containing the events given in the List\<Event\> [events], separated by "UC" and "turno"__
  ///
  ///Each key-value pair given in the map represents a tree where:
  /// * The first node represents the Event's "UC";
  /// * The Nodes with Depth=1 represent the Event's "turno";
  /// * The Nodes with Depth=3 contain a List\<Event\> of all events with that "UC" and that "turno".
  static HashMap eventListSegmentation(List<Event> events) {
    HashMap map = HashMap<String, HashMap<String, List<Event>>>();
    for (int i = 0; i < events.length; i++) {
      map.putIfAbsent(
          events[i].unidadeCurricular, () => HashMap<String, List<Event>>());
      List<Event> aux = [];
      map[events[i].unidadeCurricular].putIfAbsent(events[i].turno, () => aux);
      map[events[i].unidadeCurricular][events[i].turno].add(events[i]);
    }
    return map;
  }

///__Iterates over a map, [map], and returns a List\<Event\> containing all Events with the given [uc] and [turno]__
///
///The map given to this function must have the same format as those given by the function eventListSegmentation.
///The variable [turno] is optional. If it's not provided, the List\<Event\> will only contain all Events that have the [uc] provided.
  static List<Event> getEventListFromMap(HashMap map, String uc,
      [String turno = "N/A"]) {
    if (turno != "N/A") return map[uc][turno];
    List<Event> events = [];
    map[uc].forEach((_, v) {
      events.addAll(v);
    });
    return events;
  }
}

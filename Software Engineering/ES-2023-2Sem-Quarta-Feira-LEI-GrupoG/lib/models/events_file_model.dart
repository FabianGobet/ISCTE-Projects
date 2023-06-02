import 'package:calendar_manager/models/event_model.dart';

class EventsFile {
  String representativeString;
  List<Event> lstEvents;
  int numberOfErrors;

  EventsFile(this.representativeString, this.lstEvents, this.numberOfErrors);
}

import 'package:calendar_manager/models/events_file_model.dart';
import 'package:calendar_manager/utils/conversion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:calendar_manager/models/event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:quickalert/quickalert.dart';

class File {
  /// __Returns a List\<Event\> from file 'csv', 'json', 'ics'.__
  ///
  /// * Open default system dialog to pick a file with the allowed extensions 'csv', 'json', 'ics'.
  /// * Converts it to List<Event>
  /// * If the chosen file doesn't contain a valid extension, an empty list is returned.
  ///
  /// ```dart
  /// ElevatedButton.icon(
  ///    onPressed: () async {
  ///       await Util.getEventsFromFile();
  ///    },
  ///  icon: const Icon(CupertinoIcons.tray_arrow_down_fill),
  ///  label: const Text("Escolher ficheiro")),
  /// ```
  static Future<EventsFile> getEventsFromFile() async {
    var allowedExtensions = ['csv', 'json', 'ics'];
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);

    if (result != null) {
      PlatformFile file = result.files.first;
      if (allowedExtensions.contains(file.extension)) {
        var data = utf8.decode(file.bytes!);
        switch (file.extension) {
          case 'csv':
            return Conversion.fromCSVToJSON(data);
          case 'json':
            return Conversion.fromJsonToCSV(data);
          case 'ics':
            return Conversion.icsToEventList(data);
        }
      }
    }
    return EventsFile("", [], -1);
  }

  /// __Returns a List\<Event\> from [url] file.__
  ///
  /// * Uses [getUrlFileData] funtction to make HTTP requests and converts responseto List<Event>.
  /// * If HTTP request fails, it returns an empty List\<Event\>.
  ///
  /// ```dart
  /// ElevatedButton(
  ///   onPressed: () {
  ///     File.getEventsFromUrl(urlString);
  ///   },
  ///   child: const Text('Submit'),
  /// )
  /// ```
  static Future<EventsFile> getEventsFromUrl(String url) async {
    url = url.contains('webcal') ? url.replaceFirst('webcal', 'https') : url;
    var response = await getUrlFileData(url);
    if (response.statusCode == 200) {
      switch (urlFileType(response.body)) {
        case 'json':
          return Conversion.fromJsonToCSV(response.body);
        case 'csv':
          return Conversion.fromCSVToJSON(response.body);
        case 'ics':
          return Conversion.icsToEventList(response.body);
      }
    }
    return EventsFile("", [], -1);
  }

  /// __Returns a string indicator of the file extension.__
  /// * 4 possible outputs: json, csv, ics and invalid.
  ///  * If any for the first three arent recognized, 'invalid' is returned.
  static String urlFileType(String responseBody) {
    String fileType = 'invalid';
    if (isJsonFormat(responseBody)) {
      fileType = 'json';
    } else if (isCsvFormat(responseBody)) {
      fileType = 'csv';
    } else if (isICalendarFormat(responseBody)) {
      fileType = 'ics';
    }
    return fileType;
  }

  /// __Returns boolean value for wether [text] is a json format string or not.__
  static bool isJsonFormat(String text) {
    try {
      jsonDecode(text);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// __Returns boolean value for wether [text] is a CSV format string or not.__
  /// * CSV format is only compared against [Event.csvHeader], given the scope of use
  static bool isCsvFormat(String text) {
    int le = Event.csvHeader.split(',').length;

    return text.split('\n')[0].split(",").length == le;
  }

  /// __Returns boolean value for wether [text] is a ics format string or not.__
  static bool isICalendarFormat(String text) {
    return RegExp(r"^BEGIN:VCALENDAR").hasMatch(text);
  }

  /// __Returns a Response (http object) from [url] file.__
  ///
  /// * Makes an HTTP GET request at given [url], downloads the file and returns the response
  static Future<Response> getUrlFileData(String url) async {
    var header = {
      'Access-Control-Allow-Origin': '*',
      "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
      "Access-Control-Allow-Headers":
          "Origin, X-Requested-With, Content-Type, Accept"
    };
    var response = await get(Uri.parse(url), headers: header);
    return response;
  }

  ///
  ///__Save a file in a default path with a specified formate from a String__
  ///
  ///Consist in 3 parameters fileText String that will be the content of the file,
  ///format may be json or csv and optional parameter that will be the name of the
  ///file by default will be calendar.
  ///
  ///``` dart
  /// onPressed: () {
  ///           var txt = Util.eventsToJson(List<Events>);
  ///           File.savefile(txt, (Formato.json or Formato.csv) , optional : name);
  /// }
  ///```
  static Future<String> saveFile(String fileText, Formato formato,
      [String name = 'calendar']) async {
    return await FileSaver.instance.saveFile(
        name: '$name.${formato.name}',
        ext: formato.name,
        bytes: Uint8List.fromList(utf8.encode(fileText)));
  }

  ///
  ///__Generate a pop up alert__
  ///
  /// Generate a pop up alert. It can be successfull if erros are 0 or less;
  /// warning if there is any errors.
  /// the pop up messagem will auto close in 2 seconds.
  ///
  /// ``` dart
  /// onPressed: () {
  ///             File.alert(context, erros);
  ///             File.saveFile(txt, Formato.json);
  ///           },
  /// ```
  ///
  static void alert(BuildContext context, int erros) {
    if (erros < 1) {
      QuickAlert.show(
          context: context,
          title: 'Success',
          type: QuickAlertType.success,
          autoCloseDuration: const Duration(seconds: 2));
    } else {
      QuickAlert.show(
          context: context,
          title: 'Warning',
          type: QuickAlertType.warning,
          text: 'Encontrados $erros no ficheiro',
          autoCloseDuration: const Duration(seconds: 2));
    }
  }
}

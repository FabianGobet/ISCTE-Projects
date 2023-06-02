import 'package:calendar_manager/screens/home.dart';
import 'package:calendar_manager/utils/constants.dart';
import 'package:calendar_manager/utils/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendario',
      initialRoute: "home",
      scrollBehavior: CustomScrollBehavior(),
      routes: {
        "home": (context) => const Home(),
        /*"filefromurl": (context) => const FileFromUrl(),
        "pickfile": (context) => const PickFile(),
        "savefile": (context) => const SaveFile(),
        "icstostring": (context) => const IcsToString(),*/
      },
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
            checkColor:
                MaterialStateProperty.all<Color>(Constants.kPrimaryColor)),
        primarySwatch: Constants.kPrimaryColor,
        iconTheme: IconThemeData(color: Constants.kPrimaryColor),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt', 'PT'),
      ],
      locale: const Locale("pt", "PT"),
    );
  }
}

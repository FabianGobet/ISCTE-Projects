import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto/screens/home_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto de PI',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(const Color(0xFFff9404))),
          primarySwatch: buildMaterialColor(const Color(0xFFff9404)),
          scaffoldBackgroundColor: Colors.black87,
          textTheme:
              Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(Colors.purple)),
          primarySwatch: Colors.purple,
          elevatedButtonTheme:
              const ElevatedButtonThemeData(style: ButtonStyle())),
      home: const HomeScreen(),
    );
  }
}

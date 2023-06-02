import 'package:intl/date_symbol_data_local.dart';
import 'package:pisid/screens/home.dart';
import 'package:pisid/utils/config.dart';
import 'package:pisid/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  initializeDateFormatting("PT");

  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Monitorização Ratos';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(colorSchemeSeed: Colors.orange.shade800),
      home: sharedPreferences!.getString(Constants.shpUser) != null
          ? const Home()
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text(appTitle),
              ),
              body: const LoginForm(),
            ),
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController(text: "root");
  final passwordController = TextEditingController(text: "kr.pJ.x95#");
  final ipController = TextEditingController(text: "46.189.143.63");
  final portController = TextEditingController(text: "1234");

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                //initialValue: 'root',
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a valid username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              TextFormField(
                controller: ipController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'IP (xxx.xxx...)',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a valid IP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: portController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Port Xamp',
                ),
              ),
              //Flexible(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      validateLogin();
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validateLogin() async {
    String loginURL =
        "http://${ipController.text.trim()}:${portController.text.trim()}/PISID_Sql/htdocs/scripts/app_Login.php";

    try {
      var response = await http.post(Uri.parse(loginURL), body: {
        'username': usernameController.text.trim(), //get the username text
        'password': passwordController.text.trim() //get password text
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData["success"]) {
          sharedPreferences!
              .setString(Constants.shpUserId, portController.text.trim());
          sharedPreferences!
              .setString(Constants.shpUser, usernameController.text.trim());
          sharedPreferences!
              .setString(Constants.shpPass, passwordController.text.trim());
          sharedPreferences!
              .setString(Constants.shpIp, ipController.text.trim());
          sharedPreferences!
              .setString(Constants.shpPort, portController.text.trim());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(jsonData["message"]),
              );
            },
          );
        }
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("The connection to the database failed."),
          );
        },
      );
    }
  }
}

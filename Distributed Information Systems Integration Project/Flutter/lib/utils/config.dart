import 'package:pisid/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
String baseUrl = "http://" +
    sharedPreferences!.getString(Constants.shpIp)! +
    ":" +
    sharedPreferences!.getString(Constants.shpPort)!;

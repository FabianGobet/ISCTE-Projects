import 'package:flutter/material.dart';

class Utils {
  static double getSidePadding(BuildContext context, {double val = 0.04}) {
    return MediaQuery.of(context).size.width * val;
  }
}

import 'package:flutter/foundation.dart';
import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /*
  
  Debouncer().run((){
    setState(() {
      ele.value = slideValue;
      alterValues(ele);
      productivity =
      Calculus.groupProductivityAverage(widget.persons);
    });
  })

  */
}

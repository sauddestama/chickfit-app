import 'dart:async';

import 'package:flutter/services.dart';

class ThrottleUtil {
  final int milliseconds;
  Timer? _timer;

  ThrottleUtil({
    required this.milliseconds,
  });

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

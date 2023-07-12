import 'dart:async';
import 'package:flutter/foundation.dart';

class TimeCounterProvider with ChangeNotifier {
  int _seconds = 0;
  late Timer _timer;

  int get seconds => _seconds;

  TimeCounterProvider() {
    start();
  }

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _seconds++;
      notifyListeners();
    });
  }

  void pause() {
    _timer.cancel();
  }

  void reset() {
    _seconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getCurrentTime() {
    int hours = _seconds ~/ 3600;
    int minutes = (_seconds % 3600) ~/ 60;
    int seconds = _seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  void resume() {
    start();
  }
}

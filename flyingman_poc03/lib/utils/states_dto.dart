

import 'package:flyingman_poc03/main.dart';

class StateDto {
  static bool _saveToFile = false;

  static bool get saveToFile => _saveToFile;

  static setSaveToFile(bool value) {
    _saveToFile = value;
    MyApp.messageBuffer.runningCommitNow = false;
  }




 }

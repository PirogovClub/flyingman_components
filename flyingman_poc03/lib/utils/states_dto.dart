 class StateDto {
  static bool _saveToFile = false;

  static bool get saveToFile => _saveToFile;

  static setSaveToFile(bool value) {
    _saveToFile = value;
  }
}

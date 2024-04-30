//* Packages
import 'package:flutter/material.dart';

//* Services
import '../Services/HiveStorage/boxes.dart';
import '../Services/HiveStorage/setting.dart';

class SettingsProvider extends ChangeNotifier {
  bool isDarkMode = false;
  bool shouldSpeak = false;

  bool get isDarkModes => isDarkMode;

  bool get shouldSpeaks => shouldSpeak;

  // get the saved settings from the box
  void getSavedSettings() {
    final settingsBox = Boxes.getSettings();

    // check is the setting box is open
    if (settingsBox.isNotEmpty) {
      // get the settings
      final settings = settingsBox.get(0);
      isDarkMode = settings!.isDarkTheme;
      shouldSpeak = settings.shouldSpeak;
    }
  }

  void toggleDarkMode({required bool value, Settings? settings}) {
    if (settings != null) {
      settings.isDarkTheme = value;
      settings.save();
    } else {
      // get the settings box
      final settingsBox = Boxes.getSettings();

      // save the settings
      settingsBox.put(
        0,
        Settings(
          isDarkTheme: value,
          shouldSpeak: shouldSpeaks,
        ),
      );
    }
    isDarkMode = value;
    notifyListeners();
  }

  // toogle the speak
  void toggleSpeak({required bool value, Settings? settings}) {
    if (settings != null) {
      settings.shouldSpeak = value;
      settings.save();
    } else {
      // get the settings box
      final settingsBox = Boxes.getSettings();

      // save the settings
      settingsBox.put(
        0,
        Settings(
          isDarkTheme: isDarkModes,
          shouldSpeak: value,
        ),
      );
    }
    shouldSpeak = value;
    notifyListeners();
  }
}

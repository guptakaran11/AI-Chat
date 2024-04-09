import 'package:hive_flutter/hive_flutter.dart';

part 'setting.g.dart';

@HiveType(typeId: 2)
class Settings extends HiveObject {
  @HiveField(0)
  bool isDarkTheme = false;

  @HiveField(1)
  bool shouldSpeak = false;

  Settings({
    required this.isDarkTheme,
    required this.shouldSpeak,
  });
}

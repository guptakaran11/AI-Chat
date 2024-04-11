// ignore_for_file: file_names

//* Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

//* Widgets
import 'package:aichat/View/Widgets/constants.dart';


class ChatProvider extends ChangeNotifier {
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB); 
  }
}

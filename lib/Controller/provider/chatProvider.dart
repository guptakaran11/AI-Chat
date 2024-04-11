// ignore_for_file: file_names

//* Packages

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;

//* Models
import 'package:aichat/Model/userModel.dart';

//* Services
import 'package:aichat/Controller/Services/HiveStorage/chatHistoryStorage.dart';
import 'package:aichat/Controller/Services/HiveStorage/setting.dart';

//* Widgets
import 'package:aichat/View/Widgets/constants.dart';

class ChatProvider extends ChangeNotifier {
  // init Hive Box
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    // register the adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(
        ChatHistoryStorageAdapter(),
      );
      await Hive.openBox<ChatHistoryStorage>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(
        UserModelAdapter(),
      );
      await Hive.openBox<UserModel>(Constants.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(
        SettingsAdapter(),
      );
      await Hive.openBox<Settings>(Constants.settingBox);
    }
  }
}

// ignore_for_file: file_names

//* Dart Packages
import 'dart:async';
import 'dart:developer';

//* Packages
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

//* Models
import '../../Model/userModel.dart';
import '../../Model/messageModel.dart';

//* Services
import '../../Controller/Services/HiveStorage/chatHistoryStorage.dart';
import '../../Controller/Services/HiveStorage/setting.dart';
import '../../Controller/Services/Apis/api.dart';

//* Widgets
import '../../View/Widgets/constants.dart';

class ChatProvider extends ChangeNotifier {
  List<MessageModel> inChatMessages = [];

  final PageController controller = PageController();

  List<XFile>? imagesFileList = [];

  int currentIndex = 0;
  String currentChatId = '';
  String modelType = 'gemini-pro';
  bool isLoading = false;

  GenerativeModel? model;
  GenerativeModel? textModel;
  GenerativeModel? visionModel;

  List<MessageModel> get inChatMessage => inChatMessages;
  PageController get pageController => controller;
  List<XFile>? get imagesFileLists => imagesFileList;
  int get currentIndexs => currentIndex;
  String get currentChatIds => currentChatId;
  GenerativeModel? get gmodel => model;
  GenerativeModel? get textModels => textModel;
  GenerativeModel? get visionModels => visionModel;
  String get gModelType => modelType;
  bool get isLoadings => isLoading;

  Future<void> setInChatMessages(String chatId) async {
    final messageFromDB = await loadMessagesFromDB(chatId);

    for (var message in messageFromDB) {
      if (inChatMessages.contains(message)) {
        log("Message already exists");
        continue;
      }
      inChatMessages.add(message);
    }
    notifyListeners();
  }

  Future<List<MessageModel>> loadMessagesFromDB(String chatId) async {
    await Hive.openBox('${Constants.chatMessageBox}$chatId');

    final messageBox = Hive.box('${Constants.chatMessageBox}$chatId');

    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      final messageData =
          MessageModel.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();
    notifyListeners();
    return newData;
  }

  void setImageFileList(List<XFile> listValue) {
    imagesFileList = listValue;
    notifyListeners();
  }

  String setCurrentModel(String newModel) {
    modelType = newModel;
    notifyListeners();
    return modelType;
  }

  Future<void> setModel(bool isTextOnly) async {
    if (isTextOnly) {
      model = textModel ??
          GenerativeModel(
            model: setCurrentModel('gemini-pro'),
            apiKey: ApiServices.apiKey,
          );
    } else {
      model = visionModel ??
          GenerativeModel(
            model: setCurrentModel('gemini-pro-vision'),
            apiKey: ApiServices.apiKey,
          );
    }
    notifyListeners();
  }

  void setCurrentIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }

  void setCurrentChatID(String newChatId) {
    currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

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

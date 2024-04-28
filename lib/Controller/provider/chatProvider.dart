// ignore_for_file: file_names

//* Dart Packages
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

//* Packages
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

//* Models
import '../../Model/userModel.dart';
import '../../Model/messageModel.dart';

//* Services
import '../../Controller/Services/HiveStorage/chatHistoryStorage.dart';
import '../../Controller/Services/HiveStorage/setting.dart';
import '../../Controller/Services/Apis/api.dart';
import '../../Controller/Services/HiveStorage/boxes.dart';

//* Widgets
import '../../View/Widgets/constants.dart';

class ChatProvider extends ChangeNotifier {
  final List<MessageModel> inChatMessages = [];

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

  // delete chat
  Future<void> deletChatMessages({required String chatId}) async {
    // 1. check if the box is open
    if (!Hive.isBoxOpen('${Constants.chatMessageBox}$chatId')) {
      // open the box
      await Hive.openBox('${Constants.chatMessageBox}$chatId');

      // delete all messages in the box
      await Hive.box('${Constants.chatMessageBox}$chatId').clear();

      // close the box
      await Hive.box('${Constants.chatMessageBox}$chatId').close();
    } else {
      // delete all messages in the box
      await Hive.box('${Constants.chatMessageBox}$chatId').clear();

      // close the box
      await Hive.box('${Constants.chatMessageBox}$chatId').close();
    }

    // get the current chatId, its its not empty
    // we check if its the same as the chatId
    // if its the same we set it to empty
    if (currentChatId.isNotEmpty) {
      if (currentChatId == chatId) {
        setCurrentChatID("");
        inChatMessages.clear();
        notifyListeners();
      }
    }
  }

  // Prepare the chat for the loading
  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    if (!isNewChat) {
      // 1. load the chat message from the data base
      final chatHistory = await loadMessagesFromDB(chatID);

      //2.  clear the inChatMessages
      inChatMessages.clear();

      for (var message in chatHistory) {
        inChatMessages.add(message);
      }

      // 3. Set the current chat Id
      setCurrentChatID(chatID);
    } else {
      // 1. clear inChatmessages
      inChatMessages.clear();

      // 2.set the current chat Id
      setCurrentChatID(chatID);
    }
  }

// send message to gemini and get the stream response
  Future<void> sentMessage(String message, bool isTextOnly) async {
    await setModel(isTextOnly);

    setLoading(true);

    // get the chatId
    String chatId = getChatID();

    // get the list of history messsage
    List<Content> history = [];

    // get the chat History
    history = await getHistory(chatId);

    // get the image Urls
    List<String> imagesUrls = getImageUrl(isTextOnly);

    // open the messge box
    final messageBox = await Hive.openBox("${Constants.chatMessageBox}$chatId");

    log("messageLength:  ${messageBox.keys.length}");

    // get the last user message
    final userMessageId = messageBox.keys.length;

    // get the last assiatant  message
    final assistantMessageId = messageBox.keys.length + 1;

    log("messageuserId: ${userMessageId.toString()}");
    log("model: ${assistantMessageId.toString()}");

    // userMessage
    final userMessage = MessageModel(
      messageId: userMessageId.toString(),
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imageUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

// add this message to the list on inChatMessages
    inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatIds.isEmpty) {
      setCurrentChatID(chatId);
    }

// send message to the model and wait for the response
    await sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
      modelMessageId: assistantMessageId.toString(),
      messageBox: messageBox,
    );
  }

  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required MessageModel userMessage,
    required String modelMessageId,
    required Box messageBox,
  }) async {
    // start the chat Session- only send history is its text-only
    final chatSession = model!
        .startChat(history: history.isEmpty || !isTextOnly ? null : history);

    // getContent
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

      // assistant messageId
    final modelMesssageId = const Uuid().v4();

      // assistant message
    final assistantMessage = userMessage.copyWith(
      messageId: modelMesssageId,
      role: Role.assistant,
      message: StringBuffer(),
      timeSent: DateTime.now(),
    );

      // add this message to the list on inChatMessages
    inChatMessages.add(assistantMessage);
    notifyListeners();

      // wait for the Stream message response
    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen((event) {
      inChatMessages
          .firstWhere((element) =>
              element.messageId == assistantMessage.messageId &&
              element.role.name == Role.assistant.name)
          .message
          .write(event.text);
      notifyListeners();
    }, onDone: () async {
      // save message to the hive db
      await saveMessageToDB(
        chatID: chatId,
        userMessage: userMessage,
        assistantMessage: assistantMessage,
        messageBox: messageBox,
      );

      // set loading to false
      setLoading(false);
    }).onError((error, stackTrace) {
      // set loading
      setLoading(false);
    });
  }

  // save message to hive db
  Future<void> saveMessageToDB({
    required String chatID,
    required MessageModel userMessage,
    required MessageModel assistantMessage,
    required Box messageBox,
  }) async {
    // save the user messages
    await messageBox.add(userMessage.toMap());

    // save the assistant messages
    await messageBox.add(assistantMessage.toMap());

    // save chatHistory with same chatId
    // if its already there update it
    // if not create new one

    final chatHistoryBox = Boxes.getChatHistory();

    final chatHistory = ChatHistoryStorage(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imageURL: userMessage.imageUrls,
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(chatID, chatHistory);

    // close the box
    await messageBox.close();
  }

  Future<Content> getContent({
    required message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      // generate text from text-only input
      return Content.text(message);
    } else {
      // generate image from text and image input
      final imageFutures = imagesFileList
          ?.map(
            (imageFile) => imageFile.readAsBytes(),
          )
          .toList(growable: false);

      final imageBytes = await Future.wait(imageFutures!);
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map(
            (bytes) => DataPart(
              'image/jpeg',
              Uint8List.fromList(
                bytes,
              ),
            ),
          )
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

  List<String> getImageUrl(bool isTextOnly) {
    List<String> imagesUrls = [];
    if (!isTextOnly && imagesFileLists != null) {
      for (var image in imagesFileLists!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  Future<List<Content>> getHistory(String chatId) async {
    List<Content> history = [];
    if (currentChatIds.isEmpty) {
      await setInChatMessages(chatId);

      for (var message in inChatMessage) {
        if (message.role == Role.user) {
          history.add(
            Content.text(
              message.message.toString(),
            ),
          );
        } else {
          history.add(
            Content.model(
              [
                TextPart(message.message.toString()),
              ],
            ),
          );
        }
      }
    }
    return history;
  }

  String getChatID() {
    if (currentChatIds.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatIds;
    }
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

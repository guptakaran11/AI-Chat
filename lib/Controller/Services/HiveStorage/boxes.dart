
//* Packages
import 'package:hive/hive.dart';

//* Storages
import '../../../Model/userModel.dart';
import '../HiveStorage/chatHistoryStorage.dart';
import '../HiveStorage/setting.dart';

//* Widgets
import '../../../View/Widgets/constants.dart';


class Boxes {
  //! Get chat history box
  static Box<ChatHistoryStorage> getChatHistory() {
    return Hive.box<ChatHistoryStorage>(Constants.chatHistoryBox);
  }

  //! Get user box
  static Box<UserModel> getUser() {
    return Hive.box<UserModel>(Constants.userBox);
  }

  //! Get setting box
  static Box<Settings> getSettings() {
    return Hive.box<Settings>(Constants.settingBox);
  }
}

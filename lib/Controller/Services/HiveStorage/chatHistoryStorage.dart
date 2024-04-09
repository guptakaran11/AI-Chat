// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'package:hive_flutter/hive_flutter.dart';

part 'chatHistoryStorage.g.dart';

@HiveType(typeId: 0)
class ChatHistoryStorage extends HiveObject {
  @HiveField(0)
  final String chatId;

  @HiveField(1)
  final String prompt;

  @HiveField(2)
  final String response;

  @HiveField(3)
  final List<String> imageURL;

  @HiveField(4)
  final DateTime timestamp;
  ChatHistoryStorage({
    required this.chatId,
    required this.prompt,
    required this.response,
    required this.imageURL,
    required this.timestamp,
  });

}

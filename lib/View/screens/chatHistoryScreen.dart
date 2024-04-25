// ignore_for_file: file_names

//* Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

//* Services
import '../../Controller/Services/HiveStorage/chatHistoryStorage.dart';
import '../../Controller/Services/HiveStorage/boxes.dart';

//* Widgets
import '../Widgets/chat_history_card_widget.dart';
import '../Widgets/empty_history_widget.dart';

//* Utilities
import "../utilities/utility.dart";

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: const Text("Chat History"),
      ),
      body: ValueListenableBuilder<Box<ChatHistoryStorage>>(
        valueListenable: Boxes.getChatHistory().listenable(),
        builder: (context, box, _) {
          final chatHistory =
              box.values.toList().cast<ChatHistoryStorage>().reversed.toList();
          return chatHistory.isEmpty
              ? const EmptyHistoryWidget()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      final chat = chatHistory[index];
                      return ChatHistoryCard(chat: chat);
                    },
                  ),
                );
        },
      ),
    );
  }
}

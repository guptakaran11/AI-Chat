//* Packages
import 'package:flutter/material.dart';

//* Services
import '../../Controller/Services/HiveStorage/chatHistoryStorage.dart';

//* Utilities
import '../utilities/utility.dart';

class ChatHistoryCard extends StatelessWidget {
  const ChatHistoryCard({
    super.key,
    required this.chat,
  });

  final ChatHistoryStorage chat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        leading: const CircleAvatar(
          radius: 30,
          child: Icon(Icons.chat),
        ),
        title: Text(
          chat.prompt,
          maxLines: 1,
        ),
        subtitle: Text(
          chat.response,
          maxLines: 2,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // naviagate to chat screen
        },
        onLongPress: () {
          // show my animated dialog to delete the chat
          showAnimatedDialog(
            context: context,
            title: "Delete Chat",
            content: "Are you sure you want to delete the Chat?",
            actionText: "Delete",
            onActionPressed: (value) {
              if (value) {
                // delete the chat
              }
            },
          );
        },
      ),
    );
  }
}

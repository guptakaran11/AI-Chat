//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Services
import '../../Controller/Services/HiveStorage/chatHistoryStorage.dart';

//* Utilities
import '../utilities/utility.dart';

//* Providers
import '../../Controller/provider/chatProvider.dart';

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
        onTap: () async {
          // naviagate to chat screen
          final chatProvider = context.read<ChatProvider>();
          // Load the content
          await chatProvider.prepareChatRoom(
            isNewChat: false,
            chatID: chat.chatId,
          );
          chatProvider.setCurrentIndex(1);
          chatProvider.pageController.jumpToPage(1);
        },
        onLongPress: () {
          // show my animated dialog to delete the chat
          showAnimatedDialog(
            context: context,
            title: "Delete Chat",
            content: "Are you sure you want to delete the Chat?",
            actionText: "Delete",
            onActionPressed: (value) async {
              if (value) {
                // delete the chat
                await context.read<ChatProvider>().deletChatMessages(
                      chatId: chat.chatId,
                    );
                // delete the chat History
                await chat.delete();
              }
            },
          );
        },
      ),
    );
  }
}


//* Packages
import 'package:flutter/material.dart';

//* Providers
import '../../Controller/provider/chatProvider.dart';

//* Widgets
import '../Widgets/message_widget.dart';
import '../Widgets/assistant_message_widget.dart';

//* Models
import '../../Model/messageModel.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({
    super.key,
    required this.scrollController,
    required this.chatProvider,
  });

  final ScrollController scrollController;
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatProvider.inChatMessages.length,
      itemBuilder: (context, index) {
        final message = chatProvider.inChatMessages[index];
        return message.role.name == Role.user.name
            ? MessageWidget(
                message: message,
              )
            : AssistantMessageWidget(
                message: message.message.toString(),
              );
      },
    );
  }
}

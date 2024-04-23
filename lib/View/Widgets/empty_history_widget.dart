//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Providers
import '../../Controller/provider/chatProvider.dart';

class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // naviagate to chat screen
          final chatProvider = context.read<ChatProvider>();
          // Load the content
          await chatProvider.prepareChatRoom(
            isNewChat: true,
            chatID: "",
          );
          chatProvider.setCurrentIndex(1);
          chatProvider.pageController.jumpToPage(1);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              " No Chat Found, start a new chat! ",
            ),
          ),
        ),
      ),
    );
  }
}

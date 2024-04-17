// ignore_for_file: file_names

//* Packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Providers
import '../../Controller/provider/chatProvider.dart';

//* Widgets
import '../Widgets/bottom_chat_field.dart';
import '../Widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          scrollController.position.maxScrollExtent > 0.0) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.inChatMessages.isNotEmpty) {
          scrollToBottom();
        }
        chatProvider.addListener(() {
          if (chatProvider.inChatMessages.isNotEmpty) {
            scrollToBottom();
          }
        });

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: const Text(
              "Chat with AI",
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: chatProvider.inChatMessages.isEmpty
                        ? const Center(
                            child: Text(
                              "No messages yet",
                            ),
                          )
                        : ChatMessages(
                            scrollController: scrollController,
                            chatProvider: chatProvider,
                          ),
                  ),
                  BottomChatField(
                    chatProvider: chatProvider,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

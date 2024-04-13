// ignore_for_file: file_names

//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Providers
import '../../Controller/provider/chatProvider.dart';

//* Widgets
import '../Widgets/bottom_chat_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: chatProvider.inChatMessage.isEmpty
                        ? const Center(
                            child: Text(
                              "No messages yet",
                            ),
                          )
                        : ListView.builder(
                            itemCount: chatProvider.inChatMessage.length,
                            itemBuilder: (context, index) {
                              final message = chatProvider.inChatMessage[index];
                              return ListTile(
                                title: Text(
                                  message.message.toString(),
                                ),
                              );
                            },
                          ),
                  ),
                  BottomChatField(
                    key: UniqueKey(),
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

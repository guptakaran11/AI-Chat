//* Dart package
import 'dart:developer';

//* Packages
import 'package:flutter/material.dart';

//* Providers
import 'package:aichat/Controller/provider/chatProvider.dart';

class BottomChatField extends StatefulWidget {
  final ChatProvider chatProvider;

  const BottomChatField({
    super.key,
    required this.chatProvider,
  });

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> sendChatMessage({
    required String message,
    required ChatProvider chatProvider,
    required bool isTextOnly,
  }) async {
    try {
      await chatProvider.sentMessage(message, isTextOnly);
    } catch (e) {
      log("Error in sending message ");
      log(e.toString());
    } finally {
      textController.clear();
      textFieldFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).textTheme.titleLarge!.color!,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.image_rounded,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              focusNode: textFieldFocus,
              controller: textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  sendChatMessage(
                    message: textController.text,
                    chatProvider: widget.chatProvider,
                    isTextOnly: true,
                  );
                }
              },
              decoration: InputDecoration(
                hintText: "Enter a prompt...",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // send Chat message
              if (textController.text.isNotEmpty) {
                sendChatMessage(
                  message: textController.text,
                  chatProvider: widget.chatProvider,
                  isTextOnly: true,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(5.0),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

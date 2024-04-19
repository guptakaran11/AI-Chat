//* Packages
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

//* Models
import '../../Model/messageModel.dart';

//* Widgets
import '../Widgets/preview_image_widget.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel message;
  const MessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrls.isNotEmpty)
              PreviewImage(
                message: message,
              ),
            MarkdownBody(
              data: message.message.toString(),
              selectable: true,
            ),
          ],
        ),
      ),
    );
  }
}

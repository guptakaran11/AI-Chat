//* Dart Packages
import 'dart:io';

//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Models
import '../../Model/messageModel.dart';

//* Providers
import '../../Controller/provider/chatProvider.dart';

class PreviewImage extends StatelessWidget {
  final MessageModel? message;
  const PreviewImage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageToShow =
            message != null ? message!.imageUrls : chatProvider.imagesFileList;
        final padding = message != null
            ? EdgeInsets.zero
            : const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              );
        return Padding(
          padding: padding,
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: messageToShow!.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      File(
                        message != null
                            ? message!.imageUrls[index]
                            : chatProvider.imagesFileList![index].path,
                      ),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Container(),
    );
  }
}

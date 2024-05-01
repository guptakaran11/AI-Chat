//* Dart Packages
import 'dart:io';

//* Packages
import 'package:flutter/material.dart';

//* Utilites
import '../utilities/assets_manager.dart';

class DisplayImage extends StatelessWidget {
  final File? file;
  final String userImage;
  final VoidCallback onPressed;

  const DisplayImage({
    super.key,
    required this.file,
    required this.userImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60.0,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: getImageToShow(),
        ),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: InkWell(
            onTap: onPressed,
            child: const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20.0,
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  getImageToShow() {
    if (file != null) {
      return FileImage(File(file!.path)) as ImageProvider<Object>;
    } else if (userImage.isNotEmpty) {
      return FileImage(File(userImage)) as ImageProvider<Object>;
    } else {
      return const AssetImage(AssetsManager.userIcon);
    }
  }
}

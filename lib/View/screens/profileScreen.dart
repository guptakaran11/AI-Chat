// ignore_for_file: file_names

//* Dart Packages
import 'dart:developer';
import 'dart:io';

//* Packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

//* Services
import '../../Controller/Services/HiveStorage/boxes.dart';
import '../../Controller/Services/HiveStorage/setting.dart';

//* Widgets
import '../Widgets/display_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  String userImage = '';
  String userName = 'Human-Ai';
  final ImagePicker imagePicker = ImagePicker();

  // For pick the image
  void pickImage() async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 100, // 100 is the value for the original quality
      );
      if (pickedImage != null) {
        setState(() {
          file = File(pickedImage.path);
        });
      }
    } catch (e) {
      log("Error in picking image");
      log(e.toString());
    }
  }

  // get user data
  void getUserData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // get user data from the box
      final userBox = Boxes.getUser();

      // check the userData is not empty
      if (userBox.isNotEmpty) {
        final user = userBox.getAt(0);
        setState(() {
          userImage = user!.name;
          userName = user.image;
        });
      }
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              // save the data
            },
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: DisplayImage(
                  file: file,
                  userImage: userImage,
                  onPressed: () {
                    // open a camera or gallery
                    pickImage();
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 40.0,
              ),
              ValueListenableBuilder<Box<Settings>>(
                valueListenable: Boxes.getSettings().listenable(),
                builder: (context, box, child) {
                  if (box.isEmpty) {
                    return Column(
                      children: [
                        // Ai voice
                        SwitchListTile(
                          title: const Text('Enable Ai Voice'),
                          value: false,
                          onChanged: (value) {},
                        ),
                        // Theme
                        SwitchListTile(
                          title: const Text('Theme'),
                          value: false,
                          onChanged: (value) {},
                        ),
                      ],
                    );
                  } else {
                    final settings = box.getAt(0);
                    return Column(
                      children: [
                        // dark mode
                        SwitchListTile(
                          title: const Text('Dark Mode'),
                          value: settings!.isDarkTheme,
                          onChanged: (value) {
                            settings.isDarkTheme = value;
                            settings.save();
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

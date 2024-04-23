// ignore_for_file: file_names

//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Screens
import '../../View/screens/chatHistoryScreen.dart';
import '../../View/screens/chatScreen.dart';
import '../../View/screens/profileScreen.dart';

//* Providers
import '../Controller/provider/chatProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of Screens
  final List<Widget> screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          body: PageView(
            controller: chatProvider.pageController,
            children: screens,
            onPageChanged: (index) {
              chatProvider.setCurrentIndex(index);
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: chatProvider.currentIndex,
            elevation: 0,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (index) {
              chatProvider.setCurrentIndex(index);
              chatProvider.pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "Chat History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: "Chat ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}

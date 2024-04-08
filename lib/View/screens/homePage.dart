// ignore_for_file: file_names

//* Packages
import 'package:flutter/material.dart';

//* Screens
import 'package:aichat/View/screens/chatHistoryScreen.dart';
import 'package:aichat/View/screens/chatScreen.dart';
import 'package:aichat/View/screens/profileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();
  int currentIndex = 0;

  // List of Screens
  final List<Widget> screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: pageController,
        children: screens,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          pageController.jumpToPage(index);
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
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Providers
import 'package:aichat/Controller/provider/chatProvider.dart';
import 'package:aichat/Controller/provider/settings_provider.dart';

//* Screens
import 'package:aichat/View/homePage.dart';

//* Themes
import 'package:aichat/View/themes/chat_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setTheme();
    super.initState();
  }

  void setTheme() {
    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.getSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Chat',
      theme: context.watch<SettingsProvider>().isDarkModes
          ? darkTheme
          : lightTheme,
      home: const HomeScreen(),
    );
  }
}

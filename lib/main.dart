//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Providers
import 'package:aichat/Controller/provider/chatProvider.dart';

//* Screens
import 'package:aichat/View/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AI Chat',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen());
  }
}

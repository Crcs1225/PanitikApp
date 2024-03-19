import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panitik/database/database_helper.dart';
import 'package:panitik/screen_packages/nav.dart';
import 'package:panitik/screens/login.dart';
import 'package:panitik/screens/splash.dart';
import 'firebase_options.dart';
import 'package:panitik/screens/home.dart';
import 'package:panitik/screens/profile.dart';
import 'package:panitik/screens/chat.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseHelper().initDatabase();
  Gemini.init(apiKey: 'AIzaSyD9w41WDnSlmM_zAFv98OmGgwL7nmuFBuA');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Panitik',
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/train': (context) => ChatScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/nav': (context) => const NavigationScreen(),
        });
  }
}

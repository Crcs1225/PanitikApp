import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:panitik/screens/features.dart';
import 'package:panitik/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen_packages/nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _checkFirstTime().then((isFirstTime) {
      if (isFirstTime) {
        // Show the featured screen if the app is newly installed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FeaturedScreen()),
        );
      } else {
        // Delay and then navigate to the auth check screen
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AuthCheckScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  Future<bool> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      // Update shared preferences to indicate that the app has been opened
      await prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 241, 190, 1.0),
              Color.fromRGBO(139, 69, 19, 1.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_icon.png',
              width: 130,
              height: 130,
            ),
            Image.asset(
              'assets/app_name.png',
              width: 150,
              height: 100,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance.authStateChanges(), // Use the stream directly
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for Firebase Authentication response, display a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in

          return const NavigationScreen();
        } else {
          // User is logged out
          return const LoginScreen();
        }
      },
    );
  }
}

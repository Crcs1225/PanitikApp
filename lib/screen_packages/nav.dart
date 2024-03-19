import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../screens/chat.dart';
import '../screens/home.dart';
import '../screens/profile.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key});

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _screens = [
    HomeScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: GNav(
          // Use GNav instead of BottomNavigationBar
          activeColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          gap: 8,
          iconSize: 30,
          tabBackgroundColor: Color.fromRGBO(139, 69, 19, .9),
          hoverColor: Color.fromRGBO(139, 69, 19, .1),

          duration: Duration(milliseconds: 400),
          rippleColor: Colors.grey[300]!,
          color: Colors.grey[800],
          tabs: [
            GButton(
              icon: Iconsax.home,
              text: 'Home',
            ),
            GButton(
              icon: Iconsax.message5,
              text: 'Chat',
            ),
            GButton(
              icon: Icons.settings_outlined,
              text: 'Profile',
            ),
          ],
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
          },
        ),
      ),
    );
  }
}

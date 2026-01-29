import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/screens/favorite_page.dart';
import 'package:social_media_app/screens/home_page.dart';
import 'package:social_media_app/screens/post_page.dart';
import 'package:social_media_app/screens/profile_page.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIdx = 0;
  List<Widget> navItems = [
    HomePage(),
    PostPage(),
    FavoritePage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        elevation: 6,
        iconSize: 30,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.heart),
            activeIcon: const Icon(CupertinoIcons.heart_fill),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIdx = index;
          });
        },
      ),

      body: IndexedStack(index: currentIdx, children: navItems),
    );
  }
}

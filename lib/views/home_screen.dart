import 'package:flutter/material.dart';
import 'package:tiktok_tutorial/helper/constants.dart';
import 'package:tiktok_tutorial/views/add_video_screen.dart';
import 'package:tiktok_tutorial/views/chat_screen.dart';
import 'package:tiktok_tutorial/views/profile_screen.dart';
import 'package:tiktok_tutorial/views/search_screen.dart';
import 'package:tiktok_tutorial/views/video_screen.dart';

import 'package:tiktok_tutorial/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  final int? videoInitialIndex;
  const HomeScreen({Key? key, this.videoInitialIndex}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;
  getPageMethod(int index) {
    List pages = [
      VideoScreen(
        initialIndex: widget.videoInitialIndex ?? 0,
      ),
      SearchScreen(),
      const AddVideoScreen(),
      const ChatScreen(),
      ProfileScreen(uid: authController.user.uid),
    ];
    return pages[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              pageIdx = idx;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: backgroundColor,
          selectedItemColor: Colors.orange[700],
          unselectedItemColor: Colors.grey,
          currentIndex: pageIdx,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: CustomIcon(),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 30),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
          ],
        ),
        body: getPageMethod(pageIdx));
  }
}

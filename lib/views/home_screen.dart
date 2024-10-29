import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_tutorial/helper/constants.dart';
import 'package:tiktok_tutorial/views/add_video_screen.dart';
import 'package:tiktok_tutorial/views/chat_screen.dart';
import 'package:tiktok_tutorial/views/profile_screen.dart';
import 'package:tiktok_tutorial/views/search_screen.dart';
import 'package:tiktok_tutorial/views/video_screen.dart';

import 'package:tiktok_tutorial/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  int index;
  final String? videoInitialIndex;

  HomeScreen({
    Key? key,
    this.videoInitialIndex,
    this.index = 0,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    pageIdx = widget.index;
  }

  int pageIdx = 0;
  getPageMethod(int index) {
    List pages = [
      VideoScreen(
        videoId: widget.videoInitialIndex ?? "null",
      ),
      SearchScreen(),
      const AddVideoScreen(),
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
              label: 'Add',
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

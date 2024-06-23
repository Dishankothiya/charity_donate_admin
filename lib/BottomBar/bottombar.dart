import 'package:bottom_bar/bottom_bar.dart';
import 'package:charity_admin/BottomBar/NotificationPage/notificationScreen.dart';
import 'package:charity_admin/BottomBar/SettingPage/settingScreen.dart';
import 'package:charity_admin/BottomBar/UserPage/UserScreen.dart';
import 'package:charity_admin/Config/appColor.dart';
import 'package:flutter/material.dart';

import 'HomePage/homeScreen.dart';

class bottomBar extends StatefulWidget {
  const bottomBar({super.key});

  @override
  State<bottomBar> createState() => _bottomBarState();
}

class _bottomBarState extends State<bottomBar> {
  int _currentPage = 0;
  final _pageController = PageController();
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          homeScreen(),
          userScreen(),
          notificationScreen(),
          settingScreen()
          // savedScreen(),
          // notificationScreen(),
          // settingScreen()
        ],
        onPageChanged: (index) {
          // Use a better state management solution
          // setState is used for simplicity
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        backgroundColor: AppColor.whiteColor,
        showActiveBackgroundColor: true,
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
          BottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Charity Users'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
          BottomBarItem(
              icon: const Icon(Icons.notifications),
              title: const Text('Notification'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
          BottomBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              activeColor: AppColor.appColor,
              inactiveColor: AppColor.greyColor.withOpacity(0.9)),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/screens/settings.dart';
import 'package:untitled5/utils/colors_manager.dart';

import 'home_view.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> mainScreenWidgets = [
    const HomeView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: mainScreenWidgets[_currentIndex],
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: ColorsManager.primaryBackground,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Settings',
            ),
          ],
        ));
  }
}




// BottomNavigationBar(
//         backgroundColor: ColorsManager.primaryBackground,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.info),
//             label: 'About',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: (int index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//       ),
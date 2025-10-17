import 'package:flutter/material.dart';
import 'package:flippra/screens/homescreens/home/home_screen_category.dart';
import 'package:flippra/screens/homescreens/vendors/recievedleds.dart';
import '../../widget/home/header.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreenCategoryScreen(),
    RecievedLeds(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          CustomTabHeader(
            slant: 28,
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          // Page Content with Slide Transition
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0), // Slide from bottom
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
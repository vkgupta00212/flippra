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
  bool _isFirstBuild = true;

  // Use unique keys for AnimatedSwitcher to trigger transitions
  static final List<GlobalKey> _pageKeys = [
    GlobalKey(),
    GlobalKey(),
  ];

  // Pages list with keys
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreenCategoryScreen(key: _pageKeys[0]),
      RecievedLeds(key: _pageKeys[1]),
    ];
  }

  void _onTabSelected(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER: Safe + Fixed height + Post-frame rebuild
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: CustomTabHeader(
                slant: 28,
                selectedIndex: _selectedIndex,
                onTabSelected: _onTabSelected,
              ),
            ),
          ),

          // PAGE CONTENT
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) {
                if (_isFirstBuild) {
                  _isFirstBuild = false;
                  return child;
                }
                final isForward = _pages.indexOf(child) > _selectedIndex;
                final beginOffset = isForward
                    ? const Offset(1.0, 0.0)
                    : const Offset(-1.0, 0.0);
                return SlideTransition(
                  position: Tween<Offset>(begin: beginOffset, end: Offset.zero)
                      .animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
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
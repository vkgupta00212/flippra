import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:marquee/marquee.dart';
import '../../widget/vendor/header.dart';
import '../../widget/vendor/request/requestvendorcard.dart';
import '../../../backend/servicerequest/showservicerequest.dart';

class RecievedLeds extends StatefulWidget {
  const RecievedLeds({super.key});

  @override
  _RecievedLedsState createState() => _RecievedLedsState();
}

class _RecievedLedsState extends State<RecievedLeds> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final showrequest = Get.put(ShowServiceRequest());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    showrequest.requestuser();
    showrequest.startAutoRefresh(intervalSeconds: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const VendorHeader(),
            const SizedBox(height: 10,),
            CustomTabBar(),
            const SizedBox(height: 10,),
            _buildNewsTicker(),
            Expanded(
              child: StreamBuilder<List<ShowServiceRequestModel>>(
                stream: showrequest.requestuserstream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No requests found"));
                  }

                  final requests = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                    child: ListView.separated(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return RequestVendorCard1(request: request);
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        color: Colors.grey.shade500,
                        indent: 8,
                        endIndent: 8,
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }

  Widget _buildNewsTicker() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF00B3A7), const Color(0xFF008080)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Marquee(
        text: "Filipra Private Limited | News Live   ",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        velocity: 40.0,
        blankSpace: 100,
        pauseAfterRound: const Duration(seconds: 2),
        startPadding: 16,
        accelerationCurve: Curves.easeInOut,
        decelerationCurve: Curves.easeInOut,
      ),
    );
  }
}

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      color: Colors.white,
      elevation: 8,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.description, "Leads", 1),
            Container(
            ),
            _buildNavItem(Icons.group, "Referral", 2),
            _buildNavItem(Icons.people, "My Team", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.purple.shade700 : Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.purple.shade700 : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({Key? key}) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;

  final List<String> _tabs = ["Enquiry", "Leads", "Orders"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11.5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ?  Color(0xFF00B3A7) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
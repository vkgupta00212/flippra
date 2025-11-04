import 'dart:async';
import 'package:flippra/backend/getuser/getuser.dart';
import 'package:flippra/backend/vendor/getvendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import '../../../backend/request_accept/updatevendorstatus.dart';
import '../../widget/vendor/header.dart';
import '../../widget/vendor/request/requestvendorcard.dart';
import '../../../backend/servicerequest/showservicerequest.dart';
import '../../../utils/shared_prefs_helper.dart'; // if you have this for phone storage

class RecievedLeds extends StatefulWidget {
  const RecievedLeds({super.key});

  @override
  _RecievedLedsState createState() => _RecievedLedsState();
}

class _RecievedLedsState extends State<RecievedLeds>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final showrequest = Get.put(ShowServiceRequest());
  String pendingCount = "0";
  final ShowVendors _showvendor = Get.put(ShowVendors());

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

    // 🔹 Fetch user details once
    _fetchUserDetails();

    // 🔹 Start fetching request stream
    showrequest.requestuser();
    showrequest.startAutoRefresh(intervalSeconds: 1);

    showrequest.requestuserstream.listen((requests) {
      setState(() {
        pendingCount = requests.length.toString();
      });
    });
  }
  /// ✅ Fetch Vendor Details
  Future<void> _fetchUserDetails() async {
    try {
      final phone = await SharedPrefsHelper.getPhoneNumber();

      if (phone == null || phone.isEmpty) {
        print("⚠️ [RecievedLeds] Phone number not found!");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.context != null) {
            Get.snackbar(
              "Error",
              "No phone number found. Please login again.",
              backgroundColor: Colors.red.shade400,
              colorText: Colors.white,
            );
          }
        });
        return;
      }

      print("📞 Fetching vendor details for phone: $phone");
      await _showvendor.fetchVendors(
        token: "wvnwivnoweifnqinqfinefnq",
        vendorPhone: phone,
      );

      if (_showvendor.vendors.isNotEmpty) {
        print("✅ Vendor fetched: ${_showvendor.vendors.first.vendorName} "
            "(ID: ${_showvendor.vendors.first.id})");
      } else {
        print("❌ No vendor data returned from API");
      }
    } catch (e) {
      debugPrint("❌ Error fetching vendor: $e");
    }
  }

  /// ✅ Handle Accept
  Future<void> handleAccept() async {
    print("🟢 Vendor status update (Accept) called");
    const token = "wvnwivnoweifnqinqfinefnq";

    try {
      // 🔹 Make sure vendor list is loaded
      if (_showvendor.vendors.isEmpty) {
        print("📥 Fetching vendor before updating status...");
        await _fetchUserDetails();
      }

      if (_showvendor.vendors.isEmpty) {
        Get.snackbar(
          "Error",
          "No vendor data found. Please try again.",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
        return;
      }

      // 🔹 Get Vendor ID
      final vendorId = _showvendor.vendors.first.id.toString();
      if (vendorId.isEmpty) {
        Get.snackbar(
          "Error",
          "Vendor ID missing. Please try again.",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
        return;
      }

      print("🪪 Vendor ID: $vendorId");

      // 🔹 Call Update API
      final success = await UpdateVendorStatusApi.updateVendorStatus(
        token: token,
        vendorId: vendorId,
        status: "Accepted",
        Price: "",
      );

      if (success) {
        print("✅ Vendor accepted successfully!");
        Get.snackbar(
          "Success",
          "Vendor accepted successfully!",
          backgroundColor: Colors.green.shade500,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print("❌ Failed to update vendor status.");
        Get.snackbar(
          "Failed",
          "Unable to accept vendor. Try again later.",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("❌ Exception in handleAccept: $e");
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  /// 🔴 Handle Reject
  Future<void> handleReject() async {
    print("🔴 Vendor status update (Reject) called");
    const token = "wvnwivnoweifnqinqfinefnq";

    try {
      if (_showvendor.vendors.isEmpty) {
        print("📥 Fetching vendor before updating status...");
        await _fetchUserDetails();
      }

      if (_showvendor.vendors.isEmpty) {
        Get.snackbar(
          "Error",
          "No vendor data found. Please try again.",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
        return;
      }

      final vendorId = _showvendor.vendors.first.id.toString();
      if (vendorId.isEmpty) {
        Get.snackbar(
          "Error",
          "Vendor ID missing. Please try again.",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
        return;
      }

      print("🪪 Vendor ID: $vendorId");

      final success = await UpdateVendorStatusApi.updateVendorStatus(
        token: token,
        vendorId: vendorId,
        status: "Declined",
        Price: "0",
      );

      if (success) {
        print("✅ Vendor rejected successfully!");
        Get.snackbar(
          "Success",
          "Vendor rejected successfully!",
          backgroundColor: Colors.orange.shade500,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print("❌ Failed to reject vendor.");
        Get.snackbar(
          "Failed",
          "Unable to reject vendor. Try again later.",
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("❌ Exception in handleReject: $e");
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            VendorHeader(pending: pendingCount),
            const SizedBox(height: 10),
            const CustomTabBar(),
            const SizedBox(height: 10),
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

                  // ✅ Only show Pending requests
                  final requests = snapshot.data!.where((r) => r.status == "Pending").toList();

                  if (requests.isEmpty) {
                    return const Center(child: Text("No pending requests found"));
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                    child: ListView.separated(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequestVendorCard1(request: request),
                            const SizedBox(height: 8),
                            Center(
                              child: DualSliderButton(
                                onEnquiry: handleReject,
                                onRequest: handleAccept,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
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
            )

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
        gradient: const LinearGradient(
          colors: [Color(0xFF00B3A7), Color(0xFF008080)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Marquee(
        text: "Flippra Private Limited | News Live   ",
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
              color: isSelected
                  ? Colors.purple.shade700
                  : Colors.grey.shade600,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.purple.shade700
                    : Colors.grey.shade600,
                fontSize: 12,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
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
            Container(),
            _buildNavItem(Icons.group, "Referral", 2),
            _buildNavItem(Icons.people, "My Team", 3),
          ],
        ),
      ),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

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
                  color: isSelected
                      ? const Color(0xFF00B3A7)
                      : Colors.grey[300],
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

class DualSliderButton extends StatefulWidget {
  final VoidCallback onEnquiry;
  final VoidCallback onRequest;

  const DualSliderButton({
    Key? key,
    required this.onEnquiry,
    required this.onRequest,
  }) : super(key: key);

  @override
  _DualSliderButtonState createState() => _DualSliderButtonState();
}

class _DualSliderButtonState extends State<DualSliderButton> with SingleTickerProviderStateMixin {
  double _position = 0;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _labelOpacityAnimationLeft;
  late Animation<double> _labelOpacityAnimationRight;
  late Animation<double> _positionAnimation;
  bool _isDoneIcon = false;
  String? _successMessage;
  bool _isResetting = false;
  double? _startPosition;
  double? _targetPosition;

  @override
  void initState() {
    super.initState();
    // Initialize position to center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.of(context).size.width * 0.8;
      const circleSize = 36.0;
      setState(() {
        _position = (width - circleSize) / 2;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey[350],
      end: const Color(0xFF00B3A7),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
    _labelOpacityAnimationLeft = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    _labelOpacityAnimationRight = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    _positionAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut, // Replaced Curves.spring with Curves.bounceOut
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final height = 40.0;
    const circleSize = 35.0;
    final centerPosition = (width - circleSize) / 2;
    final minLimit = width * 0.02;
    final maxLimit = width * 0.98 - circleSize;

    double effectivePosition;
    if (_isResetting) {
      effectivePosition = _startPosition! + (_targetPosition! - _startPosition!) * _positionAnimation.value;
    } else {
      effectivePosition = _position;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF00B3A7).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            gradient: LinearGradient(
              colors: [
                _colorAnimation.value!.withOpacity(0.85),
                _colorAnimation.value!,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1 - _textFadeAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: AnimatedOpacity(
                        opacity: _position < centerPosition ? _labelOpacityAnimationLeft.value : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          "Reject | leds",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28),
                      child: AnimatedOpacity(
                        opacity: _position > centerPosition ? _labelOpacityAnimationRight.value : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          "Accept leds",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_successMessage != null)
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Center(
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: effectivePosition,
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    HapticFeedback.lightImpact();
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position += details.delta.dx;
                      _position = _position.clamp(minLimit, maxLimit);
                      final progress = ((_position - minLimit) / (maxLimit - minLimit) - 0.5).abs() * 2;
                      _controller.value = progress.clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    _targetPosition = centerPosition;
                    if (_position <= minLimit + 12) {
                      // Slide left → Enquiry
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _position = minLimit;
                        _isDoneIcon = true;
                        _successMessage = " Reject leds";
                      });
                      await _controller.forward();
                      await Future.delayed(const Duration(milliseconds: 1000));
                      widget.onEnquiry();
                      setState(() {
                        _isDoneIcon = false;
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _successMessage = null;
                        _position = centerPosition;
                      });
                    } else if (_position >= maxLimit - 12) {
                      // Slide right → Request
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _position = maxLimit;
                        _isDoneIcon = true;
                        _successMessage = "Accept leds";
                      });
                      await _controller.forward();
                      await Future.delayed(const Duration(milliseconds: 1000));
                      widget.onRequest();
                      setState(() {
                        _isDoneIcon = false;
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _successMessage = null;
                        _position = centerPosition;
                      });
                    } else {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _position = centerPosition;
                      });
                    }
                  },
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1.2,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: const Color(0xFF00B3A7).withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Icon(
                          _isDoneIcon ? Icons.done : Icons.arrow_forward_ios,
                          key: ValueKey<bool>(_isDoneIcon),
                          size: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
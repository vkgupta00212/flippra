import 'package:flippra/backend/getuser/getuser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/shared_prefs_helper.dart';

class CustomTabHeader extends StatefulWidget {
  const CustomTabHeader({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    this.slant = 28,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final double slant;

  @override
  State<CustomTabHeader> createState() => _CustomTabHeaderState();
}

class _CustomTabHeaderState extends State<CustomTabHeader> {
  late int _currentIndex;
  final GetUser _getuser = Get.put(GetUser());

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
    _loadUser();
  }

  Future<void> _loadUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber(); // ✅ Await phone
    if (phone != null) {
      await _getuser.getuserdetails(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );
    } else {
      print("⚠️ No phone number found in SharedPreferences");
    }
  }

  void _handleTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTabSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 12;
    const double overlap = 2;
    const Color activeColor = Colors.white;
    const Color inactiveColor = Color(0xFF00B3A7);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _handleTabTap(0),
                child: ClipPath(
                  clipper: _LeftSlantClipper(slant: widget.slant, overlap: overlap),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _currentIndex == 0 ? activeColor : inactiveColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Obx(() {
                      final isLoading = _getuser.isLoading.value;
                      final users = _getuser.users;

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: _currentIndex == 0 ? inactiveColor : activeColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLoading
                                    ? "Loading..."
                                    : (users.isNotEmpty
                                    ? "${users.first.firstName} ${users.first.lastName}"
                                    : "Guest"),
                                style: TextStyle(
                                  color: _currentIndex == 0 ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: _currentIndex == 0 ? Colors.black : Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Silver",
                                    style: TextStyle(
                                      color: _currentIndex == 0 ? Colors.black : Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _handleTabTap(1),
                child: ClipPath(
                  clipper: _RightSlantClipper(slant: widget.slant, overlap: overlap),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _currentIndex == 1 ? activeColor : inactiveColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Filipra",
                              style: TextStyle(
                                color: _currentIndex == 1 ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: _currentIndex == 1 ? Colors.blue : Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Silver Seller",
                                  style: TextStyle(
                                    color: _currentIndex == 1 ? Colors.black : Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.store,
                            color: _currentIndex == 1 ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftSlantClipper extends CustomClipper<Path> {
  _LeftSlantClipper({required this.slant, this.overlap = 0});
  final double slant;
  final double overlap;

  @override
  Path getClip(Size size) {
    final s = slant.clamp(0, size.width);
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width + overlap, 0)
      ..lineTo(size.width - s, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _LeftSlantClipper oldClipper) =>
      oldClipper.slant != slant || oldClipper.overlap != overlap;
}

class _RightSlantClipper extends CustomClipper<Path> {
  _RightSlantClipper({required this.slant, this.overlap = 0});
  final double slant;
  final double overlap;

  @override
  Path getClip(Size size) {
    final s = slant.clamp(0, size.width);
    return Path()
      ..moveTo(s - overlap, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height + overlap)
      ..close();
  }

  @override
  bool shouldReclip(covariant _RightSlantClipper oldClipper) =>
      oldClipper.slant != slant || oldClipper.overlap != overlap;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/getuser/getuser.dart';
import '../../../utils/shared_prefs_helper.dart';

class BusinessHeader extends StatefulWidget {
  const BusinessHeader({super.key});

  @override
  State<BusinessHeader> createState() => _BusinessHeaderState();
}

class _BusinessHeaderState extends State<BusinessHeader> {
  final GetUser _getuser = Get.put(GetUser());

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    if (phone != null) {
      await _getuser.getuserdetails(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );
    } else {
      print("⚠️ No phone number found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      // Show loading if user is not fetched yet
      if (_getuser.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Safely get user data
      final user =
      _getuser.users.isNotEmpty ? _getuser.users.first : null;

      return GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Business Header tapped')),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(screenWidth * 0.02),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with status indicator
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: screenWidth * 0.1,
                      backgroundImage: const AssetImage("assets/avatar.png")
                      as ImageProvider,
                      child: const Icon(Icons.person,
                          color: Colors.grey, size: 40)
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(3),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: screenWidth * 0.05),
              // Business info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user?.firstName} ${user?.lastName}" ?? "Filipra Private Limited",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.045,
                        color: const Color(0xFF00B3A7),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Personal profile",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      "Code: Ashu 9811",
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

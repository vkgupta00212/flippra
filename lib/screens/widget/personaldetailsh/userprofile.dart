import 'package:flippra/screens/widget/personaldetailsh/updateprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant.dart';
import '../../../backend/getuser/getuser.dart';
import '../../../utils/shared_prefs_helper.dart';
import '../../../backend/update/update.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GetUser _getuser = Get.put(GetUser());
  final UpdateUser _updateuser = Get.put(UpdateUser());

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 0,
      ),
      body: Obx(() {
        final isLoading = _getuser.isLoading.value;
        final users = _getuser.users;
        if (_getuser.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 1),
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey.shade50,
                  ],),
                borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.avatarBackground,
                                child: Text(
                                  isLoading
                                      ? "Loading"
                                      : users.first.firstName[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.pillButtonGradientStart,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLoading
                                          ? "Loading..."
                                          : (users.isNotEmpty
                                              ? "${users.first.firstName}${users.first.lastName}"
                                              : "Guest"),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "+91 ${users.first.phoneNumber}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.pillButtonGradientStart,
                            size: 19,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Details',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDetailRow(
                            Icons.email, 'Email', users.first.email, 0, 3),
                        _buildDetailRow(Icons.location_city, 'City',
                            users.first.city, 1, 3),
                        _buildDetailRow(
                            Icons.person, 'Gender', users.first.gender, 2, 3),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, int index, int total) {
    BorderRadius radius;
    if (index == 0) {
      radius = const BorderRadius.only(
          topRight: Radius.circular(12), topLeft: Radius.circular(12));
    } else if (index == total - 1) {
      radius = const BorderRadius.only(
        bottomRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    } else {
      radius = BorderRadius.zero;
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(
            vertical: 1,
            horizontal: 1,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
              color: AppColors.containerBackground,
              borderRadius: radius,
              gradient: LinearGradient(
                colors: [
                  AppColors.footerGradientEnd,
                  AppColors.pillButtonGradientStart,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadowColor, // Updated color
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: AppColors.iconGradientStart, width: 1)),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), // Rounded square
                ),
                child: Icon(
                  icon,
                  color: AppColors.pillButtonGradientStart, // Updated color
                  size: 25, // Slightly larger icon
                  semanticLabel: 'icon', // Accessibility
                ),
              ),
              SizedBox(width: 1), // Responsive spacing
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12, // Larger font for readability
                    fontWeight: FontWeight.w500, // Medium weight for hierarchy
                    color: AppColors.primaryText, // Updated color
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

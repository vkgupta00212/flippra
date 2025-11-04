import 'dart:ffi';
import 'dart:ui';
import 'package:flippra/screens/widget/businessprofile/businesscard.dart';
import 'package:flippra/screens/widget/businessprofile/footer.dart';
import 'package:flippra/screens/widget/businessprofile/header.dart';
import 'package:flippra/screens/widget/businessprofile/secondheader.dart';
import 'package:flippra/screens/widget/order/wishlistscreen.dart';
import 'package:flippra/screens/widget/personaldetailsh/bankdetailsh.dart';
import 'package:flippra/screens/widget/personaldetailsh/businessdetailsh.dart';
import 'package:flippra/screens/widget/personaldetailsh/kycdetailsh.dart';
import 'package:flippra/screens/widget/personaldetailsh/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flippra/core/constant.dart';

import '../utils/shared_prefs_helper.dart';
import 'get_otp_screen.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  int selectedIndex = 0;
  int footerIndex = 0;

// ──────────────────────────────────────────────────────────────────────
//  Inside _BusinessScreenState (replace the old logoutUser function)
// ──────────────────────────────────────────────────────────────────────
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(fontSize: 15),
          ),
          actions: [
            // ── Cancel ──
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // ── OK ──
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pillButtonGradientStart,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If user pressed OK
    if (confirmed == true) {
      await SharedPrefsHelper.clearUserData();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const GetOtpScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  final Map<String, dynamic> userData = {
    "firstName": "Vishal",
    "lastName": "Gupta",
    "Gender": "Male",
    "Email": "vishal@example.com",
    "City": "Mumbai",
    "phonenumber": "+91 9876543210",
  };
  List<List<Map<String, dynamic>>> get tabData => [
    [
      {"icon": Icons.wallet, "title": "Balance", "screen": null},
      {
        "icon": Icons.history,
        "title": "Transaction History",
        "screen": null
      },
    ],
    [
      {
        "icon": Icons.people_alt,
        "title": "Refferal | program",
        "screen": null
      },
      {
        "icon": Icons.real_estate_agent,
        "title": "Reselling program",
        "screen": null
      },
      {
        "icon": Icons.webhook_sharp,
        "title": "Affiliate | program",
        "screen": null
      },
      {
        "icon": Icons.people_outline_rounded,
        "title": "Royalty | program",
        "screen": null
      },
      {
        "icon": Icons.discount,
        "title": "Coupon code | program",
        "screen": null
      },
    ],
    [
      {
        "icon": Icons.person_pin,
        "title": "Profile | Details",
        "screen": UserProfile(),
      },
      {
        "icon": Icons.verified,
        "title": "KYC | image upload GST",
        "screen": KYCViewer(),
      },
      {
        "icon": Icons.monetization_on_sharp,
        "title": "Bank | Details",
        "screen": BankDetailsScreen(),
      },
      {
        "icon": Icons.verified,
        "title": "Business | Details",
        "screen": ShopDetailsScreen(),
      },
      {
        "icon": Icons.logout_rounded,
        "title": "Account | Logout",
        "onTap": null,
      },
    ],
    [
      {
        "icon": Icons.add_shopping_cart,
        "title": "Cart | product",
        "screen": null
      },
      {"icon": Icons.history, "title": "My | order", "screen": null},
      {
        "icon": Icons.monetization_on_sharp,
        "title": "Retan | Refund order",
        "screen": null
      },
      {
        "icon": Icons.favorite_border,
        "title": "Watchlist | product",
        "screen": PackageListPage(),
      },
    ],
    [
      {
        "icon": Icons.privacy_tip_sharp,
        "title": "Privacy & policy",
        "screen": null
      },
      {
        "icon": Icons.sticky_note_2_sharp,
        "title": "Terms & condition",
        "screen": null
      },
      {
        "icon": Icons.sticky_note_2_sharp,
        "title": "About us",
        "screen": null
      },
    ],
    [
      {
        "icon": Icons.help_outline,
        "title": "Help & Support",
        "screen": null
      },
      {"icon": Icons.support_agent, "title": "Support", "screen": null},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Business Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const BusinessHeader(),
            SizedBox(height: screenHeight * 0.01),
            SecondHeader(
              selectedIndex: selectedIndex,
              onTabSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.containerBackground, // Updated color
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.containerShadowColor, // Updated color
                      blurRadius: 5,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.01,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: ListView.builder(
                    key: ValueKey<int>(selectedIndex),
                    physics: const BouncingScrollPhysics(),
                    itemCount: tabData[selectedIndex].length,
                    itemBuilder: (context, index) {
                      final entry = tabData[selectedIndex][index];
                      return Padding(
                        padding:
                        EdgeInsets.only(bottom: screenHeight * 0.015),
                        child: GestureDetector(
                          onTap: () async {
                            final onTap = entry['onTap'];
                            final screen = entry['screen'] as Widget?;

                            // ✅ Handle Logout manually
                            if (entry['title'] == "Account | Logout") {
                              await _showLogoutConfirmation(context);
                              return;
                            }

                            if (onTap != null && onTap is Function(BuildContext)) {
                              onTap(context);
                            } else if (screen != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => screen),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${entry["title"]} tapped')),
                              );
                            }
                          },

                          child: BusinessCard(
                            icon: entry['icon'] as IconData,
                            title: entry['title'] as String,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BusinessFooter(
          selectedIndex: selectedIndex,
          onFooterSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
            }
        ),
      ),

    );
  }
}
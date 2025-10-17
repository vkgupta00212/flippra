import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant.dart';

class BusinessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const BusinessCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(
          vertical: 1,
          horizontal: 10,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.containerBackground, // Updated color
          borderRadius: BorderRadius.circular(10), // Softer corners
          gradient: LinearGradient(
            colors: [
              AppColors.footerGradientEnd, // Updated color (Colors.grey.shade100)
              AppColors.pillButtonGradientStart, // Updated color (Teal)
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
          border: Border.all(color: AppColors.iconGradientStart,width: 1)
        ),
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
                semanticLabel: '$title icon', // Accessibility
              ),
            ),
            SizedBox(width: screenWidth * 0.04), // Responsive spacing
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12, // Larger font for readability
                  fontWeight: FontWeight.w500, // Medium weight for hierarchy
                  color: AppColors.primaryText, // Updated color
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.closeIcon, // Updated color
            ),
          ],
        ),
      ),
    );
  }
}
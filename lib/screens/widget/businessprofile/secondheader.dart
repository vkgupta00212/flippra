import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const SecondHeader({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final tabs = [
      {"icon": Icons.account_balance_wallet, "label": "My | E-Wallet"},
      {"icon": Icons.group, "label": "Refferal | App"},
      {"icon": Icons.credit_card, "label": "Personal | Details"},
      {"icon": Icons.inventory_2, "label": "My | Order"},
    ];

    return Container(
      margin: EdgeInsets.all(screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.03,
        horizontal: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16), // Softer corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: Semantics(
              label: tabs[index]["label"] as String,
              selected: isSelected,
              child: InkWell(
                onTap: () => onTabSelected(index),
                borderRadius: BorderRadius.circular(12),
                child: _TabItem(
                  icon: tabs[index]["icon"] as IconData,
                  label: tabs[index]["label"] as String,
                  isSelected: isSelected,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const primaryColor = Color(0xFF00B3A7);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? [
                  primaryColor.withOpacity(0.2),
                  primaryColor.withOpacity(0.1),
                ]
                    : [
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50), // Rounded square
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 25, // Slightly larger icon
              color: isSelected ? primaryColor : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.026, // Responsive font size
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? primaryColor : Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenWidth * 0.01),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isSelected ? screenWidth * 0.1 : 0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
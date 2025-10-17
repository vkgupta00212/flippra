import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for typography

class Bottomnavbar extends StatefulWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onBoxTap;
  final VoidCallback? onToggle;

  const Bottomnavbar({
    Key? key,
    this.onProfileTap,
    this.onBoxTap,
    this.onToggle,
  }) : super(key: key);

  @override
  _BottomnavbarState createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  bool _isToggleRight = false;

  void _toggleVideoIconPosition() {
    setState(() {
      _isToggleRight = !_isToggleRight;
    });
    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.0045, // Responsive padding
          horizontal: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF00B3A7).withOpacity(0.9), // Softer teal
              const Color(0xFF006D5B).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), // Slightly larger radius
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Softer shadow
              blurRadius: 8,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Semantics(
              label: 'Profile button',
              child: InkWell(
                onTap: () {
                  widget.onProfileTap?.call();
                },
                borderRadius: BorderRadius.circular(50),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1), // Slightly larger padding
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/profile_placeholder.png',
                            width: isTablet ? 38 : 34, // Responsive size
                            height: isTablet ? 38 : 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12 : screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Semantics(
              label: 'Toggle video button',
              child: InkWell(
                onTap: _toggleVideoIconPosition,
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isTablet ? 90 : 80,
                  height: 44, // Slightly taller for better tap area
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 400), // Smoother transition
                          curve: Curves.easeInOutCubicEmphasized,
                          alignment: _isToggleRight
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00B3A7).withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/icons/play_button.png',
                              width: isTablet ? 34 : 30,
                              height: isTablet ? 34 : 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Semantics(
              label: 'Box button',
              child: InkWell(
                onTap: () {
                  widget.onBoxTap?.call();
                },
                borderRadius: BorderRadius.circular(50),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icons/box.png',
                          width: isTablet ? 34 : 30,
                          height: isTablet ? 34 : 30,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Box',
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 12 : screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
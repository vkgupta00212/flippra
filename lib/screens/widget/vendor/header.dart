import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class VendorHeader extends StatelessWidget {
  const VendorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.19; // Responsive width (22% of screen width)
    final isTablet = screenWidth >= 600; // Adjust for tablet screens

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!], begin: Alignment.topLeft, end: Alignment.bottomRight, ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xFF00B3A7), width: 1),
          boxShadow: [
            BoxShadow( color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4), ), ], ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: FadeInLeft(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: isTablet ? 200 : screenWidth * 0.3, // Responsive width
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '7456',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.wallet,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: FadeInLeft(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: isTablet ? 200 : screenWidth * 0.3, // Responsive width
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Enquiry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: InfoCard(
                    icon: Icons.sell,
                    value: "7556",
                    label: "Reselling\nOrders",
                    width: cardWidth,
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: InfoCard(
                    icon: Icons.cancel_rounded,
                    value: "7556",
                    label: "Cancelled\nOrders",
                    width: cardWidth,
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: InfoCard(
                    icon: Icons.verified,
                    value: "7556",
                    label: "Successful\nOrders",
                    width: cardWidth,
                  ),
                ),
                FadeInUp(
                  duration: const Duration(milliseconds: 900),
                  child: InfoCard(
                    icon: Icons.pending_actions_sharp,
                    value: "7556",
                    label: "Pending\nOrders",
                    width: cardWidth,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final double width;

  const InfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.width,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Icon(
              widget.icon,
              size: isTablet ? 28 : 28,
              color: Color(0xFF00B3A7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 12 : 9,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
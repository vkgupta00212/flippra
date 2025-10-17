import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MyOrderVendorCard extends StatelessWidget {
  const MyOrderVendorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildMyOrderVendor();
  }
}

Widget _buildMyOrderVendor() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF00B3A7),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 95, // enough space for image + rating badge
                    child: Column(
                      children: [
                        // Profile Image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/icons/business_card_placeholder.png"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Rating Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "5.0",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Row(
                                children: const [
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 12),
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 12),
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 12),
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 12),
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 12),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "499",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Car Service",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Full AC repairing and clean spirit AC",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            "assets/icons/business_card_placeholder.png"),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              VendorFooter(),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  'Accept | leds',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget VendorFooter() {
  return Container(
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.white, size: 18),
        Icon(Icons.emoji_emotions_outlined, color: Colors.white, size: 18),
        Icon(Icons.perm_identity_outlined, color: Colors.white, size: 18),
        Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
        Icon(Icons.wifi_off, color: Colors.white, size: 18),
      ],
    ),
  );
}

class MyOrderVendorHeader extends StatelessWidget {
  const MyOrderVendorHeader({super.key});

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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Icon(
              widget.icon,
              size: isTablet ? 28 : 18,
              color: Colors.white,
            ),
          ),
          // Use ScaleIn if animate_do is resolved
          /*
          ScaleIn(
            duration: const Duration(milliseconds: 400),
            child: Icon(
              widget.icon,
              size: isTablet ? 28 : 24,
              color: Colors.white,
            ),
          ),
          */
          const SizedBox(height: 2),
          Text(
            widget.value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 12 : 9,
              color: Colors.white70,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
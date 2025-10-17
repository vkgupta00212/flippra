import 'package:flutter/material.dart';

class VendorCard extends StatelessWidget {
  const VendorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBusinessCard();
  }
}

Widget _buildBusinessCard() {
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

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../addcustomer.dart';

class CartFooter extends StatelessWidget {
  const CartFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.19; // Responsive width (22% of screen width)
    final isTablet = screenWidth >= 600; // Adjust for tablet screens

    return Container(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!], begin: Alignment.topLeft, end: Alignment.bottomRight, ),
          boxShadow: [
            BoxShadow( color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 4), ), ], ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locationCard(
              title: "Delhi - 6",
              subtitle: "Delhi sadar bazar near Axis Bank",
              avatars: [
                "https://i.pravatar.cc/150?img=1",
                "https://i.pravatar.cc/150?img=2",
                "https://i.pravatar.cc/150?img=3",
              ],
              onAddPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // makes it expand nicely
                  backgroundColor: Colors.transparent,
                  builder: (context) => const CustomerAddSheet(),
                );
              },
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: FadeInLeft(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      width: isTablet ? 200 : screenWidth * 0.4, // Responsive width
                      height: 50,
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
                        children: [
                          const Text(
                            'Request | Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                            ),
                            width: isTablet ? 28 : 25, // same as your icon size
                            height: isTablet ? 28 : 25,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                "assets/icons/request.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
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
                      width: isTablet ? 200 : screenWidth * 0.4, // Responsive width
                      height: 50,
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
                        children: [

                          Container(
                            width: isTablet ? 28 : 30, // same as your icon size
                            height: isTablet ? 28 : 30,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/icons/whatsapp.png", // put your image path here
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Link | Share',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
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
          ],
        ),
    );
  }
}

Widget locationCard({
  required String title,
  required String subtitle,
  required List<String> avatars,
  VoidCallback? onAddPressed,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 10.0,top: 10.0,bottom: 10.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: Colors.red, size: 28),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 15,),
        Row(
          children: [
            Row(
              children: [
                ...avatars.map((avatar) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ClipOval(
                      child: Image.network(
                        avatar,
                        width: 45,   // custom width
                        height: 45,  // custom height
                        fit: BoxFit.cover,
                      ),
                    )
                )),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 1, top: 4),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Color(0xFF00B3A7)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)
                  )
              ),
              child: IconButton(
                icon: const Icon(Icons.person_add, color: Colors.black),
                onPressed: onAddPressed,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

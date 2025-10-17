import 'package:flippra/screens/widget/custominfoscreen.dart';
import 'package:flutter/material.dart';

import '../backend/category/getbusinesscards/getbusinesscard.dart';



class RequestScreen extends StatelessWidget {
  final GetBusinessCardModel card;

  const RequestScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Softer background for better contrast
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessCard(card),
            Expanded(
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: const CombinedScreen(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 220, // Slightly wider button
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600], // Aligned with theme
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  shadowColor: Colors.teal.withOpacity(0.3),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/homecategory');
                },
                child:
                    Text(
                      "Home",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildBusinessCard(GetBusinessCardModel card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24.0),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Image Section
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(card.fullImageUrl), // ✅ API image
                ),
              ),
            ),
            const SizedBox(width: 20),
            // ✅ Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.productName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        card.price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            card.rating,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

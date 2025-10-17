import 'package:flippra/screens/requestoption.dart';
import 'package:flutter/material.dart';

class CartCard extends StatelessWidget{
  const CartCard({super.key});

  @override
  Widget build(BuildContext context) {
   return Container(
       child: _buildBusinessCard(context),
   );
  }
}

Widget _buildBusinessCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.only(left: 20.0,top: 15,bottom: 15),
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
          Container(
            width: 80,
            height: 80,
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
                image: AssetImage("assets/icons/business_card_placeholder.png"),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Car Service",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Full AC repairing and clean spirit AC",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const RequestOption(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                          ) // pill shape
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Request | Sent',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
import 'package:flippra/screens/widget/cart/cartcard.dart';
import 'package:flippra/screens/widget/cart/footer.dart';
import 'package:flippra/screens/widget/cart/header.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ...List.generate(3, (index) => const CartCard()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Footer now has fixed height
      bottomNavigationBar: const SizedBox(
        height: 175, // adjust as per your design
        child: CartFooter(),
      ),
    );
  }
}

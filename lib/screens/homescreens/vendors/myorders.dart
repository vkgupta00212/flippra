import 'package:flippra/screens/widget/vendor/myorder/myordervendorcard.dart';
import 'package:flutter/material.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          MyOrderVenderHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.separated(
                itemCount: 4,
                itemBuilder: (context, index) => const MyOrderVendorCard(),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  color: Colors.grey,
                  indent: 16,   // optional → left padding
                  endIndent: 16, // optional → right padding
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyOrderVenderHeader extends StatelessWidget {
  const MyOrderVenderHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Search Bar
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search orders...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Filter Button
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    // TODO: Add filter logic here
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
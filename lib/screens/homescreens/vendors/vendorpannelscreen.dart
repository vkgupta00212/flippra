import 'package:flippra/screens/homescreens/vendors/myorders.dart';
import 'package:flippra/screens/homescreens/vendors/recievedleds.dart';
import 'package:flutter/material.dart';

import '../../widget/vendor/footer.dart';


class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  bool isRequestSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: isRequestSelected
            ? const RecievedLeds()
            : const MyOrders(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: VendorFooter(
          isRequestSelected: isRequestSelected,
          onTabSelected: (value) {
            setState(() {
              isRequestSelected = value;
            });
          },
        ),
      ),
    );
  }
}

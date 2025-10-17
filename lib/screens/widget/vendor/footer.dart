import 'package:flutter/material.dart';

class VendorFooter extends StatefulWidget {
  final bool isRequestSelected;
  final ValueChanged<bool> onTabSelected; // callback

  const VendorFooter({
    super.key,
    required this.isRequestSelected,
    required this.onTabSelected,
  });

  @override
  State<VendorFooter> createState() => _VendorFooterState();
}

class _VendorFooterState extends State<VendorFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTabSelected(true),
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.isRequestSelected
                      ? const LinearGradient(
                    colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Request",
                  style: TextStyle(
                    color: widget.isRequestSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTabSelected(false),
              child: Container(
                decoration: BoxDecoration(
                  gradient: !widget.isRequestSelected
                      ? const LinearGradient(
                    colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "My Order",
                  style: TextStyle(
                    color: !widget.isRequestSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flippra/screens/widget/chatscreen.dart';
import 'package:flippra/screens/widget/ratingscreen.dart';

import 'ordercancel.dart';

class OrderDetailsBottomSheet extends StatefulWidget {
  const OrderDetailsBottomSheet({super.key});

  @override
  State<OrderDetailsBottomSheet> createState() =>
      _OrderDetailsBottomSheetState();
}

class _OrderDetailsBottomSheetState extends State<OrderDetailsBottomSheet> {
  String selectedTab = "timeline";

  void _handleTabSelected(String value) {
    setState(() {
      if (selectedTab == value) {
        selectedTab = "timeline";
      } else {
        selectedTab = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: selectedTab == "timeline"
                      ? ListView(
                    key: const ValueKey(1),
                    controller: controller,
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Order | Details | Update",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Timeline steps
                      buildStep(
                        title: "Accept Order",
                        description:
                        "The seller or e-commerce platform receives the order.",
                        time: "10-August-2025. 5:30 PM",
                        isActive: true,
                        isCompleted: true,
                      ),
                      buildStep(
                        title: "Order Processing",
                        description:
                        "The seller begins processing the order.",
                        isActive: true,
                        isCompleted: true,
                      ),
                      buildStep(
                        title: "Packaging",
                        description:
                        "The ordered items are securely packaged.",
                        time: "10-August-2025. 5:30 PM",
                        isActive: true,
                        isCompleted: true,
                      ),
                      buildStep(
                        title: "Shipping",
                        description:
                        "The packaged items are handed to the courier.",
                        isActive: true,
                        isCompleted: false,
                        highlightColor: Colors.orange,
                      ),
                      buildStep(
                        title: "Transit",
                        description:
                        "The provider delivers the package.",
                        isActive: false,
                        isCompleted: false,
                      ),
                      buildStep(
                        title: "Delivery",
                        description:
                        "The package arrives at the destination address.",
                        isActive: false,
                        isCompleted: false,
                      ),
                    ],
                  )
                      : const RatingScreen()
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF00B3A7),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 👇 open cancel bottom sheet
                          CancelReasonBottomSheet.show(context);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00B3A7),
                                  width: 1,
                                ),
                                color: Colors.orange.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.description,
                                color: Color(0xFF00B3A7),
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Cancel Reason",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Footer buttons
                      Expanded(
                        child: VendorFooter(
                          selectedTab: selectedTab,
                          onTabSelected: _handleTabSelected,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildStep({
  required String title,
  required String description,
  String? time,
  bool isActive = false,
  bool isCompleted = false,
  Color highlightColor = Colors.green,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted
                  ? highlightColor
                  : (isActive ? highlightColor : Colors.grey),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 2,
            height: 60,
            color: isCompleted || isActive
                ? highlightColor.withOpacity(0.5)
                : Colors.grey[400],
          ),
        ],
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted || isActive ? highlightColor : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
              if (time != null) ...[
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    ],
  );
}

class VendorFooter extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const VendorFooter({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected("like"),
              child: Container(
                decoration: BoxDecoration(
                  gradient: selectedTab == "like"
                      ? const LinearGradient(
                    colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: selectedTab == "like" ? null : Colors.grey[400],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.thumb_up_sharp,
                    size: 20, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected("chat"),
              child: Container(
                decoration: BoxDecoration(
                  gradient: selectedTab == "chat"
                      ? const LinearGradient(
                    colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: selectedTab == "chat" ? null : Colors.grey[400],
                ),
                alignment: Alignment.center,
                child:
                const Icon(Icons.chat, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

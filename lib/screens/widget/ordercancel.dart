import 'package:flutter/material.dart';

class CancelReasonBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const CancelReasonContent(),
    );
  }
}

class CancelReasonContent extends StatefulWidget {
  const CancelReasonContent({super.key});

  @override
  State<CancelReasonContent> createState() => _CancelReasonContentState();
}

class _CancelReasonContentState extends State<CancelReasonContent> {
  int selectedReason = 0;

  final List<Map<String, dynamic>> reasons = [
    {
      "icon": Icons.delivery_dining,
      "title": "Late | Delivery",
      "subtitle": "Add a little bit of body text",
    },
    {
      "icon": Icons.inventory_2_outlined,
      "title": "Defected | product",
      "subtitle": "Add a little bit of body text",
    },
    {
      "icon": Icons.sentiment_dissatisfied,
      "title": "Bad | Sarvice",
      "subtitle": "Add a little bit of body text",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Text(
                  "cancel reason",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  final item = reasons[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedReason == index
                            ? Colors.orange
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: selectedReason,
                      onChanged: (val) {
                        setState(() => selectedReason = val!);
                      },
                      activeColor: Colors.orange,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      title: Row(
                        children: [
                          Icon(item["icon"], color: Colors.black, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item["title"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.edit,
                                        size: 16, color: Colors.grey),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["subtitle"],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Dropdown placeholder
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: const [
                        Text("Cancel Order",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle submit action
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

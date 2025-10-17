import 'package:flutter/material.dart';
import '../../backend/category/getacceptvendor/getacceptvendor.dart';


class CombinedScreen extends StatefulWidget {
  const CombinedScreen({super.key});

  @override
  State<CombinedScreen> createState() => _CombinedScreenState();
}

class _CombinedScreenState extends State<CombinedScreen> {
  late Future<List<GetAcceptedVendorModel>> _futureVendors;

  @override
  void initState() {
    super.initState();
    _futureVendors = GetAcceptedVendor.getacceptedvendor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<GetAcceptedVendorModel>>(
        future: _futureVendors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No vendors found"));
          }

          final vendors = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(5),
            itemCount: vendors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return PersonRow(
                vendor: vendor,
                isFirst: index == 0,
                isLast: index == vendors.length - 1,
              );
            },
          );
        },
      ),
    );
  }
}



class PersonRow extends StatelessWidget {
  final GetAcceptedVendorModel vendor; // ✅ full vendor object
  final bool isFirst;
  final bool isLast;

  const PersonRow({
    super.key,
    required this.vendor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Smooth animation for layout changes
        curve: Curves.easeInOut,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline section
            Expanded(
              flex: 1,
              child: TimelineTile(
                name: vendor.vendorname,
                imageUrl: vendor.fullImageUrl,
                isFirst: isFirst,
                isLast: isLast,
              ),
            ),
            const SizedBox(width: 10), // Slightly increased spacing for clarity
            // Info card section
            Expanded(
              flex: 4,
              child: CustomInfoCard(
                name: vendor.vendorname,
                rating: vendor.rating,
                happy: vendor.happy,
                sad: vendor.sad,
                kyc: vendor.kyc,
                phone: vendor.vendorphone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomInfoCard extends StatelessWidget {
  final String name;
  final String rating;
  final String happy;
  final String sad;
  final String kyc;
  final String phone;

  const CustomInfoCard({
    super.key,
    required this.name,
    required this.rating,
    required this.happy,
    required this.sad,
    required this.kyc,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row - Info Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InfoCard(icon: Icons.star, value: rating, label: "Rating"),
              const SizedBox(width: 10),
              InfoCard(icon: Icons.sentiment_satisfied, value: happy, label: "Happy"),
              const SizedBox(width: 10),
              InfoCard(icon: Icons.sentiment_dissatisfied, value: sad, label: "Sad"),
              const SizedBox(width: 10),
              InfoCard(icon: Icons.verified, value: kyc, label: "KYC"),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom Row - Chat & Call
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/chat.png",
                        width: 28,
                        height: 28,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 1),
                      const Text("Chat", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/call.png",
                        width: 28,
                        height: 28,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 1),
                      Text("Call", style: const TextStyle(color: Colors.teal)),
                    ],
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

class InfoCard extends StatelessWidget {
  final IconData icon; // use IconData for Flutter icons
  final String value;
  final String label;

  const InfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,          // use IconData here
            size: 20,
            color: Colors.teal,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String name;
  final String imageUrl; // Image URL from API
  final bool isFirst;
  final bool isLast;

  const TimelineTile({
    super.key,
    required this.name,
    required this.imageUrl,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // Increased height for better spacing
      child: Column(
        children: [
          // Top connecting line
          if (!isFirst)
            Expanded(
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey[500]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

          // Image with circular background
          Container(
            padding: const EdgeInsets.all(3), // Slightly larger padding
            decoration: BoxDecoration(
              color: Colors.white, // White background for cleaner look
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: 60, // Slightly larger image
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 8), // Increased spacing
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16, // Slightly larger text
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Bottom connecting line
          if (!isLast)
            Expanded(
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[500]!, Colors.grey[300]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


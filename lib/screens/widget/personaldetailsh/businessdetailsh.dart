import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/businessdetailsh/getbusinessdetailsh.dart';
import 'package:get/get.dart';
import '../../../core/constant.dart';
import '../../../utils/shared_prefs_helper.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final GetShopController _shopController = Get.put(GetShopController());

  Future<void> _fetchShopData() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    if (phone != null) {
      print("📱 Phone from SharedPrefs: $phone"); // Debug print

      await _shopController.getShopDetails(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );

      // ✅ Print the fetched data
      print("🛒 Number of shops fetched: ${_shopController.shops.length}");
      for (var shop in _shopController.shops) {
        print("🏪 Shop ID: ${shop.id}");
        print("🏪 Shop Name: ${shop.shopName}");
        print("🏪 Description: ${shop.descriptions}");
        print("🏪 Address: ${shop.shopAddress}");
        print("🏪 Type: ${shop.type}");
        print("🏪 Phone: ${shop.phone}");
        print("🏪 Image: ${shop.shopImage}");
      }
    } else {
      print("⚠️ No phone number found in SharedPreferences");
      // Optionally show a snackbar or dialog to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No phone number found. Please log in again.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchShopData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 0,
        centerTitle: false,
      ),
      body: Obx(() {
        if (_shopController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_shopController.shops.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No shop details found.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchShopData,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }
        final shop = _shopController.shops.first;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          shop.shopImage,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow('Shop Name', shop.shopName,0,5),
                    _buildDetailRow('Description', shop.descriptions,1,5),
                    _buildDetailRow('Address', shop.shopAddress,2,5),
                    _buildDetailRow('Type', shop.type,3,5),
                    _buildDetailRow('Phone', shop.phone,4,5),
                  ],
                ),
              ),
            ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value, int index, int total) {
    BorderRadius radius;
    if (index == 0) {
      radius = const BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      );
    } else if (index == total - 1) {
      radius = const BorderRadius.only(
        bottomRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      );
    } else {
      radius = BorderRadius.zero;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.containerBackground,
          borderRadius: radius,
          gradient: LinearGradient(
            colors: [
              AppColors.footerGradientEnd.withOpacity(0.8),
              AppColors.pillButtonGradientStart.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          border: Border.all(
              color: AppColors.iconGradientStart.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(1),
            //   decoration: BoxDecoration(
            //     color: AppColors.pillButtonGradientStart,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Icon(
            //     icon,
            //     color: AppColors.iconGradientStart,
            //     size: 24,
            //     semanticLabel: label,
            //   ),
            // ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
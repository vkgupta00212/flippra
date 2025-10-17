import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../backend/order/getwishlistorder.dart';

class PackageListPage extends StatelessWidget {
  final GetWishListOrder controller = Get.put(GetWishListOrder());
  PackageListPage({Key? key}) : super(key: key);

  // Format price
  String formattedPrice(String pricing) {
    try {
      final price = double.parse(pricing);
      return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(price);
    } catch (_) {
      return '₹$pricing';
    }
  }

  Widget _buildPackageCard(GetWishListModel data) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey,width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 1, // Square image for grid
              child: Image.network(
                data.pckgimage.isNotEmpty
                    ? data.pckgimage
                    : 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.pckgname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  formattedPrice(data.price),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.getWishlist(
      token: "wvnwivnoweifnqinqfinefnq",
      phone: "7700818001",
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist Packages")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        if (controller.wishlist.isEmpty) {
          return const Center(child: Text("No wishlist packages found."));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // two per row
            mainAxisSpacing:50,
            crossAxisSpacing: 10,
            childAspectRatio: 0.99, // adjust height of card
          ),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            return _buildPackageCard(controller.wishlist[index]);
          },
        );
      }),
    );
  }
}

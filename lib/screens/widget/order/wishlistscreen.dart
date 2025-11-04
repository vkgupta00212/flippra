import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../backend/order/getwishlistorder.dart';
import '../../../core/constant.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({Key? key}) : super(key: key);

  @override
  State<PackageListPage> createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  final GetWishListOrder controller = Get.put(GetWishListOrder());

  final String token = "wvnwivnoweifnqinqfinefnq";
  final String phone = "7700818001";

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  Future<void> _fetchWishlist() async {
    await controller.getWishlist(token: token, phone: phone);
  }

  String formattedPrice(String pricing) {
    try {
      final price = double.parse(pricing);
      return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(price);
    } catch (_) {
      return '₹$pricing';
    }
  }

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(height: 140, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, width: 110, color: Colors.grey),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 70, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(GetWishListModel data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE ──
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(
                  data.pckgimage.isNotEmpty
                      ? data.pckgimage
                      : 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
                  fit: BoxFit.cover,
                  loadingBuilder: (c, child, progress) =>
                  progress == null ? child : _shimmerImage(),
                  errorBuilder: (_, __, ___) => _shimmerImage(),
                ),
              ),
            ),

            // ── TEXT ──
            Flexible(
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.pckgname,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedPrice(data.price),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.pillButtonGradientStart,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerImage() => Container(
    color: Colors.grey[200],
    child: const Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // ---- RESPONSIVE GRID ----
    final width = MediaQuery.of(context).size.width;
    final crossCount = width > 600 ? 3 : 2;
    final aspect = width > 600 ? 0.85 : 0.78;

    return Scaffold(
      // ── APP BAR ──
      appBar: AppBar(
        title: const Text(
          "Wishlist Packages",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w200,color: Colors.black),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        foregroundColor: Colors.black,
        elevation: 2,
        centerTitle: false,
      ),

      // ── BODY ──
      body: RefreshIndicator(
        onRefresh: _fetchWishlist,
        color: AppColors.pillButtonGradientStart,
        child: Obx(() {
          // ── LOADING ──
          if (controller.isLoading.value) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: aspect,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => _shimmerCard(),
            );
          }

          // ── ERROR ──
          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: Colors.red.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      "Something went wrong",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _fetchWishlist,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pillButtonGradientStart,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── EMPTY ──
          if (controller.wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    "Your wishlist is empty",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Add packages you love!",
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            );
          }

          // ── DATA ──
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: aspect,
            ),
            itemCount: controller.wishlist.length,
            itemBuilder: (c, i) => _buildPackageCard(controller.wishlist[i]),
          );
        }),
      ),
    );
  }
}
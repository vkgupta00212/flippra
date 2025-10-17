import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../backend/rating/rating.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 4.5;
  int? serviceQuality;
  final RatingService ratingService = Get.put(RatingService());
  final TextEditingController _commentController = TextEditingController();

  Future<void> _submitRating() async {
    if (serviceQuality == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select Good or Bad Service")),
      );
      return;
    }

    final success = await ratingService.insertRating(
      token: "wvnwivnoweifnqinqfinefnq", // 🔑 Replace with actual token dynamically
      rating: rating.toString(),
      goodService: serviceQuality == 1 ? "Yes" : "No",
      badServices: serviceQuality == -1 ? "Yes" : "No",
      comment: _commentController.text,
      orderId: "123", // 🔑 Replace with actual OrderID dynamically
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ratingService.message.value)),
      );
      _commentController.clear(); // ✅ clear input
      Navigator.pop(context); // ✅ go back after success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ ${ratingService.message.value}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Text(
                "Reviews & Ratings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Share your experience with this service",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // ⭐ Rating Bar
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 42,
                unratedColor: Colors.grey.shade300,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) => setState(() => rating = value),
              ),
              const SizedBox(height: 12),

              Text(
                "Your Rating: ${rating.toStringAsFixed(1)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // 👍 / 👎 Good or Bad Service
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => serviceQuality = 1),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: serviceQuality == 1
                              ? Colors.green.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: serviceQuality == 1
                                ? Colors.green
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.thumb_up_alt_rounded,
                                color: Colors.green, size: 30),
                            SizedBox(height: 6),
                            Text(
                              "Good Service",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => serviceQuality = -1),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: serviceQuality == -1
                              ? Colors.red.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: serviceQuality == -1
                                ? Colors.red
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.thumb_down_alt_rounded,
                                color: Colors.red, size: 30),
                            SizedBox(height: 6),
                            Text(
                              "Bad Service",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // ✍️ Comment + Send Button
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: "Write a review...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        minLines: 1,
                        maxLines: null,
                      ),
                    ),
                    GestureDetector(
                      onTap: _submitRating, // 👈 call function here
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B3A7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

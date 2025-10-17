import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetWishlistModel {
  final int id;
  final String PackageID;
  final String PackName;
  final String Pricing;
  final String Phone;

  GetWishlistModel({
    required this.id,
    required this.PackageID,
    required this.PackName,
    required this.Pricing,
    required this.Phone,
  });

  factory GetWishlistModel.fromJson(Map<String, dynamic> json) {
    return GetWishlistModel(
      id: json['ID'] ?? 0,
      PackageID: json['PackageID'] ?? "",
      PackName: json['PackName'] ?? "",
      Pricing: json['Pricing'] ?? "",
      Phone: json['Phone'] ?? "",
    );
  }
}

class GetWishList extends GetxController {
  final isLoading = false.obs;
  final wishlist = <GetWishlistModel>[].obs;
  final errMessage = ''.obs;
  final successMessage = ''.obs;

  /// Insert Wishlist
  Future<void> insertWishlist({
    required String token,
    required String pckgId,
    required String pckgName,
    required String pricing,
    required String phone,
  }) async {
    final url = Uri.parse(
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/InsertWishlist");

    try {
      isLoading.value = true;
      errMessage.value = '';
      successMessage.value = '';

      // Proper key-value map
      final body = {
        "token": token,
        "PackageID": pckgId,
        "PackName": pckgName,
        "Pricing": pricing,
        "Phone": phone,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final message = data['Message'] ?? "No message";

        successMessage.value = message;
        print("✅ Wishlist Response: $message");
      } else {
        errMessage.value = "Server Error: ${response.statusCode}";
        print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      errMessage.value = "Error inserting wishlist: $e";
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

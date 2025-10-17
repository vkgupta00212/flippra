import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShopModel {
  final int id;
  final String shopName;
  final String descriptions;
  final String shopAddress;
  final String shopImage;
  final String type;
  final String phone;

  ShopModel({
    required this.id,
    required this.shopName,
    required this.descriptions,
    required this.shopAddress,
    required this.shopImage,
    required this.type,
    required this.phone,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['ID'] ?? 0,
      shopName: json['ShopName'] ?? '',
      descriptions: json['Descriptions'] ?? '',
      shopAddress: json['ShopAddress'] ?? '',
      shopImage: json['ShopImage'] ?? '',
      type: json['Type'] ?? '',
      phone: json['Phone'] ?? '',
    );
  }
}

class GetShopController extends GetxController {
  final isLoading = false.obs;
  final shops = <ShopModel>[].obs;

  Future<void> getShopDetails({
    required String token,
    required String phone,
  }) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowBussinessDetails",
    );

    try {
      isLoading.value = true;
      print("🔹 Fetching shop details for phone: $phone");

      // Prepare the request body with the correct parameter name
      final body = {
        'token': token,
        'Phone': phone,
      };
      print("📤 Request body: $body");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body.map((key, value) => MapEntry(key, value.toString())),
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Raw response: ${response.body}");

      if (response.statusCode == 200) {
        // Extract JSON array from XML-like response
        final match = RegExp(r'\[.*\]').firstMatch(response.body);
        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);

          shops.value = data.map((e) => ShopModel.fromJson(e)).toList();
          print("✅ Shops fetched: ${shops.length}");
        } else {
          shops.clear();
          print("⚠️ No JSON array found in response.");
        }
      } else {
        shops.clear();
        print("⚠️ API returned status code: ${response.statusCode}");
      }
    } catch (e) {
      shops.clear();
      print("❌ Error fetching shop details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
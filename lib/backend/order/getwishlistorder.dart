import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetWishListModel {
  final int id;
  final String pckgid;
  final String pckgname;
  final String pckgimage;
  final String price;
  final String phone;

  GetWishListModel({
    required this.id,
    required this.pckgid,
    required this.pckgname,
    required this.pckgimage,
    required this.price,
    required this.phone,
  });

  factory GetWishListModel.fromJson(Map<String, dynamic> json) {
    return GetWishListModel(
      id: json['ID'] ?? 0,
      pckgid: json['PackageID'] ?? "",
      pckgname: json['PackName'] ?? "",
      pckgimage: json['PImages'] ?? "",
      price: json['Pricing'] ?? "",
      phone: json['Phone'] ?? "",
    );
  }
}

class GetWishListOrder extends GetxController {
  final isLoading = false.obs;
  final wishlist = <GetWishListModel>[].obs;
  final errorMessage = ''.obs;

  Future<void> getWishlist({
    required String token,
    required String phone,
  }) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowWishlist",
    );

    try {
      isLoading.value = true;
      errorMessage.value = '';
      wishlist.clear();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'Phone': phone,
        },
      );

      if (response.statusCode == 200) {
        String body = response.body;

        // 🛑 Sometimes .asmx APIs wrap JSON inside XML tags
        // Example: <string xmlns="...">[{"ID":1,...}]</string>
        final regex = RegExp(r'\[.*\]');
        final match = regex.firstMatch(body);
        if (match != null) {
          body = match.group(0)!;
        }

        final List<dynamic> data = json.decode(body);

        wishlist.value =
            data.map((e) => GetWishListModel.fromJson(e)).toList();
      } else {
        errorMessage.value =
        "Failed to load wishlist. Status: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}

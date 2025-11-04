import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// 🧾 Vendor Model
class VendorModel {
  final int id;
  final String vendorName;
  final String vendorEmail;
  final String vendorPhone;
  final String vendorImg;
  final String work;
  final String type;
  final String vendorType;
  final String lat;
  final String log;
  final String price;

  VendorModel({
    required this.id,
    required this.vendorName,
    required this.vendorEmail,
    required this.vendorPhone,
    required this.vendorImg,
    required this.work,
    required this.type,
    required this.vendorType,
    required this.lat,
    required this.log,
    required this.price,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json["ID"] ?? 0,
      vendorName: json["VendorName"] ?? "",
      vendorEmail: json["VendorEmail"] ?? "",
      vendorPhone: json["VendorPhone"] ?? "",
      vendorImg: json["VendorImg"] ?? "",
      work: json["Work"] ?? "",
      type: json["Type"] ?? "",
      vendorType: json["VendorType"] ?? "",
      lat: json["lat"] ?? "",
      log: json["log"] ?? "",
      price: json["Price"] ?? "0",
    );
  }
}

/// 🌐 Controller to fetch vendors
class ShowVendors extends GetxController {
  final isLoading = false.obs;
  final vendors = <VendorModel>[].obs;

  /// 📡 Fetch vendors from API
  Future<void> fetchVendors({
    required String token,
    required String vendorPhone,
  }) async {
    const String apiUrl =
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowVendors";

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "token": token,
          "VendorPhone": vendorPhone,
        },
      );

      if (response.statusCode == 200) {
        final bodyString = response.body;

        // 🧩 The API might wrap JSON inside XML, so we extract the array part
        final match = RegExp(r'\[.*\]').firstMatch(bodyString);
        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);
          vendors.value = data.map((e) => VendorModel.fromJson(e)).toList();
        } else {
          vendors.clear();
        }
      } else {
        vendors.clear();
      }
    } catch (e) {
      print("❌ Error fetching vendors: $e");
      vendors.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class KycModel {
  final String id;
  final String AadharFront;
  final String AadharBack;
  final String PencardFront;
  final String PencardBack;
  final String Gst;
  final String Phone;

  KycModel({
    required this.id,
    required this.AadharFront,
    required this.AadharBack,
    required this.PencardFront,
    required this.PencardBack,
    required this.Gst,
    required this.Phone,
  });

  factory KycModel.fromJson(Map<String, dynamic> json) {
    return KycModel(
      id: json['ID'] ?? '',
      AadharFront: json['AadharFront'] ?? '',
      AadharBack: json['AadharBack'] ?? '',
      PencardFront: json['IFSC'] ?? '',
      PencardBack: json['Branch'] ?? '',
      Gst: json['Gst'] ?? '',
      Phone: json['Phone'] ?? '',
    );
  }
}

class GetKyc extends GetxController {
  final isLoading = false.obs;
  final kyc = <KycModel>[].obs;
  final errorMessage = ''.obs; // Store specific error message

  Future<void> getkyc({
    required String token,
    required String phone,
  }) async {
    // Placeholder endpoint; replace with the correct one
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowKyc",
    );

    try {
      isLoading.value = true;
      errorMessage.value = ''; // Reset error message
      print("🔹 Fetching bank details for phone: $phone");

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
        final match = RegExp(r'\[.*\]').firstMatch(response.body);
        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);
          kyc.value = data.map((e) => KycModel.fromJson(e)).toList();
          print("✅ Banks fetched: ${kyc.length}");
        } else {
          kyc.clear();
          errorMessage.value = "No valid data found in response.";
          print("⚠️ No JSON array found in response.");
        }
      } else {
        kyc.clear();
        errorMessage.value =
        "API error: ${response.statusCode}. ${response.body.contains('InvalidOperationException') ? 'Invalid API method name.' : ''}";
        print("⚠️ API returned status code: ${response.statusCode}");
      }
    } catch (e) {
      kyc.clear();
      errorMessage.value = "Error fetching bank details: $e";
      print("❌ Error fetching bank details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
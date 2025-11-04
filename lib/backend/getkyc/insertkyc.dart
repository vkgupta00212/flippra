import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertKycController extends GetxController {
  final isLoading = false.obs;
  final success = false.obs;
  final message = ''.obs;

  Future<void> insertKyc({
    required String token,
    required String aadharFront,
    required String aadharBack,
    required String pancardFront,
    required String pancardBack,
    required String gst,
    required String phone,
  }) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/InsertKyc",
    );

    try {
      isLoading(true);
      success(false);
      message('');

      print("🚀 Uploading KYC data for phone: $phone");

      final body = {
        "token": token,
        "AadharFront": aadharFront,
        "AadharBack": aadharBack,
        "PencardFront": pancardFront,
        "PencardBack": pancardBack,
        "Gst": gst,
        "Phone": phone,
      };
      print("📦 Body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      );

      print("📥 Response Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        // Extract {"Message":"inserted Successfully!"}
        final match = RegExp(r'\{.*\}').firstMatch(response.body);
        if (match != null) {
          final data = jsonDecode(match.group(0)!);
          message.value = data["Message"] ?? "No message";
          success.value = data["Message"] == "inserted Successfully!";
          print("✅ Message: ${message.value}");
        } else {
          message.value = "⚠️ Invalid response format";
          print("⚠️ No valid JSON found");
        }
      } else {
        message.value = "❌ Server error: ${response.statusCode}";
        print("❌ Server error ${response.statusCode}");
      }
    } catch (e) {
      message.value = "🔥 Exception: $e";
      print("🔥 Exception: $e");
    } finally {
      isLoading(false);
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateVendorStatusApi {
  static Future<bool> updateVendorStatus({
    required String token,
    required String vendorId,
    required String status,
    required String Price,
  }) async {
    const String apiUrl =
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/UpdateVendorStatus";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'VendorID': vendorId,
          'Status': status,
          'Price': Price,
        },
      );

      print("📩 Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final match = RegExp(r'\{.*\}').firstMatch(response.body);
        if (match == null) {
          print("❌ No JSON found in response: ${response.body}");
          return false;
        }

        final jsonString = match.group(0)!;
        final Map<String, dynamic> data = jsonDecode(jsonString);

        print("✅ Parsed UpdateVendorStatus response: $data");

        if (data["Message"]?.toString().toLowerCase().contains("success") ?? false) {
          return true;
        } else {
          print("⚠️ API responded but not success: ${data["Message"]}");
          return false;
        }
      } else {
        print("❌ Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Exception in UpdateVendorStatus: $e");
      return false;
    }
  }
}

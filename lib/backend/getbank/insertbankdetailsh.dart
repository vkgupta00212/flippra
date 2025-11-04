import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertBankController extends GetxController {
  // API URL
  final String _url =
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/InsertBankDetails";

  // Reactive variables for UI
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final errorMessage = ''.obs;

  /// Insert Bank Details API Function
  Future<void> insertBankDetails({
    required String token,
    required String accountNumber,
    required String ifsc,
    required String branch,
    required String accountHolder,
    required String bankName,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isSuccess.value = false;

      final uri = Uri.parse(_url);
      final body = {
        'token': token,
        'Accountnumber': accountNumber,
        'IFSC': ifsc,
        'Branch': branch,
        'Accountholder': accountHolder,
        'BankName': bankName,
        'Phone': phone,
      };

      print("📤 Sending bank details: $body");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        // ASMX APIs usually return <string>True</string> or <string>Success</string>
        final responseBody = response.body.toLowerCase();
        if (responseBody.contains("true") || responseBody.contains("inserted")) {
          isSuccess.value = true;
          print("✅ Bank details inserted successfully!");
        } else {
          errorMessage.value = "API returned failure response.";
          print("⚠️ API returned failure response.");
        }
      } else {
        errorMessage.value = "Server error: ${response.statusCode}";
        print("⚠️ Server error: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = "❌ Error: $e";
      print("❌ Exception during InsertBankDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

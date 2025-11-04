import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UpdateBankController extends GetxController {
  final isLoading = false.obs;
  final message = ''.obs;

  Future<bool> updateBankDetails({
    required String token,
    required String accountNumber,
    required String ifsc,
    required String branch,
    required String accountHolder,
    required String bankName,
    required String phone,
  }) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/UpdateBankDetails",
    );

    try {
      isLoading.value = true;
      message.value = '';

      final body = {
        'token': token,
        'Accountnumber': accountNumber,
        'IFSC': ifsc,
        'Branch': branch,
        'Accountholder': accountHolder,
        'BankName': bankName,
        'Phone': phone,
      };

      print("📤 Sending UpdateBankDetails request: $body");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        // Direct JSON decoding
        final Map<String, dynamic> data = jsonDecode(response.body);
        final msg = data['Message']?.toString() ?? "No message";

        message.value = msg;

        if (msg.toLowerCase().contains("updated")) {
          print("✅ Bank details updated successfully");
          return true;
        } else {
          print("⚠️ Unexpected response message: $msg");
          return false;
        }
      } else {
        message.value = "Failed: ${response.statusCode}";
        print("❌ API returned status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      message.value = "Error: $e";
      print("❌ Exception while updating bank details: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

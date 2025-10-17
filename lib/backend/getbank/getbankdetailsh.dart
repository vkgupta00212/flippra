import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BankModel {
  final String accountHolder;
  final String bankName;
  final String accountNumber;
  final String ifsc;
  final String branch;
  final String phone;

  BankModel({
    required this.accountHolder,
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.branch,
    required this.phone,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      accountHolder: json['Accountholder'] ?? '',
      bankName: json['BankName'] ?? '',
      accountNumber: json['Accountnumber'] ?? '',
      ifsc: json['IFSC'] ?? '',
      branch: json['Branch'] ?? '',
      phone: json['Phone'] ?? '',
    );
  }
}

class GetBankController extends GetxController {
  final isLoading = false.obs;
  final banks = <BankModel>[].obs;
  final errorMessage = ''.obs; // Store specific error message

  Future<void> getBankDetails({
    required String token,
    required String phone,
  }) async {
    // Placeholder endpoint; replace with the correct one
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowBankDetaile",
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
          banks.value = data.map((e) => BankModel.fromJson(e)).toList();
          print("✅ Banks fetched: ${banks.length}");
        } else {
          banks.clear();
          errorMessage.value = "No valid data found in response.";
          print("⚠️ No JSON array found in response.");
        }
      } else {
        banks.clear();
        errorMessage.value =
        "API error: ${response.statusCode}. ${response.body.contains('InvalidOperationException') ? 'Invalid API method name.' : ''}";
        print("⚠️ API returned status code: ${response.statusCode}");
      }
    } catch (e) {
      banks.clear();
      errorMessage.value = "Error fetching bank details: $e";
      print("❌ Error fetching bank details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
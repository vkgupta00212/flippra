// getbankdetailsh.dart
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
      accountHolder: json['Accountholder']?.toString() ?? '',
      bankName: json['BankName']?.toString() ?? '',
      accountNumber: json['Accountnumber']?.toString() ?? '',
      ifsc: json['IFSC']?.toString() ?? '',
      branch: json['Branch']?.toString() ?? '',
      phone: json['Phone']?.toString() ?? '',
    );
  }
}

class GetBankController extends GetxController {
  final isLoading = false.obs;
  final banks = <BankModel>[].obs;
  final errorMessage = ''.obs;

  /// Returns **true** when the request succeeded (even if the list is empty)
  /// Returns **false** only on network / server errors.
  Future<bool> getBankDetails({
    required String token,
    required String phone,
  }) async {
    const url =
        'https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowBankDetaile';

    try {
      isLoading.value = true;
      errorMessage.value = '';
      banks.clear();

      print('Fetching bank details for phone: $phone');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'Phone': phone,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Raw body: ${response.body}');

      // --------------------------------------------------------------
      // ASMX services usually wrap the JSON array inside something like:
      //   {"d":"[{\"Accountholder\":\"…\", …}]"}
      //   or just return the array directly.
      // --------------------------------------------------------------
      if (response.statusCode != 200) {
        errorMessage.value =
        'Server error ${response.statusCode}. Please try again.';
        return false;
      }

      // 1. Try to find a JSON array inside the response
      final match = RegExp(r'\[.*\]').firstMatch(response.body);
      if (match == null) {
        errorMessage.value = 'Invalid API response format.';
        return false;
      }

      final jsonString = match.group(0)!;
      final List<dynamic> data = jsonDecode(jsonString);

      // 2. Populate the observable list
      banks.assignAll(data.map((e) => BankModel.fromJson(e)).toList());

      // 3. **EMPTY LIST IS NOT AN ERROR** – user just hasn't added a bank yet
      if (banks.isEmpty) {
        print('No bank records found for this phone.');
        // **DO NOT** set errorMessage here
        return true; // request succeeded, list is just empty
      }

      print('Banks fetched: ${banks.length}');
      return true;
    } catch (e, st) {
      errorMessage.value = 'Network error: $e';
      print('Exception: $e\n$st');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
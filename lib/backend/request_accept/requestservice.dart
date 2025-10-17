import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RequestService extends GetxController {
  final isLoading = false.obs;
  final message = ''.obs;

  Future<bool> registerService({
    required String token,
    required String firstname,
    required String lastname,
    required String email,
    required String phoneNumber,
    required String images,
    required String service,
    required String cardid,
  }) async {
    final url = Uri.parse(
      'https://flippraa.anklegaming.live/APIs/APIs.asmx/AddRequestAssignVendor',
    );

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'FirstName': firstname,
          'LastName': lastname,
          'Email': email,
          'PhoneNumber': phoneNumber,
          'Images': images,
          'Service': service,
          'Cardid': cardid
        },
      );

      isLoading.value = false;

      if (response.statusCode != 200) {
        message.value = "Server error: ${response.statusCode}";
        return false;
      }

      final data = jsonDecode(response.body);
      final msg = data["Message"]?.toString().toLowerCase() ?? "";

      if (msg.contains("inserted") || msg.contains("success")) {
        message.value = "Request sent successfully ✅";
        return true;
      } else {
        message.value = data["Message"] ?? "Request failed ❌";
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      message.value = "Error: $e";
      return false;
    }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertQuery extends GetxController {
  final isLoading = false.obs;
  final message = ''.obs;

  Future<bool> insertquery({
    required String token,
    required String Name,
    required String Phone,
    required String Problem,
    required String Datetimes,
    required String Address,
  }) async {
    final url = Uri.parse(
      'https://flippraa.anklegaming.live/APIs/APIs.asmx/InsertQuery',
    );

    try {
      isLoading.value = true;
      print("🚀 [InsertQuery] Sending data to server...");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'Name': Name,
          'Phone': Phone,
          'Problem': Problem,
          'Datetimes': Datetimes,
          'Address': Address,
        },
      );

      isLoading.value = false;

      print("📩 [InsertQuery] Status Code: ${response.statusCode}");
      print("📦 [InsertQuery] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);

          // ✅ match exact "Inserted" (case-sensitive)
          if (data['Message']?.toString().toLowerCase() == "inserted") {
            message.value = "Query inserted successfully!";
            print("✅ [InsertQuery] Success: ${message.value}");
            return true;
          } else {
            message.value = data['Message'] ?? "Unknown response";
            print("⚠️ [InsertQuery] Response Message: ${message.value}");
            return false;
          }
        } catch (e) {
          print("⚠️ [InsertQuery] JSON parse error: $e");
          message.value = "Invalid response format";
          return false;
        }
      } else {
        print("❌ [InsertQuery] HTTP Error: ${response.statusCode}");
        message.value = "Failed: ${response.statusCode}";
        return false;
      }
    } catch (e, stack) {
      isLoading.value = false;
      print("🔥 [InsertQuery] Exception: $e");
      print(stack);
      message.value = "Exception: $e";
      return false;
    }
  }
}

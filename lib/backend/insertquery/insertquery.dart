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
        'https://flippraa.anklegaming.live/APIs/APIs.asmx/InsertQuery');
    try {
      isLoading.value = true;

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

      if (response.statusCode == 200) {
        print("✅ Query Sent");
        print(response.body);

        try {
          final Map<String, dynamic> data = jsonDecode(response.body);

          if (data['Message'] == "inserted") {
            message.value = "Rating inserted successfully";
            return true;
          } else {
            message.value = data['Message'] ?? "Unknown response";
            return false;
          }
        } catch (e) {
          print("⚠️ Could not parse response: $e");
          message.value = "Invalid response format";
          return false;
        }
      } else {
        print("❌ Failed with status: ${response.statusCode}");
        message.value = "Failed: ${response.statusCode}";
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      print("❌ Exception while inserting rating: $e");
      message.value = "Exception: $e";
      return false;
    }
  }
}

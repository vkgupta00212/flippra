import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateBusinessCard {
  /// Updates a business card by sending token, id, and request.
  /// Example response: {"Message": "Updated"}
  static Future<String> updateBusinessCard({
    required String id,
    required String request,
  }) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/UpdateBusinessCards",
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': "wvnwivnoweifnqinqfinefnq",
          'id': id,
          'Request': request,
        },
      );

      print("Status code : ${response.statusCode}");
      print("Raw response : ${response.body}");

      if (response.statusCode == 200) {
        dynamic decoded = jsonDecode(response.body);

        if (decoded is String) {
          decoded = jsonDecode(decoded);
        }

        final message = decoded["Message"] ?? "No message found";
        print("✅ API Response Message: $message");
        return message;
      } else {
        throw Exception(
          '❌ Failed to update business card. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("⚠️ Error during API call: $e");
      throw Exception("Error while updating business card: $e");
    }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SendMessegeController extends GetxController {
  final isLoading = false.obs;
  final message = ''.obs;
  final errMessage = ''.obs;

  Future<bool> sendMessege({
    required String token,
    required String messege,
    required String sendername,
    required String sendermail,
    required String recievername,
    required String recieveremail,
    required String Onlinestatus,
    required String readunreadstatus,
  }) async {
    final url = Uri.parse('https://flippraa.anklegaming.live/APIs/Chat.asmx/SendMessage');
    isLoading.value = true;
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'message': messege,
          'sendername': sendername,
          'sendermail': sendermail,
          'recievername': recievername,
          'recieveremail': recieveremail,
          'Onlinestatus': Onlinestatus,
          'readunreadstatus': readunreadstatus,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['message'] != null && decoded['message'] == "MSG SENT!") {
          print("✅ Message sent successfully");
          message.value = messege;
          return true;
        } else {
          errMessage.value = "❌ Failed to send message";
          print(errMessage.value);
          return false;
        }
      }else{
        errMessage.value = "❌ Server error: ${response.statusCode}";
        print(errMessage.value);
        return false;
      }
    }catch (e) {
      errMessage.value = "❌ Exception while sending message: $e";
      print(errMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

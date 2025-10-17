import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InsertServiceRequest extends GetxController {
  // API URL
  final String apiUrl = "https://flippraa.anklegaming.live/APIs/APIs.asmx/InsertServiceRequests";

  // Observables for loading and response state
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  /// Function to insert a new service request
  Future<String?> insertServiceRequest({
    required String token,
    required String requestID,
    required String productName,
    required String price,
    required String rating,
    required String images,
    required String childCategory,
    required String service,
    required String serviceType,
    required String vendorType,
    required String phoneNumber,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, String> body = {
        "token": token,
        "RequestID": requestID,
        "ProductName": productName,
        "Price": price,
        "Rating": rating,
        "Images": images,
        "ChildCategory": childCategory,
        "Service": service,
        "ServiceType": serviceType,
        "VendorType": vendorType,
        "PhoneNumber": phoneNumber,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        responseMessage.value = "Success";
        return response.body; // Return the raw response
      } else {
        responseMessage.value = "Failed: ${response.statusCode}";
        return null;
      }
    } catch (e) {
      responseMessage.value = "Error: $e";
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}

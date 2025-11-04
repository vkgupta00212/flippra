import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetUserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String city;
  final String phoneNumber;
  final String refercode;

  GetUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.city,
    required this.phoneNumber,
    required this.refercode,
  });

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['Gender'] ?? '',
      email: json['Email'] ?? '',
      city: json['City'] ?? '',
      phoneNumber: json['phonenumber'] ?? '',
      // ✅ Corrected key — matches backend: "Refercode"
      refercode: json['Refercode'] ?? '',
    );
  }
}

class GetUser extends GetxController {
  final isLoading = false.obs;
  final users = <GetUserModel>[].obs;

  Future<void> getuserdetails({
    required String token,
    required String phone,
  }) async {
    final url = Uri.parse(
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowRegisterUsers");

    try {
      isLoading.value = true;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'phonenumber': phone,
        },
      );

      if (response.statusCode == 200) {
        final bodyString = response.body;
        final match = RegExp(r'\[.*\]').firstMatch(bodyString);

        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);

          print("✅ Parsed user data: $data"); // optional debug

          users.value = data.map((e) => GetUserModel.fromJson(e)).toList();
        } else {
          users.clear();
        }
      } else {
        users.clear();
      }
    } catch (e) {
      print("❌ Error fetching user details: $e");
      users.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

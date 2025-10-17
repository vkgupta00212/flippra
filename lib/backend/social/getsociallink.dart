import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class GetSocialModel {
  final int id;
  final String link1;
  final String link2;
  final String link3;
  final String link4;
  final String link5;

  GetSocialModel(
      {required this.id,
      required this.link1,
      required this.link2,
      required this.link3,
      required this.link4,
      required this.link5});

  factory GetSocialModel.fromJson(Map<String, dynamic> json) {
    return GetSocialModel(
      id: json['ID'] ?? 0,
      link1: json['Link1'] ?? "",
      link2: json['Link2'] ?? "",
      link3: json['Link3'] ?? "",
      link4: json['Link4'] ?? "",
      link5: json['Link5'] ?? "",
    );
  }
}

class GetSocialLink extends GetxController {
  final isLoading = false.obs;
  final social = <GetSocialModel>[].obs;
  final errormessege = ''.obs;

  Future<void> getsociallinks({required String token}) async {
    final url = Uri.parse(
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowSociallinks");

    try {
      isLoading.value = true;
      print("📤 Sending request to API with token: $token");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {"token": token},
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Raw response: ${response.body}");

      if (response.statusCode == 200) {
        final match = RegExp(r'\[.*?\]').firstMatch(response.body); // non-greedy
        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);
          social.value = data.map((e) => GetSocialModel.fromJson(e)).toList();
          print("✅ Social links fetched: ${social.length}");
          for (var s in social) {
            print("🔗 Links: ${s.link1}, ${s.link2}, ${s.link3}, ${s.link4}, ${s.link5}");
          }
        } else {
          social.clear();
          errormessege.value = "No valid data found in response.";
          print("⚠️ No JSON array found in response.");
        }
      } else {
        social.clear();
        errormessege.value = "Failed to fetch social links: ${response.statusCode}";
        print("❌ Failed to fetch social links: ${response.statusCode}");
      }
    } catch (e) {
      social.clear();
      errormessege.value = "Error fetching social links: $e";
      print("❌ Error fetching social links: $e");
    } finally {
      isLoading.value = false;
    }
  }

}


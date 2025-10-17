import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetFormsModel {
  final int id;
  final String FormType;
  final String FormDescription;

  GetFormsModel({
    required this.id,
    required this.FormType,
    required this.FormDescription
});

  factory GetFormsModel.fromJson(Map<String, dynamic> json){
    return GetFormsModel(
      id: json['ID'] ?? 0,
      FormType: json['FormType'] ?? "",
      FormDescription: json['FormDescription'] ?? ""
    );
  }
}

class GetForms extends GetxController{
  final isLoading = false.obs;
  final forms = <GetFormsModel>[].obs;
  final erroMessege = ''.obs;

  Future<void> getforms({
    required String token,
    required String phone
  }) async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowForms");

    try{
      isLoading.value = true;
      print("🔹 Fetching shop details for phone: $phone");

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

      if (response.statusCode == 200) {
        final match = RegExp(r'\[.*\]').firstMatch(response.body);
        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);
          forms.value = data.map((e) => GetFormsModel.fromJson(e)).toList();
          print("✅ Banks fetched: ${forms.length}");
        } else {
          forms.clear();
          erroMessege.value = "No valid data found in response.";
          print("⚠️ No JSON array found in response.");
        }
      } else {
        forms.clear();
        erroMessege.value =
        "API error: ${response.statusCode}. ${response.body.contains('InvalidOperationException') ? 'Invalid API method name.' : ''}";
        print("⚠️ API returned status code: ${response.statusCode}");
      }

    }catch (e) {
      forms.clear();
      erroMessege.value = "Error fetching bank details: $e";
      print("❌ Error fetching bank details: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
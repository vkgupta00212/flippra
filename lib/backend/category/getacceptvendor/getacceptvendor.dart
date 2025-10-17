import 'dart:convert';
import 'package:http/http.dart' as http;

class GetAcceptedVendor {
  static Future<List<GetAcceptedVendorModel>> getacceptedvendor() async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowAcceptance",
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': "wvnwivnoweifnqinqfinefnq",
        'RequestID':"1",
      },
    );

    print("Status code : ${response.statusCode}");
    print("Raw response :\n ${response.body}");

    if (response.statusCode == 200) {
      dynamic decoded = jsonDecode(response.body);

      if (decoded is String) {
        decoded = jsonDecode(decoded);
      }

      final List<dynamic> jsonData = decoded;
      final List<GetAcceptedVendorModel> cards =
      jsonData.map((item) => GetAcceptedVendorModel.fromJson(item)).toList();

      print("Parsed Business Card List : ${cards.length} items");
      return cards;
    } else {
      throw Exception(
          '❌ Failed to load business cards. Status: ${response.statusCode}');
    }
  }
}

class GetAcceptedVendorModel {
  final int id;
  final int requestid;
  final String vendorname;
  final String vendorimg;
  final String vendorphone;
  final String rating;
  final String happy;
  final String sad;
  final String kyc;


  GetAcceptedVendorModel({
    required this.id,
    required this.requestid,
    required this.vendorname,
    required this.vendorimg,
    required this.vendorphone,
    required this.rating,
    required this.happy,
    required this.sad,
    required this.kyc
  });

  factory GetAcceptedVendorModel.fromJson(Map<String, dynamic> json) {
    return GetAcceptedVendorModel(
      id: json['id'] ?? 0,
      requestid: json['RequestId'] ?? 0,
      vendorname: json['VendorName'] ?? '',
      vendorimg: json['VendorImg'] ?? '',
      vendorphone:json['VendorPhone'] ?? '',
      rating: json['Rating'] ?? '',
      happy: json['Happy'] ?? '',
      sad: json['Sad'] ?? '',
      kyc: json['KYC'] ?? '',
    );
  }

  // Helper if you want to build full image URL
  String get fullImageUrl {
    return "https://flippraa.anklegaming.live/image/$vendorimg";
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class GetBusinessCard {
  static Future<List<GetBusinessCardModel>> getbusinesscard(String subcategoryid,String VendorType) async {
    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowBussinessCards",
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': "wvnwivnoweifnqinqfinefnq",
        'SubCategory': subcategoryid,
        'VendorType' : VendorType

      },
    );

    print("Status code : ${response.statusCode}");
    print("Raw response :\n ${response.body}");

    if (response.statusCode == 200) {
      dynamic decoded = jsonDecode(response.body);

      // Sometimes API wraps response as string -> decode again
      if (decoded is String) {
        decoded = jsonDecode(decoded);
      }

      final List<dynamic> jsonData = decoded;
      final List<GetBusinessCardModel> cards =
      jsonData.map((item) => GetBusinessCardModel.fromJson(item)).toList();

      print("Parsed Business Card List : ${cards.length} items");
      return cards;
    } else {
      throw Exception(
          '❌ Failed to load business cards. Status: ${response.statusCode}');
    }
  }
}

class GetBusinessCardModel {
  final int id;
  final String productName;
  final String price;
  final String rating;
  final String img;
  final String childCat;
  final String Service;
  final String Vendortype;

  GetBusinessCardModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.rating,
    required this.img,
    required this.childCat,
    required this.Service,
    required this.Vendortype
  });

  factory GetBusinessCardModel.fromJson(Map<String, dynamic> json) {
    return GetBusinessCardModel(
      id: json['id'] ?? 0,
      productName: json['ProductName'] ?? '',
      price: json['Price'] ?? '',
      rating: json['Rating'] ?? '',
      img: json['Images'] ?? '',
      childCat: json['ChildCategory'] ?? '',
      Service: json['Service'] ?? '',
      Vendortype: json['VendorType']
    );
  }

  // Helper if you want to build full image URL
  String get fullImageUrl {
    return "https://flippraa.anklegaming.live/image/$img";
  }
}

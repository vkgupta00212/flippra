import 'dart:convert';
import 'package:http/http.dart' as http;

class GetChildCategory {
  static Future<List<CategoryModel>> getchildcategorydetails(String categoryType) async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowChildCategory");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'token': "wvnwivnoweifnqinqfinefnq",
        'CategoryType': categoryType,
      },
    );

    print("Status code : ${response.statusCode}");
    print("Raw response :\n ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final category = jsonData.map((item) => CategoryModel.fromJson(item)).toList();
      print("Parsed Category List : ${category.length} items");
      return category;
    } else {
      throw Exception('❌ Failed to load tournaments. Status: ${response.statusCode}');
    }
  }
}

class CategoryModel {
  final int id;
  final String categoryImg;
  final String categoryName;
  final String subcategory;

  CategoryModel({
    required this.id,
    required this.categoryImg,
    required this.categoryName,
    required this.subcategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['ID'],
      categoryImg: json['CategoryImg'].toString().startsWith("http")
          ? json['CategoryImg']
          : "https://flippraa.anklegaming.live/image/${json['CategoryImg']}",
      categoryName: json['CategoryName'],
      subcategory: json['SubCategory'],
    );
  }
}
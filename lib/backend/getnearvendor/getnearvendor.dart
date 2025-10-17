import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class GetNearVendorModel {
  final int id;
  final String vendorName;
  final String vendorEmail;
  final String vendorPhone;
  final String vendorImg;
  final String work;
  final String type;
  final String vendorType;
  final String lat;
  final String log;
  final String distanceInKM;

  GetNearVendorModel({
    required this.id,
    required this.vendorName,
    required this.vendorEmail,
    required this.vendorPhone,
    required this.vendorImg,
    required this.work,
    required this.type,
    required this.vendorType,
    required this.lat,
    required this.log,
    required this.distanceInKM,
  });

  factory GetNearVendorModel.fromJson(Map<String, dynamic> json) {
    return GetNearVendorModel(
      id: json['ID'] ?? 0,
      vendorName: json['VendorName'] ?? '',
      vendorEmail: json['VendorEmail'] ?? '',
      vendorPhone: json['VendorPhone'] ?? '',
      vendorImg: json['VendorImg'] ?? '',
      work: json['Work'] ?? '',
      type: json['Type'] ?? '',
      vendorType: json['VendorType'] ?? '',
      lat: json['Lat'] ?? '',
      log: json['Log'] ?? '',
      distanceInKM: json['DistanceInKM'].toString(),
    );
  }

  String get fullImageUrl {
    return "https://flippraa.anklegaming.live/image/$vendorImg";
  }
}

class GetNearVendor extends GetxController {
  final isLoading = false.obs;
  final vendors = <GetNearVendorModel>[].obs;

  Future<void> fetchNearVendors({
    required String token,
    required String lat,
    required String log,
    required String radius,
    required String work,
    required String type,
    required String vendorType,
  }) async {
    final url =
    Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowNearVendor");

    try {
      isLoading.value = true;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'lat': lat,
          'log': log,
          'Radius': radius,
          'work': work,
          'Type': type,
          'VendorType': vendorType,
        },
      );

      if (response.statusCode == 200) {
        final bodyString = response.body;

        // Extract JSON array from SOAP response
        final match = RegExp(r'\[.*\]').firstMatch(bodyString);
        if (match != null) {
          final jsonString = match.group(0)!;
          final List<dynamic> data = jsonDecode(jsonString);

          vendors.value =
              data.map((e) => GetNearVendorModel.fromJson(e)).toList();
        } else {
          vendors.clear();
        }
      } else {
        vendors.clear();
      }
    } catch (e) {
      vendors.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
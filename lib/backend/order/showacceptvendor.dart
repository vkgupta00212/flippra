// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// /// Model class for each accepted vendor
// class AcceptVendorModel {
//   final int vendorId;
//   final String vendorName;
//   final String vendorEmail;
//   final String vendorPhone;
//   final String vendorImg;
//   final String work;
//   final String type;
//   final String vendorType;
//   final String lat;
//   final String log;
//   final String status;
//   final int requestId;
//
//   AcceptVendorModel({
//     required this.vendorId,
//     required this.vendorName,
//     required this.vendorEmail,
//     required this.vendorPhone,
//     required this.vendorImg,
//     required this.work,
//     required this.type,
//     required this.vendorType,
//     required this.lat,
//     required this.log,
//     required this.status,
//     required this.requestId,
//   });
//
//   factory AcceptVendorModel.fromJson(Map<String, dynamic> json) {
//     return AcceptVendorModel(
//       vendorId: json['VendorID'] ?? 0,
//       vendorName: json['VendorName'] ?? "",
//       vendorEmail: json['VendorEmail'] ?? "",
//       vendorPhone: json['VendorPhone'] ?? "",
//       vendorImg: json['VendorImg'] ?? "",
//       work: json['Work'] ?? "",
//       type: json['Type'] ?? "",
//       vendorType: json['VendorType'] ?? "",
//       lat: json['lat'] ?? "",
//       log: json['log'] ?? "",
//       status: json['Status'] ?? "",
//       requestId: json['RequestID'] ?? 0,
//     );
//   }
// }
//
// /// Controller to fetch accepted vendors (with Stream support)
// class GetAcceptVendorsController extends GetxController {
//   final _vendors = <AcceptVendorModel>[].obs;
//   final isLoading = false.obs;
//   final errMessage = ''.obs;
//   final successMessage = ''.obs;
//
//   Stream<List<AcceptVendorModel>> get vendorStream => _vendors.stream;
//   List<AcceptVendorModel> get vendors => _vendors;
//
//   Future<void> fetchAcceptedVendors() async {
//     final url = Uri.parse(
//         "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowAcceptVendors");
//
//     try {
//       isLoading.value = true;
//       errMessage.value = '';
//       successMessage.value = '';
//       _vendors.clear();
//
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//         body: {
//           'token': "wvnwivnoweifnqinqfinefnq",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//
//         if (decoded is List) {
//           _vendors.assignAll(
//               decoded.map((e) => AcceptVendorModel.fromJson(e)).toList());
//           successMessage.value = "Vendors fetched successfully ✅";
//         } else if (decoded is Map && decoded.containsKey("Message")) {
//           successMessage.value = decoded["Message"];
//         } else {
//           errMessage.value = "Unexpected response format";
//         }
//       } else {
//         errMessage.value = "Server error: ${response.statusCode}";
//       }
//     } catch (e) {
//       errMessage.value = "Error fetching vendors: $e";
//       print("❌ Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// ✅ Optional: Periodically refresh vendors (for continuous updates)
//   void startAutoRefresh({int intervalSeconds = 10}) {
//     Future.delayed(Duration(seconds: intervalSeconds), () async {
//       await fetchAcceptedVendors();
//       if (Get.isRegistered<GetAcceptVendorsController>()) {
//         startAutoRefresh(intervalSeconds: intervalSeconds);
//       }
//     });
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Model class for each accepted vendor
class AcceptVendorModel {
  final int vendorId;
  final String vendorName;
  final String vendorEmail;
  final String vendorPhone;
  final String vendorImg;
  final String work;
  final String type;
  final String vendorType;
  final String lat;
  final String log;
  final String status;
  final int requestId;

  AcceptVendorModel({
    required this.vendorId,
    required this.vendorName,
    required this.vendorEmail,
    required this.vendorPhone,
    required this.vendorImg,
    required this.work,
    required this.type,
    required this.vendorType,
    required this.lat,
    required this.log,
    required this.status,
    required this.requestId,
  });

  factory AcceptVendorModel.fromJson(Map<String, dynamic> json) {
    return AcceptVendorModel(
      vendorId: json['VendorID'] ?? 0,
      vendorName: json['VendorName'] ?? "",
      vendorEmail: json['VendorEmail'] ?? "",
      vendorPhone: json['VendorPhone'] ?? "",
      vendorImg: json['VendorImg'] ?? "",
      work: json['Work'] ?? "",
      type: json['Type'] ?? "",
      vendorType: json['VendorType'] ?? "",
      lat: json['lat'] ?? "",
      log: json['log'] ?? "",
      status: json['Status'] ?? "",
      requestId: json['RequestID'] ?? 0,
    );
  }
}

/// Controller to fetch accepted vendors (with live Stream + auto refresh)
class GetAcceptVendorsController extends GetxController {
  final RxList<AcceptVendorModel> _vendors = <AcceptVendorModel>[].obs;
  final isLoading = false.obs;
  final errMessage = ''.obs;
  final successMessage = ''.obs;

  // ✅ StreamController for continuous updates
  final StreamController<List<AcceptVendorModel>> _vendorStreamController =
  StreamController.broadcast();

  Stream<List<AcceptVendorModel>> get vendorStream =>
      _vendorStreamController.stream;

  Timer? _timer;

  /// Fetch vendors once and push to stream
  Future<void> fetchAcceptedVendors() async {
    final url = Uri.parse(
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowAcceptVendors");
    try {
      isLoading.value = true;
      errMessage.value = '';
      successMessage.value = '';
      _vendors.clear();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': "wvnwivnoweifnqinqfinefnq",
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          final fetched = decoded
              .map<AcceptVendorModel>(
                  (e) => AcceptVendorModel.fromJson(e))
              .toList();

          _vendors.assignAll(fetched);
          _vendorStreamController.add(fetched);
          successMessage.value = "Vendors fetched successfully ✅";
        } else if (decoded is Map && decoded.containsKey("Message")) {
          successMessage.value = decoded["Message"];
        } else {
          errMessage.value = "Unexpected response format";
          _vendorStreamController.addError(errMessage.value);
        }
      } else {
        errMessage.value = "Server error: ${response.statusCode}";
        _vendorStreamController.addError(errMessage.value);
      }
    } catch (e) {
      errMessage.value = "Error fetching vendors: $e";
      _vendorStreamController.addError(e.toString());
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void startAutoRefresh({int intervalSeconds = 2}) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      await fetchAcceptedVendors();
    });
  }

  @override
  void onInit() {
    super.onInit();
    fetchAcceptedVendors(); // initial fetch
    startAutoRefresh(intervalSeconds: 2); // auto refresh
  }

  @override
  void onClose() {
    _timer?.cancel();
    _vendorStreamController.close();
    super.onClose();
  }
}
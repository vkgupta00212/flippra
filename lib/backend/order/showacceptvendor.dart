import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// ✅ Model class for each accepted vendor
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
      lat: json['lat']?.toString() ?? "",
      log: json['log']?.toString() ?? "",
      status: json['Status'] ?? "",
      requestId: json['RequestID'] ?? 0,
    );
  }
}

/// ✅ Controller to fetch accepted vendors (with live stream + auto refresh)
class GetAcceptVendorsController extends GetxController {
  final RxList<AcceptVendorModel> _vendors = <AcceptVendorModel>[].obs;
  final isLoading = false.obs;
  final errMessage = ''.obs;
  final successMessage = ''.obs;

  final StreamController<List<AcceptVendorModel>> _vendorStreamController =
  StreamController.broadcast();

  Stream<List<AcceptVendorModel>> get vendorStream =>
      _vendorStreamController.stream;

  Timer? _timer;
  String? _lastRequestId;

  /// ✅ Fetch vendors for a specific RequestID
  Future<void> fetchAcceptedVendors(String requestId) async {
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
          'Request': requestId,
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

  /// ✅ Start auto-refresh for a given RequestID
  void startAutoRefresh({required String requestId, int intervalSeconds = 3}) {
    _lastRequestId = requestId;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      await fetchAcceptedVendors(requestId);
    });
  }

  /// ✅ Stop auto-refresh manually if needed
  void stopAutoRefresh() {
    _timer?.cancel();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _vendorStreamController.close();
    super.onClose();
  }
}

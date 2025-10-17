import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetAcceptService extends GetxController {
  final isLoading = false.obs;
  final requests = <GetAcceptServiceModel>[].obs;
  final message = ''.obs;
  StreamController<List<GetAcceptServiceModel>>? _streamController;

  @override
  void onInit() {
    super.onInit();
    _streamController = StreamController<List<GetAcceptServiceModel>>.broadcast();
  }

  @override
  void onClose() {
    _streamController?.close();
    super.onClose();
  }

  /// Stream that fetches data every 5 seconds
  Stream<List<GetAcceptServiceModel>> getRequestsStream({
    required String token,
    required String requestID,
    String status = "Accepted",
  }) {
    // Poll API every 5 seconds for real-time updates
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_streamController!.isClosed) {
        timer.cancel();
        return;
      }
      await fetchRequests(token: token, requestID: requestID, status: status);
      _streamController!.add(requests.toList());
    });
    return _streamController!.stream;
  }

  Future<void> fetchRequests({
    required String token,
    required String requestID,
    String status = "Accepted",
  }) async {
    final url = Uri.parse("https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowAcceptance");

    try {
      isLoading.value = true;
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'token': token,
          'RequestID': requestID,
          'Status': status, // ✅ Added Status field
        },
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        print("✅ ShowAcceptance response: ${response.body}");
        final List<dynamic> data = jsonDecode(response.body);
        requests.value =
            data.map((json) => GetAcceptServiceModel.fromJson(json)).toList();
        message.value = "Fetched successfully";
      } else {
        message.value = "Failed with status ${response.statusCode}";
        print("❌ Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      message.value = "Error: $e";
      print("❌ Exception while fetching requests: $e");
    }
  }
}

class GetAcceptServiceModel {
  final int id;
  final int requestId;
  final String vendorName;
  final String vendorImg;
  final String vendorPhone;
  final String rating;
  final String happy;
  final String sad;
  final String kyc;
  final String status;

  GetAcceptServiceModel({
    required this.id,
    required this.requestId,
    required this.vendorName,
    required this.vendorImg,
    required this.vendorPhone,
    required this.rating,
    required this.happy,
    required this.sad,
    required this.kyc,
    required this.status,
  });

  factory GetAcceptServiceModel.fromJson(Map<String, dynamic> json) {
    return GetAcceptServiceModel(
      id: json['ID'] ?? 0,
      requestId: json['RequestId'] ?? 0,
      vendorName: json['VendorName'] ?? '',
      vendorImg: json['VendorImg'] ?? '',
      vendorPhone: json['VendorPhone'] ?? '',
      rating: json['Rating'] ?? '',
      happy: json['Happy'] ?? '',
      sad: json['Sad'] ?? '',
      kyc: json['KYC'] ?? '',
      status: json['Status'] ?? '',
    );
  }
}

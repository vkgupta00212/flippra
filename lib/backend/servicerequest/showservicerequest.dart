import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShowServiceRequestModel {
  final int requestID;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String userImage;
  final String service;
  final String status;
  final int cardID;
  final String productName;
  final String price;
  final String rating;
  final String cardImage;
  final String childCategory;
  final String cardService;
  final String vendorType;

  ShowServiceRequestModel({
    required this.requestID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.userImage,
    required this.service,
    required this.status,
    required this.cardID,
    required this.productName,
    required this.price,
    required this.rating,
    required this.cardImage,
    required this.childCategory,
    required this.cardService,
    required this.vendorType,
  });

  factory ShowServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ShowServiceRequestModel(
      requestID: json['RequestID'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['Email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      userImage: json['UserImage'] ?? '',
      service: json['Service'] ?? '',
      status: json['Status'] ?? '',
      cardID: json['CardID'] ?? 0,
      productName: json['ProductName'] ?? '',
      price: json['Price'] ?? '',
      rating: json['Rating'] ?? '',
      cardImage: json['CardImage'] ?? '',
      childCategory: json['ChildCategory'] ?? '',
      cardService: json['CardService'] ?? '',
      vendorType: json['VendorType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestID': requestID,
      'firstName': firstName,
      'lastName': lastName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'UserImage': userImage,
      'Service': service,
      'Status': status,
      'CardID': cardID,
      'ProductName': productName,
      'Price': price,
      'Rating': rating,
      'CardImage': cardImage,
      'ChildCategory': childCategory,
      'CardService': cardService,
      'VendorType': vendorType,
    };
  }
}

class ShowServiceRequest extends GetxController{
  final RxList<ShowServiceRequestModel> _vendors = <ShowServiceRequestModel>[].obs;
  final isLoading = false.obs;
  final errMessage = ''.obs;
  final successMessage = ''.obs;
  final StreamController<List<ShowServiceRequestModel>> _vendorStreamController =
  StreamController.broadcast();

  Stream<List<ShowServiceRequestModel>> get requestuserstream =>
      _vendorStreamController.stream;

  Timer? _timer;

  Future<void> requestuser() async {
    final url = Uri.parse(
        "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowRequest");
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
              .map<ShowServiceRequestModel>(
                  (e) => ShowServiceRequestModel.fromJson(e))
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
      await requestuser();
    });
  }

  @override
  void onInit() {
    super.onInit();
    requestuser(); // initial fetch
    startAutoRefresh(intervalSeconds: 2); // auto refresh
  }

  @override
  void onClose() {
    _timer?.cancel();
    _vendorStreamController.close();
    super.onClose();
  }
}

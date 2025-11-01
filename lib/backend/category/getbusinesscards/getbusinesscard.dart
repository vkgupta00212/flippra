import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetBusinessCardController extends GetxController {
  // ──────────────────────────────────────────────────────
  // 1. Public reactive list – widgets bind to this
  // ──────────────────────────────────────────────────────
  final cards = <GetBusinessCardModel>[].obs;
  final message = ''.obs;

  // ──────────────────────────────────────────────────────
  // 2. NEW: flag that tells us if we already received the first batch
  // ──────────────────────────────────────────────────────
  final hasInitialData = false.obs;

  // ──────────────────────────────────────────────────────
  // 3. Private fetch flag – prevents parallel calls
  // ──────────────────────────────────────────────────────
  bool _isFetching = false;

  StreamController<List<GetBusinessCardModel>>? _streamController;

  @override
  void onInit() {
    super.onInit();
    _streamController = StreamController<List<GetBusinessCardModel>>.broadcast();
  }

  @override
  void onClose() {
    _streamController?.close();
    super.onClose();
  }

  /// ----------------------------------------------------
  /// Stream that auto-refreshes every 5 seconds
  /// ----------------------------------------------------
  Stream<List<GetBusinessCardModel>> getBusinessCardStream({
    required String subcategoryId,
    required String vendorType,
  }) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_streamController!.isClosed) {
        timer.cancel();
        return;
      }

      await _fetchBusinessCards(
        subcategoryId: subcategoryId,
        vendorType: vendorType,
      );

      // Push the current list to the stream
      _streamController!.add(cards.toList());

      // Mark the first successful fetch
      if (!hasInitialData.value && cards.isNotEmpty) {
        hasInitialData.value = true;
      }
    });

    return _streamController!.stream;
  }

  /// ----------------------------------------------------
  /// Private fetch – no public loading observable
  /// ----------------------------------------------------
  Future<void> _fetchBusinessCards({
    required String subcategoryId,
    required String vendorType,
  }) async {
    if (_isFetching) return;          // avoid duplicate calls
    _isFetching = true;

    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowBussinessCards",
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': "wvnwivnoweifnqinqfinefnq",
          'SubCategory': subcategoryId,
          'VendorType': vendorType,
        },
      );

      print("Status code : ${response.statusCode}");
      print("Raw response : ${response.body}");

      if (response.statusCode == 200) {
        dynamic decoded = jsonDecode(response.body);
        if (decoded is String) decoded = jsonDecode(decoded);

        final List<dynamic> jsonData = decoded;
        cards.value = jsonData
            .map((item) => GetBusinessCardModel.fromJson(item))
            .toList();

        message.value = "Fetched successfully";
        print("Parsed ${cards.length} business cards");
      } else {
        message.value = "Failed with status ${response.statusCode}";
        print("Failed to fetch cards: ${response.statusCode}");
      }
    } catch (e) {
      message.value = "Error: $e";
      print("Exception while fetching business cards: $e");
    } finally {
      _isFetching = false;
    }
  }
}

/// ──────────────────────────────────────────────────────
/// Model – unchanged (fullImageUrl getter already there)
/// ──────────────────────────────────────────────────────
class GetBusinessCardModel {
  final int id;
  final String productName;
  final String price;
  final String rating;
  final String img;
  final String childCat;
  final String service;
  final String vendorType;
  final String request;

  GetBusinessCardModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.rating,
    required this.img,
    required this.childCat,
    required this.service,
    required this.vendorType,
    required this.request,
  });

  factory GetBusinessCardModel.fromJson(Map<String, dynamic> json) {
    return GetBusinessCardModel(
      id: json['id'] ?? 0,
      productName: json['ProductName'] ?? '',
      price: json['Price'] ?? '',
      rating: json['Rating'] ?? '',
      img: json['Images'] ?? '',
      childCat: json['ChildCategory'] ?? '',
      service: json['Service'] ?? '',
      vendorType: json['VendorType'] ?? '',
      request: json['Request'] ?? '',
    );
  }

  String get fullImageUrl =>
      "https://flippraa.anklegaming.live/image/$img";
}
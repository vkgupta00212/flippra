import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetBusinessCardController extends GetxController {
  final cards = <GetBusinessCardModel>[].obs;
  final message = ''.obs;
  final hasInitialData = false.obs;

  bool _isFetching = false;
  Timer? _autoRefreshTimer;
  late final StreamController<List<GetBusinessCardModel>> _streamController;

  @override
  void onInit() {
    super.onInit();
    _streamController = StreamController<List<GetBusinessCardModel>>.broadcast();
  }

  @override
  void onClose() {
    _autoRefreshTimer?.cancel();
    _streamController.close();
    super.onClose();
  }

  /// 🔁 Get the stream (starts fetching automatically)
  Stream<List<GetBusinessCardModel>> getBusinessCardStream({
    required String subcategoryId,
    required String vendorType,
  }) {
    _startAutoRefresh(subcategoryId: subcategoryId, vendorType: vendorType);
    return _streamController.stream;
  }

  /// 🔄 Start automatic refresh every few seconds
  void _startAutoRefresh({
    required String subcategoryId,
    required String vendorType,
    int intervalSeconds = 5, // change to whatever interval you want
  }) {
    _autoRefreshTimer?.cancel(); // cancel previous timer if running
    _fetchBusinessCards(subcategoryId: subcategoryId, vendorType: vendorType);

    _autoRefreshTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
          (_) => _fetchBusinessCards(
        subcategoryId: subcategoryId,
        vendorType: vendorType,
      ),
    );
  }

  /// 📡 Fetch business cards from API
  Future<void> _fetchBusinessCards({
    required String subcategoryId,
    required String vendorType,
  }) async {
    if (_isFetching) return;
    _isFetching = true;

    final url = Uri.parse(
      "https://flippraa.anklegaming.live/APIs/APIs.asmx/ShowBussinessCards",
    );

    print("📡 [GetBusinessCard] Fetching: SubCategory=$subcategoryId, VendorType=$vendorType");

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

      if (response.statusCode == 200) {
        dynamic decoded = jsonDecode(response.body);
        if (decoded is String) decoded = jsonDecode(decoded);

        if (decoded is List) {
          final fetchedCards = decoded
              .map((item) => GetBusinessCardModel.fromJson(item))
              .toList();

          cards.value = fetchedCards;
          message.value = "Success";

          if (!_streamController.isClosed) {
            _streamController.add(fetchedCards);
          }

          hasInitialData.value = true;
          print("✅ Loaded ${fetchedCards.length} cards");
        } else {
          _handleError("Unexpected JSON format: $decoded");
        }
      } else {
        _handleError("Failed: ${response.statusCode}");
      }
    } catch (e) {
      _handleError("Error: $e");
    } finally {
      _isFetching = false;
    }
  }

  void _handleError(String msg) {
    message.value = msg;
    cards.clear();
    if (!_streamController.isClosed) _streamController.add([]);
    print("⚠️ $msg");
  }

  /// 🔄 Manual refresh
  Future<void> refreshCards({
    required String subcategoryId,
    required String vendorType,
  }) async {
    await _fetchBusinessCards(subcategoryId: subcategoryId, vendorType: vendorType);
  }
}

/// 🧾 Model
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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      productName: json['ProductName'] ?? '',
      price: json['Price']?.toString() ?? '',
      rating: json['Rating']?.toString() ?? '',
      img: json['Images'] ?? '',
      childCat: json['ChildCategory']?.toString() ?? '',
      service: json['Service'] ?? '',
      vendorType: json['VendorType'] ?? '',
      request: json['Request'] ?? '',
    );
  }

  String get fullImageUrl => "https://flippraa.anklegaming.live/image/$img";
}

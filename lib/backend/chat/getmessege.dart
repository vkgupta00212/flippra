import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatMessageModel {
  final int id;
  final String chatMessage;
  final String messageTime;
  final String messageDate;
  final String senderName;
  final String senderEmail;
  final String receiverName;
  final String receiverEmail;
  final String onlineOfflineStatus;
  final String messageReadStatus;

  ChatMessageModel({
    required this.id,
    required this.chatMessage,
    required this.messageTime,
    required this.messageDate,
    required this.senderName,
    required this.senderEmail,
    required this.receiverName,
    required this.receiverEmail,
    required this.onlineOfflineStatus,
    required this.messageReadStatus,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? 0,
      chatMessage: json['ChatMessage'] ?? "",
      messageTime: json['MessageTime'] ?? "",
      messageDate: json['MessageDate'] ?? "",
      senderName: json['Sendername'] ?? "",
      senderEmail: json['SenderEmail'] ?? "",
      receiverName: json['Recievername'] ?? "",
      receiverEmail: json['Recieveremail'] ?? "",
      onlineOfflineStatus: json['Onlineofflinestatus'] ?? "",
      messageReadStatus: json['Messageresdedstatus'] ?? "",
    );
  }
}

class GetChatMessageController extends GetxController {
  final RxList<ChatMessageModel> _messages = <ChatMessageModel>[].obs;
  final isLoading = false.obs;
  final errMessage = ''.obs;
  final successMessage = ''.obs;

  final StreamController<List<ChatMessageModel>> _messageStreamController =
      StreamController.broadcast();

  Stream<List<ChatMessageModel>> get messageStream =>
      _messageStreamController.stream;

  Timer? _timer;

  /// ✅ Dynamic fetch: pass sender & receiver email
  Future<void> fetchChatMessages({
    required String receiverEmail,
    required String senderEmail,
  }) async {
    final url = Uri.parse(
        "https://flippraa.anklegaming.live/APIs/Chat.asmx/GETChatmessages");
    try {
      isLoading.value = true;
      errMessage.value = '';
      successMessage.value = '';

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': "wvnwivnoweifnqinqfinefnq",
          'recievermail': receiverEmail,
          'sendermail': senderEmail,
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          final fetched = decoded
              .map<ChatMessageModel>((e) => ChatMessageModel.fromJson(e))
              .toList();

          _messages.assignAll(fetched);
          _messageStreamController.add(fetched);
          successMessage.value = "Messages fetched successfully ✅";
        } else {
          errMessage.value = "Unexpected response format";
          _messageStreamController.addError(errMessage.value);
        }
      } else {
        errMessage.value = "Server error: ${response.statusCode}";
        _messageStreamController.addError(errMessage.value);
      }
    } catch (e) {
      errMessage.value = "Error fetching messages: $e";
      _messageStreamController.addError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Dynamic auto refresh
  void startAutoRefresh({
    required String senderEmail,
    required String receiverEmail,
    int intervalSeconds = 1,
  }) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) async {
      await fetchChatMessages(
          senderEmail: senderEmail, receiverEmail: receiverEmail);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _messageStreamController.close();
    super.onClose();
  }
}

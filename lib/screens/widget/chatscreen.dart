import 'package:flippra/backend/getuser/getuser.dart';
import 'package:flippra/backend/order/showacceptvendor.dart';
import 'package:flippra/screens/widget/ratingscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../backend/chat/getmessege.dart';
import '../../backend/chat/sendmessege.dart';
import '../../utils/shared_prefs_helper.dart';

class ChatScreen extends StatefulWidget {
  final AcceptVendorModel vendor;

  const ChatScreen({Key? key, required this.vendor}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final getmessege = Get.put(GetChatMessageController());
  final phone = SharedPrefsHelper.getPhoneNumber();
  final getusercontroller = Get.put(GetUser());
  late final GetUserModel user;
  bool _isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();

    if (phone == null) {
      debugPrint('⚠️ No phone number found in SharedPreferences');
      return;
    }

    await getusercontroller.getuserdetails(
      token: 'wvnwivnoweifnqinqfinefnq',
      phone: phone,
    );

    if (getusercontroller.users.isNotEmpty) {
      user = getusercontroller.users.first; // ✅ Assign only once
      _isUserLoaded = true;

      debugPrint("✅ User loaded: ${user.email}");
      debugPrint("Vendor Email: ${widget.vendor.vendorEmail}");

      // ✅ Fetch and auto-refresh chat
      getmessege.fetchChatMessages(
        receiverEmail: widget.vendor.vendorEmail,
        senderEmail: user.email,
      );
      getmessege.startAutoRefresh(
        senderEmail: user.email,
        receiverEmail: widget.vendor.vendorEmail,
      );

      if (mounted) setState(() {});
    } else {
      debugPrint("⚠️ No user data found after API call");
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showActionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _ActionBottomSheet(),
    );
  }

  void _showOrderDetailsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const OrderDetailsBottomSheet2(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(widget.vendor.vendorImg),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vendor.vendorName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Online",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ChatMessageModel>>(
              stream: getmessege.messageStream,
              builder: (context, snapshot) {
                if (getmessege.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet."));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ChatBubble(
                      text: msg.chatMessage,
                      isMe: msg.senderEmail == user!.email,
                      timestamp: msg.messageTime,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomNavBar(
                  selectedIndex: 0,
                  onItemTapped: (index) {
                    if (index == 5) {
                      _showOrderDetailsBottomSheet();
                    }
                  },
                ),
                ChatInputBar(
                  user: user,
                  vendor: widget.vendor,
                  controller: _textController,
                  onCamera: () => print("Camera pressed"),
                  onExtra: _showActionBottomSheet,
                  onCall: () => print("Call pressed"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class _ActionBottomSheet extends StatelessWidget {
  const _ActionBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(context, Icons.camera_alt, "Camera", () {}),
              _actionButton(context, Icons.location_on, "Location", () {}),
              _actionButton(context, Icons.qr_code, "QR Code", () {}),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(context, Icons.payment, "Payment", () {}),
              _actionButton(context, Icons.shopping_cart, "Cart", () {}),
              _actionButton(context, Icons.local_shipping, "Order", () {
                Navigator.pop(context);
                (context as Element)
                    .findAncestorStateOfType<_ChatScreenState>()
                    ?._showOrderDetailsBottomSheet();
              }),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                // ✅ makes it draggable full screen
                backgroundColor: Colors.transparent,
                // ✅ keeps rounded corners visible
                builder: (context) => const OrderDetailsBottomSheet2(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B3A7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              minimumSize: const Size(double.infinity, 48),
            ),
            icon:
                const Icon(Icons.local_shipping_outlined, color: Colors.white),
            label: const Text(
              'Order | Tracking',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _actionButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF00B3A7).withOpacity(0.1),
          child: IconButton(
            icon: Icon(icon, color: const Color(0xFF00B3A7)),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
              ),
        ),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text; // message text
  final bool isMe; // sent by current user or not
  final String timestamp; // message timestamp

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe ? const Color(0xFF00B3A7) : Colors.white;
    final textColor = isMe ? Colors.white : const Color(0xFF00B3A7);
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timestamp.split(':').take(2).join(':'), // → "13:19"
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleIcon(context, Icons.edit_document, 0),
          _buildCircleIcon(context, Icons.qr_code, 1),
          _buildCircleIcon(context, Icons.calculate_outlined, 2),
          _buildCircleIcon(context, Icons.grid_view_rounded, 3),
          GestureDetector(
            onTap: () => {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                // ✅ makes it draggable full screen
                backgroundColor: Colors.transparent,
                // ✅ keeps rounded corners visible
                builder: (context) => const OrderDetailsBottomSheet2(),
              )
            }, // Changed to 4 to align with index count
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00B3A7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.local_shipping_outlined,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "Order | Tracking",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(BuildContext context, IconData icon, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF00B3A7), width: 1.5),
          color: Colors.white,
        ),
        child: Icon(
          icon,
          size: 22,
          color:
              index == selectedIndex ? const Color(0xFF00B3A7) : Colors.black87,
        ),
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  final GetUserModel user;
  final AcceptVendorModel vendor;
  final TextEditingController controller;
  final VoidCallback onCamera;
  final VoidCallback onExtra;
  final VoidCallback onCall;

  ChatInputBar({
    Key? key,
    required this.user,
    required this.vendor,
    required this.controller,
    required this.onCamera,
    required this.onExtra,
    required this.onCall,
  }) : super(key: key);

  final SendMessegeController sendMessegeController =
      Get.put(SendMessegeController());

  Future<void> _sendMessage(BuildContext context) async {
    if (controller.text.trim().isEmpty) return;

    final messageText = controller.text.trim();
    controller.clear();

    final success = await sendMessegeController.sendMessege(
      token: "wvnwivnoweifnqinqfinefnq",
      messege: messageText,
      sendername: user.firstName,
      sendermail: user.email,
      recievername: vendor.vendorName,
      recieveremail: vendor.vendorEmail,
      Onlinestatus: "offline",
      readunreadstatus: "Read",
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Message sent successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(sendMessegeController.errMessage.value)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.camera_alt, color: Color(0xFF00B3A7)),
                    onPressed: onCamera,
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(context),
                    ),
                  ),
                  Obx(() {
                    return sendMessegeController.isLoading.value
                        ? const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send,
                                color: Color(0xFF00B3A7)),
                            onPressed: () => _sendMessage(context),
                          );
                  }),
                  IconButton(
                    icon: const Icon(Icons.filter_list_rounded,
                        color: Colors.black87),
                    onPressed: onExtra,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[400],
            child: IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: onCall,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsBottomSheet2 extends StatelessWidget {
  const OrderDetailsBottomSheet2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Order Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #12345',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                        ),
                        Text(
                          'Aug 29, 2025, 06:19 PM',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ₹1295',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00B3A7),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        _buildStatusStep(
                          title: "Request | Send",
                          subtitle:
                              "The seller or platform received the order.",
                          date: "10-August-2025, 5:30 PM",
                          isCompleted: true,
                          isCurrent: false,
                          isLast: false,
                          context: context,
                        ),
                        _buildStatusStep(
                          title: "Accept | Order",
                          subtitle: "The seller begins processing the order.",
                          date: "10-August-2025, 5:30 PM",
                          isCompleted: true,
                          isCurrent: false,
                          isLast: false,
                          context: context,
                        ),
                        _buildStatusStep(
                          title: "Delivery",
                          subtitle: "Items handed to courier.",
                          date: "10-August-2025, 5:30 PM",
                          isCompleted: false,
                          isCurrent: true,
                          isLast: false,
                          context: context,
                        ),
                        _buildStatusStep(
                          title: "Reviews Writing",
                          subtitle: "Arrives at destination address.",
                          date: "10-August-2025, 5:30 PM",
                          isCompleted: false,
                          isCurrent: false,
                          isLast: true,
                          context: context,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomActionNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStep({
    required String title,
    required String subtitle,
    required String date,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline + Circle
        Column(
          children: [
            // Circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFF00B3A7)
                    : isCurrent
                        ? Colors.orange
                        : Colors.grey[400],
                border: Border.all(
                  color: isCurrent ? Colors.orange : Colors.transparent,
                  width: isCurrent ? 2 : 0,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            // Line
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color:
                    isCompleted || isCurrent ? Colors.orange : Colors.grey[400],
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isCompleted || isCurrent
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isCompleted
                          ? const Color(0xFF00B3A7)
                          : isCurrent
                              ? Colors.orange
                              : Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomActionNavBar extends StatelessWidget {
  const CustomActionNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Color(0xFF00B3A7), width: 1),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(),
                      child: Icon(
                        Icons.chat,
                        color: Color(0xFF00B3A7),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 117,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xFF00B3A7),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Update | Status",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _circleButton(
            icon: Icons.rate_review_outlined,
            color: Color(0xFF00B3A7),
            onTap: () => {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                // ✅ makes it draggable full screen
                backgroundColor: Colors.transparent,
                // ✅ keeps rounded corners visible
                builder: (context) => const RatingScreen(),
              )
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class StatusActionBar extends StatelessWidget {
  final VoidCallback onRate;
  final VoidCallback onChat;
  final VoidCallback onStatus;

  const StatusActionBar({
    Key? key,
    required this.onRate,
    required this.onChat,
    required this.onStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAction(Icons.star, "Rate", onRate),
        const SizedBox(width: 20),
        _buildAction(Icons.chat, "Chat", onChat),
        const SizedBox(width: 20),
        _buildAction(Icons.info, "Status", onStatus),
      ],
    );
  }

  Widget _buildAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF00B3A7).withOpacity(0.1),
            child: Icon(icon, color: const Color(0xFF00B3A7), size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class CommonMessage {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _CommonMessageSheet(),
    );
  }
}

class _CommonMessageSheet extends StatefulWidget {
  const _CommonMessageSheet({super.key});

  @override
  State<_CommonMessageSheet> createState() => _CommonMessageSheetState();
}

class _CommonMessageSheetState extends State<_CommonMessageSheet> {
  int selectedReason = 0;

  final List<Map<String, dynamic>> reasons = [
    {
      "subtitle": "Add a little bit of body text",
    },
    {
      "subtitle": "Add a little bit of body text",
    },
    {
      "subtitle": "Add a little bit of body text",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Text(
                    "Cancel Reason",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reasons.length,
                itemBuilder: (context, index) {
                  final item = reasons[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedReason == index
                            ? Colors.orange
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: selectedReason,
                      onChanged: (val) {
                        setState(() => selectedReason = val!);
                      },
                      activeColor: Colors.orange,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["subtitle"],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

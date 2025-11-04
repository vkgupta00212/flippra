import 'package:flippra/backend/getuser/getuser.dart';
import 'package:flippra/backend/register/register.dart';
import 'package:flippra/screens/homescreens/home/homemain.dart';
import 'package:flutter/material.dart';
import 'package:flippra/screens/gender_confirm_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'homescreens/home/home_screen_category.dart';

class EnterOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const EnterOtpScreen({super.key, required this.phoneNumber});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  late VideoPlayerController _videoController;

  final TextEditingController _otpDigit1Controller = TextEditingController();
  final TextEditingController _otpDigit2Controller = TextEditingController();
  final TextEditingController _otpDigit3Controller = TextEditingController();
  final TextEditingController _otpDigit4Controller = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  bool get _isOtpValid {
    final otp = _otpDigit1Controller.text +
        _otpDigit2Controller.text +
        _otpDigit3Controller.text +
        _otpDigit4Controller.text;

    return otp.length == 4 && otp == '1234';
  }

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/otp.mp4')
      ..initialize().then((_) {
        _videoController.play();
        _videoController.setLooping(true);
        setState(() {});
      }).catchError((error) {
        print("Error initializing video on EnterOtpScreen: $error");
      });

    _otpDigit1Controller.addListener(_onOtpChanged);
    _otpDigit2Controller.addListener(_onOtpChanged);
    _otpDigit3Controller.addListener(_onOtpChanged);
    _otpDigit4Controller.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    setState(() {}); // refresh button state
  }

  @override
  void dispose() {
    _otpDigit1Controller.dispose();
    _otpDigit2Controller.dispose();
    _otpDigit3Controller.dispose();
    _otpDigit4Controller.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _videoController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    final Register registerController = Get.put(Register());
    final GetUser getUserController = Get.put(GetUser());
    const token = "wvnwivnoweifnqinqfinefnq";

    final enteredOtp = _otpDigit1Controller.text +
        _otpDigit2Controller.text +
        _otpDigit3Controller.text +
        _otpDigit4Controller.text;

    if (enteredOtp == '1234') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone_number', widget.phoneNumber);
      await prefs.setBool('isLoggedIn', true);

      try {
        // Step 1: Register the user
        await registerController.registeruser(
          token: token,
          firstname: "",
          lastname: "",
          Gender: "",
          Email: "",
          City: "",
          phone: widget.phoneNumber,
        );
        print("✅ Successfully registered");
      } catch (e) {
        print("❌ Registration error: $e");
      }

      // Step 2: Fetch user details (fills `users` in controller)
      await getUserController.getuserdetails(
        token: token,
        phone: widget.phoneNumber,
      );

      if (!mounted) return;

      // Step 3: Navigate based on user data
      if (getUserController.users.isNotEmpty) {
        final user = getUserController.users.first;
        print("✅ user data from enter otp: ${user.firstName}, ${user.gender}");

        final bool hasCompleteInfo =
            user.gender.isNotEmpty && user.firstName.isNotEmpty;

        if (hasCompleteInfo) {
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=> HomeMain())
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> const GenderConfirmScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GenderConfirmScreen()),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Invalid OTP')),
      );
    }
  }

  Widget _otpDigitField(TextEditingController controller,
      FocusNode currentFocusNode, FocusNode? nextFocusNode) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          } else if (value.isEmpty && currentFocusNode != _focusNode1) {
            currentFocusNode.previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final _isKeyboardVisible = viewInsets > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ✅ Background video
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.8,
            child: Container(
              color: Colors.white,
              child: _videoController.value.isInitialized
                  ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              )
                  : const SizedBox(),
            ),
          ),

          // ✅ OTP input container
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: _isKeyboardVisible
                ? screenHeight * 0.31
                : screenHeight * 0.55,
            left: 0,
            right: 0,
            bottom: _isKeyboardVisible ? 0 : -20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter OTP',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _otpDigitField(
                            _otpDigit1Controller, _focusNode1, _focusNode2),
                        _otpDigitField(
                            _otpDigit2Controller, _focusNode2, _focusNode3),
                        _otpDigitField(
                            _otpDigit3Controller, _focusNode3, _focusNode4),
                        _otpDigitField(
                            _otpDigit4Controller, _focusNode4, null),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          print('Resending OTP to: ${widget.phoneNumber}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Resending OTP...')),
                          );
                        },
                        child: Text(
                          'Resend OTP',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isOtpValid ? _verifyOtp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          disabledBackgroundColor: Colors.orange.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          'Verify',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

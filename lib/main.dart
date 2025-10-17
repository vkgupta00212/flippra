import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 import this
import 'package:flippra/screens/homescreens/home/home_screen_category.dart';
import 'package:flippra/screens/homescreens/home/homemain.dart';
import 'package:flippra/screens/requestscreen.dart';
import 'package:flippra/screens/widget/chatscreen.dart';

// Screens
import 'package:flippra/screens/splashscreen.dart';
import 'package:flippra/screens/get_otp_screen.dart';
import 'package:flippra/screens/gender_confirm_screen.dart';
import 'package:flippra/screens/sign_up_screen.dart';
import 'package:flippra/screens/home_screen.dart';
import 'package:flippra/screens/shop_screen.dart';
import 'package:flippra/screens/shop2_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Configure system status bar before app runs
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,       // transparent so background shows
      statusBarIconBrightness: Brightness.dark, // dark icons for light backgrounds
      statusBarBrightness: Brightness.light,    // for iOS
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flippra E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const SplashScreen(),
      routes: {
        '/get_otp': (context) => const GetOtpScreen(),
        '/gender_confirm': (context) => const GenderConfirmScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/shop2_screen': (context) => const Shop2Screen(),
        '/homecategory': (context) => const HomeScreenCategoryScreen(),
        '/homemain': (context) => const HomeMain(),
        '/order': (context) => const OrderDetailsBottomSheet2(),
      },
    );
  }
}

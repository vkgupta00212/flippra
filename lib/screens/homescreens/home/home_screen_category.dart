// import 'package:flippra/screens/homescreens/vendors/vendorpannelscreen.dart';
// import 'package:flippra/screens/widget/bottomnavbar.dart';
// import 'package:flippra/screens/widget/singlerequest.dart';
// import 'package:flutter/material.dart';
// import 'package:flippra/screens/shop_screen.dart';
// import 'package:marquee/marquee.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../backend/home/getcategory/getchildcategory.dart';
// import '../../../backend/home/getcategory/showproductcategory.dart';
// import '../../../backend/home/getlocation/getlocation.dart';
// import '../../../backend/home/getlocation/locationmodel.dart';
// import '../../../backend/home/getslider/getslider.dart';
// import '../../../backend/home/getslider/slidermodel.dart';
// import '../../../utils/shared_prefs_helper.dart';
// import '../../businessprofile.dart';
// import '../../get_otp_screen.dart';
// import 'package:flutter_speech/flutter_speech.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../widget/home/header.dart';
//
// // Define GetChildCategory (from your previous code)
//
// class HomeScreenCategoryScreen extends StatefulWidget {
//   const HomeScreenCategoryScreen({super.key});
//
//   @override
//   State<HomeScreenCategoryScreen> createState() =>
//       _HomeScreenCategoryScreenState();
// }
//
// class _HomeScreenCategoryScreenState extends State<HomeScreenCategoryScreen>
//     with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   String _selectedLanguage = 'English';
//   bool _isToggleRight = true;
//   bool _isSettingsActive = true;
//   bool _isSearching = false;
//   late List<CategoryModel> _childcategory = [];
//   late List<ProductCategoryModel> _categoryList = [];
//   late Future<List<ProductCategoryModel>> _category;
//   late Future<List<SliderModel>> _slider;
//   LocationModel? location;
//   final GlobalKey _languageIconKey = GlobalKey();
//   final GlobalKey _settingsIconKey = GlobalKey();
//   final TextEditingController _searchController = TextEditingController();
//   late SpeechRecognition _speech;
//   bool _isListening = false;
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//
//   void _initSpeechRecognizer() {
//     _speech = SpeechRecognition();
//
//     _speech.setAvailabilityHandler((bool result) {
//       if (!result) {
//         print("Speech recognition not available.");
//       }
//     });
//
//     _speech.setRecognitionStartedHandler(() {
//       setState(() {
//         _isListening = true;
//       });
//       _animationController.repeat(reverse: true);
//       print('✅ Listening started. _isListening is now: $_isListening');
//     });
//
//     _speech.setRecognitionResultHandler((String recognizedText) {
//       _searchController.text = recognizedText;
//     });
//
//     _speech.setRecognitionCompleteHandler((String recognizedText) {
//       setState(() {
//         _isListening = false;
//       });
//       _animationController.stop();
//       print('❌ Listening complete. _isListening is now: $_isListening');
//     });
//
//     _speech.setErrorHandler(() {
//       setState(() {
//         _isListening = false;
//       });
//       _animationController.stop();
//       print(
//           '⚠️ Speech recognition error occurred. _isListening is now: $_isListening');
//     });
//   }
//
//   Future<bool> _requestPermission() async {
//     var status = await Permission.microphone.status;
//     if (status.isGranted) {
//       return true;
//     } else {
//       var result = await Permission.microphone.request();
//       return result.isGranted;
//     }
//   }
//
//   void _startListening() async {
//     bool hasPermission = await _requestPermission();
//     if (hasPermission) {
//       _speech.activate('en_US').then((_) {
//         _speech.listen();
//       });
//     } else {
//       print("Microphone permission denied.");
//     }
//   }
//
//   void _stopListening() {
//     _speech.stop();
//   }
//
//   void _onItemTapped(String categoryId) async {
//     try {
//       final childCategories =
//           await GetChildCategory.getchildcategorydetails(categoryId);
//       setState(() {
//         _childcategory = childCategories;
//         _selectedIndex =
//             _categoryList.indexWhere((item) => item.id == categoryId) + 1;
//       });
//     } catch (e) {
//       print('Error fetching child categories: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load child categories: $e')),
//       );
//     }
//   }
//
//   void _showLanguageSelection(BuildContext context) {
//     final RenderBox? renderBox =
//         _languageIconKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) {
//       print('ERROR: Language icon RenderBox not found.');
//       return;
//     }
//
//     final Offset offset = renderBox.localToGlobal(Offset.zero);
//     final Size size = renderBox.size;
//
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//
//     const double dialogContentWidth = 150.0;
//     const double dialogContentHeight = 56.0;
//
//     double dialogLeft = offset.dx + size.width - dialogContentWidth;
//     const double horizontalPadding = 8.0;
//
//     if (dialogLeft < horizontalPadding) {
//       dialogLeft = horizontalPadding;
//     }
//     if (dialogLeft + dialogContentWidth > screenWidth - horizontalPadding) {
//       dialogLeft = screenWidth - dialogContentWidth - horizontalPadding;
//     }
//
//     double dialogTop = offset.dy + size.height + 8.0;
//     const double bottomNavHeight = 100.0;
//     if (dialogTop + dialogContentHeight > screenHeight - bottomNavHeight) {
//       dialogTop = offset.dy - dialogContentHeight - 8.0;
//       if (dialogTop < MediaQuery.of(context).padding.top + 8.0) {
//         dialogTop = MediaQuery.of(context).padding.top + 8.0;
//       }
//     }
//
//     String optionLanguage;
//     Widget optionDisplayWidget;
//
//     if (_selectedLanguage == 'English') {
//       optionLanguage = 'Hindi';
//       optionDisplayWidget = const Text(
//         'अ',
//         style: TextStyle(
//             color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//       );
//     } else {
//       optionLanguage = 'English';
//       optionDisplayWidget = Image.asset(
//         'assets/icons/english.png',
//         width: 24,
//         height: 24,
//         errorBuilder: (context, error, stackTrace) {
//           print('ERROR: Dialog Image.asset failed to load english.png: $error');
//           return const Icon(Icons.error, color: Colors.red, size: 24);
//         },
//       );
//     }
//
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
//       barrierColor: Colors.black.withOpacity(0.1),
//       transitionDuration: const Duration(milliseconds: 200),
//       pageBuilder: (BuildContext buildContext, Animation<double> animation,
//           Animation<double> secondaryAnimation) {
//         return Align(
//           alignment: Alignment.topLeft,
//           child: Transform.translate(
//             offset: Offset(dialogLeft, dialogTop),
//             child: Material(
//               color: Colors.white,
//               elevation: 4.0,
//               borderRadius: BorderRadius.circular(8.0),
//               child: SizedBox(
//                 width: dialogContentWidth,
//                 height: dialogContentHeight,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     ListTile(
//                       leading: optionDisplayWidget,
//                       title: Text(optionLanguage),
//                       onTap: () {
//                         setState(() {
//                           _selectedLanguage = optionLanguage;
//                         });
//                         Navigator.pop(context);
//                         print('Language set to $_selectedLanguage');
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return FadeTransition(
//           opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
//           child: ScaleTransition(
//             scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
//             alignment: Alignment.topRight,
//             child: child,
//           ),
//         );
//       },
//     );
//   }
//
//   void _showSettingsDialog(BuildContext context) {
//     final RenderBox? renderBox =
//         _settingsIconKey.currentContext?.findRenderObject() as RenderBox?;
//     if (renderBox == null) {
//       print('ERROR: Product icon RenderBox not found.');
//       return;
//     }
//
//     final Offset offset = renderBox.localToGlobal(Offset.zero);
//     final Size size = renderBox.size;
//
//     final double screenWidth = MediaQuery.of(context).size.width;
//     const double dialogContentWidth = 60.0;
//     const double dialogContentHeight = 60.0;
//     const double padding = 8.0;
//
//     double dialogTop = offset.dy - dialogContentHeight;
//     if (dialogTop < MediaQuery.of(context).padding.top + padding) {
//       dialogTop = MediaQuery.of(context).padding.top + padding;
//     }
//
//     double dialogLeft = offset.dx + (size.width / 2) - (dialogContentWidth / 2);
//     if (dialogLeft < padding) {
//       dialogLeft = padding;
//     } else if (dialogLeft + dialogContentWidth > screenWidth - padding) {
//       dialogLeft = screenWidth - dialogContentWidth - padding;
//     }
//
//     Navigator.of(context).push(
//       PageRouteBuilder(
//         opaque: false,
//         barrierDismissible: true,
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Scaffold(
//               backgroundColor: Colors.black.withOpacity(0.1),
//               body: Stack(
//                 children: [
//                   Positioned(
//                     top: dialogTop,
//                     left: dialogLeft,
//                     child: ScaleTransition(
//                       scale: CurvedAnimation(
//                           parent: animation, curve: Curves.easeOutBack),
//                       child: Material(
//                         color: Colors.white,
//                         elevation: 8.0,
//                         borderRadius: BorderRadius.circular(12.0),
//                         child: InkWell(
//                           onTap: () {
//                             setState(() {
//                               _isSettingsActive = !_isSettingsActive;
//                               _category = Getcategory.getcategorydetails(
//                                   _isSettingsActive ? 'Service' : 'Product');
//                               _childcategory = [];
//                               _categoryList = []; // Clear category list
//                             });
//                             Navigator.of(context).pop();
//                           },
//                           child: SizedBox(
//                             width: dialogContentWidth,
//                             height: dialogContentHeight,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.asset(
//                                   _isSettingsActive
//                                       ? 'assets/icons/product.png'
//                                       : 'assets/icons/service.png',
//                                   width: 30,
//                                   height: 30,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   _isSettingsActive ? 'Product' : 'Service',
//                                   style: const TextStyle(fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         transitionDuration: const Duration(milliseconds: 300),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(
//             opacity: animation,
//             child: child,
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildDialogOption(
//       BuildContext context, String iconPath, VoidCallback onTap) {
//     return ListTile(
//       leading: Image.asset(
//         iconPath,
//         width: 40,
//         height: 40,
//         errorBuilder: (context, error, stackTrace) =>
//             const Icon(Icons.error, size: 40, color: Colors.red),
//       ),
//       onTap: onTap,
//     );
//   }
//
//   Future<void> logoutUser(BuildContext context) async {
//     await SharedPrefsHelper.clearUserData();
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const GetOtpScreen()),
//       (Route<dynamic> route) => false,
//     );
//   }
//
//   void _toggleVideoIconPosition() {
//     setState(() {
//       _isToggleRight = !_isToggleRight;
//     });
//     print('Video icon toggled to: ${_isToggleRight ? "Right" : "Left"}');
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _category = Getcategory.getcategorydetails(
//         _isSettingsActive ? 'Service' : 'Product');
//     _slider = GetSlider.getslider();
//     fetchLocation();
//     _initSpeechRecognizer();
//     _onItemTapped('1'); // Fetch child categories for default ID
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void fetchLocation() async {
//     LocationModel loc = await LocationFetchApi.getAddressFromLatLng();
//     setState(() {
//       location = loc;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isTablet = screenWidth >= 600;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: FutureBuilder<List<ProductCategoryModel>>(
//         future: _category,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: const Color(0xFF1E88E5), // Primary blue
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 "Error: ${snapshot.error}",
//                 style: GoogleFonts.poppins(
//                   fontSize: isTablet ? 16 : screenWidth * 0.03,
//                   color: Colors.grey.shade800,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 "No categories available",
//                 style: GoogleFonts.poppins(
//                   fontSize: isTablet ? 16 : screenWidth * 0.04,
//                   color: Colors.grey.shade800,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             );
//           }
//
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             setState(() {
//               _categoryList = snapshot.data!;
//             });
//           });
//
//           final category = snapshot.data!;
//
//           return Stack(
//             children: [
//               Column(
//                 children: [
//                   // Header
//                   // Header(location ?? LocationModel(
//                   //   main: "Loading...",
//                   //   detail: "",
//                   //   landmark: "",
//                   // )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   _buildNewsTicker(),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: screenWidth * 0.001,
//                       vertical: screenHeight * 0.0015,
//                     ),
//                     child: _buildSearchBar(
//                         context,
//                         location ??
//                             LocationModel(
//                               main: "Loading...",
//                               detail: "",
//                               landmark: "",
//                             )),
//                   ),
//                   FutureBuilder<List<SliderModel>>(
//                     future: _slider,
//                     builder: (context, sliderSnapshot) {
//                       if (sliderSnapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return SizedBox(
//                           height: 160,
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               color: const Color(0xFF1E88E5),
//                             ),
//                           ),
//                         );
//                       } else if (sliderSnapshot.hasError) {
//                         return SizedBox(
//                           height: 160,
//                           child: Center(
//                             child: Text(
//                               "Failed to load banners",
//                               style: GoogleFonts.poppins(
//                                 fontSize: isTablet ? 16 : screenWidth * 0.04,
//                                 color: Colors.grey.shade800,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         );
//                       } else if (!sliderSnapshot.hasData ||
//                           sliderSnapshot.data!.isEmpty) {
//                         return SizedBox(
//                           height: 160,
//                           child: Center(
//                             child: Text(
//                               "No banners available",
//                               style: GoogleFonts.poppins(
//                                 fontSize: isTablet ? 16 : screenWidth * 0.04,
//                                 color: Colors.grey.shade800,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//
//                       final sliderItems = sliderSnapshot.data!;
//                       return _buildSliderCard(context, sliderItems);
//                     },
//                   ),
//                   SizedBox(height: 10,),
//                   Container(
//                     height: 220, // adjusted height for cards
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                     decoration:  BoxDecoration(
//                       color: Color(0xFF00B3A7),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                           offset: Offset(0, 2),
//                         ),
//                       ]
//                     ),
//                     child: _childcategory.isEmpty
//                         ? Center(
//                       child: Text(
//                         "Select a category to view subcategories",
//                         style: GoogleFonts.poppins(
//                           fontSize: 12,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     )
//                         : ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: _childcategory.length,
//                       itemBuilder: (context, index) {
//                         final item = _childcategory[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 6),
//                           child: _buildCategoryCard(context, item),
//                         );
//                       },
//                     ),
//                   )
//
//                 ],
//               ),
//               Positioned(
//                 bottom: 70,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 80,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.white, Colors.grey.shade100],
//                       // Subtle gradient
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1), // Softer shadow
//                         spreadRadius: 1,
//                         blurRadius: 6,
//                         offset: const Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       SizedBox(width: screenWidth * 0.05),
//                       Semantics(
//                         label: _isSettingsActive ? 'Service' : 'Product',
//                         child: InkWell(
//                           key: _settingsIconKey,
//                           onTap: () => _showSettingsDialog(context),
//                           borderRadius: BorderRadius.circular(12),
//                           child: _buildBottomNavIcon(
//                             iconPath: _isSettingsActive
//                                 ? 'assets/icons/product.png'
//                                 : 'assets/icons/service.png',
//                             label: _isSettingsActive ? 'Service' : 'Product',
//                             index: 0,
//                             onTap: () => _showSettingsDialog(context),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: screenWidth * 0.05),
//                       Container(
//                         width: 1,
//                         height: 60, // adjust height to your liking
//                         color: Colors.grey.shade600,
//                       ),
//                       SizedBox(width: screenWidth * 0.03),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: category.map((item) {
//                               return Row(
//                                 children: [
//                                   Semantics(
//                                     label: item.categoryName,
//                                     child: _buildBottomNavIcon(
//                                       iconPath: item.fullImageUrl,
//                                       label: item.categoryName,
//                                       index: category.indexWhere((element) =>
//                                               element.id == item.id) +
//                                           1,
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => SingleRequest(
//                                               id: item.id.toString(),
//                                               childCatid: item.id
//                                                   .toString(), // ✅ pass subcategory
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(width: screenWidth * 0.05),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Bottomnavbar(
//                 onProfileTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => BusinessScreen()),
//                   );
//                 },
//                 onToggle: () => print("Toggle switched"),
//                 onBoxTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => VendorScreen()),
//                   );
//                   // logoutUser(context);
//                 },
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // Widget Header(LocationModel location) {
//   //   Future<void> openWhatsApp() async {
//   //     final Uri whatsappUrl = Uri.parse("https://wa.me/");
//   //     if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
//   //       throw Exception('Could not open WhatsApp');
//   //     }
//   //   }
//   //
//   //   return Container(
//   //     decoration: const BoxDecoration(
//   //       gradient: LinearGradient(
//   //         begin: Alignment.topLeft,
//   //         end: Alignment.bottomRight,
//   //         colors: [Color(0xFF00B3A7), Color(0xFF008D80)],
//   //       ),
//   //       borderRadius: BorderRadius.only(
//   //         bottomLeft: Radius.circular(35),
//   //         bottomRight: Radius.circular(35),
//   //       ),
//   //     ),
//   //     child: SafeArea(
//   //       child: Padding(
//   //         padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
//   //         child: Row(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             Expanded(
//   //               child: Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Row(
//   //                     children: [
//   //                       Flexible(
//   //                         child: Text(
//   //                           location.main,
//   //                           style: const TextStyle(
//   //                             color: Colors.white,
//   //                             fontSize: 16,
//   //                             fontWeight: FontWeight.bold,
//   //                           ),
//   //                           overflow: TextOverflow.ellipsis,
//   //                         ),
//   //                       ),
//   //                       const SizedBox(width: 4),
//   //                       const Icon(
//   //                         Icons.keyboard_arrow_down,
//   //                         color: Colors.white,
//   //                         size: 20,
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   const SizedBox(height: 4),
//   //                   Text(
//   //                     location.detail,
//   //                     style: const TextStyle(
//   //                       color: Colors.white70,
//   //                       fontSize: 12,
//   //                     ),
//   //                     overflow: TextOverflow.ellipsis,
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //             GestureDetector(
//   //               onTap: openWhatsApp,
//   //               child: Container(
//   //                 width: 40,
//   //                 height: 40,
//   //                 decoration: const BoxDecoration(
//   //                   shape: BoxShape.circle,
//   //                   image: DecorationImage(
//   //                     image: AssetImage('assets/icons/whatsapp.png'),
//   //                     fit: BoxFit.cover,
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildNewsTicker() {
//     return Container(
//       color: const Color(0xFF00B3A7), // background color
//       height: 40,
//       child: Marquee(
//         text: "Filipra Private Limited .. News Live   ",
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//         velocity: 50.0,
//         // speed of scrolling
//         blankSpace: 100,
//         // space between repeats
//         pauseAfterRound: Duration.zero,
//         startPadding: 10,
//       ),
//     );
//   }
//
//   Widget _buildSearchBar(BuildContext context, LocationModel location) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Search Box
//           Container(
//             height: 44,
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 border: Border.all(color: Color(0xFF00B3A7), width: 1),
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(10),
//                     bottomRight: Radius.circular(10))),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.location_on_outlined,
//                   size: 20,
//                   color: Colors.red,
//                 ),
//                 SizedBox(width: 3),
//                 Row(
//                   children: [
//                     Text(location.main),
//                     // Icon(
//                     //   Icons.keyboard_arrow_down,
//                     //   size: 18,
//                     //   color: Colors.black,
//                     // )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 2),
//           Expanded(
//             child: Container(
//               height: 44,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.95),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Color(0xFF00B3A7)),
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       _isListening ? _stopListening() : _startListening();
//                     },
//                     child: ScaleTransition(
//                       scale: _animation,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 3.0),
//                         child: Icon(
//                           Icons.mic,
//                           color: _isListening ? Colors.blue : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 24,
//                     width: 1,
//                     color: Colors.black,
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: _searchController,
//                       onChanged: (text) {
//                         setState(() {
//                           _isSearching = text.isNotEmpty;
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         hintText: 'Search',
//                         border: InputBorder.none,
//                         isDense: true,
//                         contentPadding: EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                   Container(
//                     height: 24,
//                     width: 1,
//                     color: Colors.black,
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: const [
//                         Icon(Icons.shopping_cart, color: Colors.grey, size: 18),
//                         SizedBox(width: 4),
//                         Text(
//                           'Shop',
//                           style: TextStyle(color: Colors.grey, fontSize: 12),
//                         ),
//                         Icon(Icons.keyboard_arrow_down,
//                             color: Colors.grey, size: 18),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSliderCard(BuildContext context, List<SliderModel> sliderItems) {
//     return SizedBox(
//       height: 130,
//       child: PageView.builder(
//         itemCount: sliderItems.length,
//         itemBuilder: (context, index) {
//           final item = sliderItems[index];
//           return Container(
//             margin: const EdgeInsets.symmetric(horizontal: 5),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               // rounded corners applied here
//               child: Stack(
//                 children: [
//                   // Background image
//                   Image.network(
//                     item.images,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     // ensures image fills and maintains aspect ratio
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.broken_image,
//                             size: 40, color: Colors.grey),
//                       );
//                     },
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return const Center(
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       );
//                     },
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.4),
//                         borderRadius: const BorderRadius.only(
//                           bottomLeft: Radius.circular(10),
//                           bottomRight: Radius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildCategoryCard(BuildContext context, CategoryModel item) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SingleRequest(
//               id: item.id.toString(),
//               childCatid: item.subcategory.toString(),
//             ),
//           ),
//         );
//       },
//       child: AnimatedScale(
//         duration: Duration(milliseconds: 200),
//         scale: 1.0,
//         child: Container(
//           width: 140,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.white], // Gradient for modern look
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 6,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       topLeft: Radius.circular(20),
//                     ),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         boxShadow:[
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             spreadRadius: 1,
//                             blurRadius: 3,
//                             offset: Offset(0, 2),
//                           ),
//                         ]
//                       ),
//                       child: Image.network(
//                         item.categoryImg,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         errorBuilder: (context, error, stackTrace) =>
//                         const Icon(Icons.broken_image, size: 40, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     bottomRight: Radius.circular(20),
//                     bottomLeft: Radius.circular(20)
//                   )
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                       child: Text(
//                         item.categoryName,
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.grey, // Contrast with gradient background
//                           letterSpacing: 0.5,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(top: 5,bottom: 5,left: 25,right: 25),
//                       decoration: BoxDecoration(
//                           color: Color(0xFF00B3A7),
//                           borderRadius: BorderRadius.circular(30)
//                       ),
//                       child: Text("Inquary"),
//                     ),
//                     SizedBox(height: 10,)
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavIcon({
//     Key? key,
//     required String iconPath,
//     required String label,
//     required int index,
//     required VoidCallback onTap,
//   }) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth >= 600;
//     final Color borderColor = (_selectedIndex == index)
//         ? const Color(0xFF1E88E5)
//         : Colors.grey.shade300;
//
//     bool isNetworkImage = iconPath.startsWith('http');
//
//     return Semantics(
//       label: label,
//       button: true,
//       child: InkWell(
//         key: key,
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: isTablet ? 56 : 50, // Responsive size
//               height: isTablet ? 56 : 50,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: borderColor,
//                   width:
//                       _selectedIndex == index ? 2 : 1, // Thicker for selected
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 6,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: isNetworkImage
//                     ? ClipOval(
//                         child: Image.network(
//                           iconPath,
//                           fit: BoxFit.cover,
//                           width: isTablet ? 48 : 42,
//                           height: isTablet ? 48 : 42,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Icon(
//                               Icons.broken_image,
//                               size: 28,
//                               color: Color(0xFF1E88E5), // Blue for consistency
//                             );
//                           },
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return SizedBox(
//                               width: 28,
//                               height: 28,
//                               child: Center(
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: const Color(0xFF1E88E5),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       )
//                     : Image.asset(
//                         iconPath,
//                         fit: BoxFit.cover,
//                         width: isTablet ? 48 : 42,
//                         height: isTablet ? 48 : 42,
//                       ),
//               ),
//             ),
//             const SizedBox(height: 3), // Slightly more spacing
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: isTablet ? 12 : screenWidth * 0.03,
//                 fontWeight: FontWeight.w500,
//                 color: _selectedIndex == index
//                     ? const Color(0xFF1E88E5) // Blue for selected
//                     : Colors.grey.shade800, // Darker gray for unselected
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flippra/screens/homescreens/vendors/vendorpannelscreen.dart';
import 'package:flippra/screens/widget/bottomnavbar.dart';
import 'package:flippra/screens/widget/singlerequest.dart';
import 'package:flutter/material.dart';
import 'package:flippra/screens/shop_screen.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../backend/home/getcategory/getchildcategory.dart';
import '../../../backend/home/getcategory/showproductcategory.dart';
import '../../../backend/home/getlocation/getlocation.dart';
import '../../../backend/home/getlocation/locationmodel.dart';
import '../../../backend/home/getslider/getslider.dart';
import '../../../backend/home/getslider/slidermodel.dart';
import '../../../utils/shared_prefs_helper.dart';
import '../../businessprofile.dart';
import '../../get_otp_screen.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import '../../widget/home/header.dart';

// Define GetChildCategory (from your previous code)

class HomeScreenCategoryScreen extends StatefulWidget {
  const HomeScreenCategoryScreen({super.key});

  @override
  State<HomeScreenCategoryScreen> createState() =>
      _HomeScreenCategoryScreenState();
}

class _HomeScreenCategoryScreenState extends State<HomeScreenCategoryScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedLanguage = 'English';
  bool _isToggleRight = true;
  bool _isSettingsActive = true;
  bool _isSearching = false;
  late List<CategoryModel> _childcategory = [];
  late List<ProductCategoryModel> _categoryList = [];
  late Future<List<ProductCategoryModel>> _category;
  late Future<List<SliderModel>> _slider;
  LocationModel? location;
  final GlobalKey _languageIconKey = GlobalKey();
  final GlobalKey _settingsIconKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  // late SpeechRecognition _speech;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // void _initSpeechRecognizer() {
  //   _speech = SpeechRecognition();
  //
  //   _speech.setAvailabilityHandler((bool result) {
  //     if (!result) {
  //       print("Speech recognition not available.");
  //     }
  //   });
  //
  //   _speech.setRecognitionStartedHandler(() {
  //     setState(() {
  //       _isListening = true;
  //     });
  //     _animationController.repeat(reverse: true);
  //     print('✅ Listening started. _isListening is now: $_isListening');
  //   });
  //
  //   _speech.setRecognitionResultHandler((String recognizedText) {
  //     _searchController.text = recognizedText;
  //   });
  //
  //   _speech.setRecognitionCompleteHandler((String recognizedText) {
  //     setState(() {
  //       _isListening = false;
  //     });
  //     _animationController.stop();
  //     print('❌ Listening complete. _isListening is now: $_isListening');
  //   });
  //
  //   _speech.setErrorHandler(() {
  //     setState(() {
  //       _isListening = false;
  //     });
  //     _animationController.stop();
  //     print(
  //         '⚠ Speech recognition error occurred. _isListening is now: $_isListening');
  //   });
  // }
  void _initSpeechRecognizer() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
          _animationController.stop();
          print('❌ Listening complete or stopped. _isListening: $_isListening');
        }
      },
      onError: (errorNotification) {
        setState(() {
          _isListening = false;
        });
        _animationController.stop();
        print('⚠ Speech recognition error: ${errorNotification.errorMsg}');
      },
    );

    if (!available) {
      print("Speech recognition not available.");
    }
  }
  Future<bool> _requestPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.microphone.request();
      return result.isGranted;
    }
  }

  // void _startListening() async {
  //   bool hasPermission = await _requestPermission();
  //   if (hasPermission) {
  //     speech.activate('en_US').then(() {
  //       _speech.listen();
  //     });
  //   } else {
  //     print("Microphone permission denied.");
  //   }
  // }
  void _startListening() async {
    bool hasPermission = await _requestPermission();
    if (!hasPermission) {
      print("Microphone permission denied.");
      return;
    }

    if (!_isListening && await _speech.hasPermission && _speech.isAvailable) {
      setState(() {
        _isListening = true;
      });
      _animationController.repeat(reverse: true);

      _speech.listen(
        onResult: (result) {
          setState(() {
            _searchController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 30),
        localeId: 'en_US',
        cancelOnError: true,
        partialResults: true,
      );
      print('✅ Listening started with speech_to_text. _isListening: $_isListening');
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
      _animationController.stop();
      print('Stopped listening manually.');
    }
  }


  // void _stopListening() {
  //   _speech.stop();
  // }

  void _onItemTapped(String categoryId) async {
    try {
      final childCategories =
      await GetChildCategory.getchildcategorydetails(categoryId);
      setState(() {
        _childcategory = childCategories;
        _selectedIndex =
            _categoryList.indexWhere((item) => item.id == categoryId) + 1;
      });
    } catch (e) {
      print('Error fetching child categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load child categories: $e')),
      );
    }
  }

  void _showLanguageSelection(BuildContext context) {
    final RenderBox? renderBox =
    _languageIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print('ERROR: Language icon RenderBox not found.');
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    const double dialogContentWidth = 150.0;
    const double dialogContentHeight = 56.0;

    double dialogLeft = offset.dx + size.width - dialogContentWidth;
    const double horizontalPadding = 8.0;

    if (dialogLeft < horizontalPadding) {
      dialogLeft = horizontalPadding;
    }
    if (dialogLeft + dialogContentWidth > screenWidth - horizontalPadding) {
      dialogLeft = screenWidth - dialogContentWidth - horizontalPadding;
    }

    double dialogTop = offset.dy + size.height + 8.0;
    const double bottomNavHeight = 100.0;
    if (dialogTop + dialogContentHeight > screenHeight - bottomNavHeight) {
      dialogTop = offset.dy - dialogContentHeight - 8.0;
      if (dialogTop < MediaQuery.of(context).padding.top + 8.0) {
        dialogTop = MediaQuery.of(context).padding.top + 8.0;
      }
    }

    String optionLanguage;
    Widget optionDisplayWidget;

    if (_selectedLanguage == 'English') {
      optionLanguage = 'Hindi';
      optionDisplayWidget = const Text(
        'अ',
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else {
      optionLanguage = 'English';
      optionDisplayWidget = Image.asset(
        'assets/icons/english.png',
        width: 24,
        height: 24,
        errorBuilder: (context, error, stackTrace) {
          print('ERROR: Dialog Image.asset failed to load english.png: $error');
          return const Icon(Icons.error, color: Colors.red, size: 24);
        },
      );
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Align(
          alignment: Alignment.topLeft,
          child: Transform.translate(
            offset: Offset(dialogLeft, dialogTop),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: dialogContentWidth,
                height: dialogContentHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: optionDisplayWidget,
                      title: Text(optionLanguage),
                      onTap: () {
                        setState(() {
                          _selectedLanguage = optionLanguage;
                        });
                        Navigator.pop(context);
                        print('Language set to $_selectedLanguage');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            alignment: Alignment.topRight,
            child: child,
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    final RenderBox? renderBox =
    _settingsIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      print('ERROR: Product icon RenderBox not found.');
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    final double screenWidth = MediaQuery.of(context).size.width;
    const double dialogContentWidth = 60.0;
    const double dialogContentHeight = 60.0;
    const double padding = 8.0;

    double dialogTop = offset.dy - dialogContentHeight;
    if (dialogTop < MediaQuery.of(context).padding.top + padding) {
      dialogTop = MediaQuery.of(context).padding.top + padding;
    }

    double dialogLeft = offset.dx + (size.width / 2) - (dialogContentWidth / 2);
    if (dialogLeft < padding) {
      dialogLeft = padding;
    } else if (dialogLeft + dialogContentWidth > screenWidth - padding) {
      dialogLeft = screenWidth - dialogContentWidth - padding;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Scaffold(
              backgroundColor: Colors.black.withOpacity(0.1),
              body: Stack(
                children: [
                  Positioned(
                    top: dialogTop,
                    left: dialogLeft,
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                          parent: animation, curve: Curves.easeOutBack),
                      child: Material(
                        color: Colors.white,
                        elevation: 8.0,
                        borderRadius: BorderRadius.circular(12.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isSettingsActive = !_isSettingsActive;
                              _category = Getcategory.getcategorydetails(
                                  _isSettingsActive ? 'Service' : 'Product');
                              _childcategory = [];
                              _categoryList = []; // Clear category list
                            });
                            Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            width: dialogContentWidth,
                            height: dialogContentHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  _isSettingsActive
                                      ? 'assets/icons/product.png'
                                      : 'assets/icons/service.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _isSettingsActive ? 'Product' : 'Service',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildDialogOption(
      BuildContext context, String iconPath, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 40,
        height: 40,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.error, size: 40, color: Colors.red),
      ),
      onTap: onTap,
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    await SharedPrefsHelper.clearUserData();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const GetOtpScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void _toggleVideoIconPosition() {
    setState(() {
      _isToggleRight = !_isToggleRight;
    });
    print('Video icon toggled to: ${_isToggleRight ? "Right" : "Left"}');
  }

  @override
  void initState() {
    super.initState();
    _category = Getcategory.getcategorydetails(
        _isSettingsActive ? 'Service' : 'Product');
    _slider = GetSlider.getslider();
    fetchLocation();
    _initSpeechRecognizer();
    // Initialize child categories with a default category ID
    _onItemTapped('1'); // Fetch child categories for default ID
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void fetchLocation() async {
    LocationModel loc = await LocationFetchApi.getAddressFromLatLng();
    setState(() {
      location = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      // Ensure background is white to avoid rendering issues
      body: FutureBuilder<List<ProductCategoryModel>>(
        future: _category,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF1E88E5), // Primary blue
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : screenWidth * 0.03,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No categories available",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 16 : screenWidth * 0.04,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _categoryList = snapshot.data!;
            });
          });

          final category = snapshot.data!;

          return Stack(
            children: [
              Column(
                children: [
                  // Header
                  // Header(location ?? LocationModel(
                  //   main: "Loading...",
                  //   detail: "",
                  //   landmark: "",
                  // )),

                  SizedBox(
                    height: 10,
                  ),
                  _buildNewsTicker(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.001,
                      vertical: screenHeight * 0.0015,
                    ),
                    child: _buildSearchBar(
                        context,
                        location ??
                            LocationModel(
                              main: "Loading...",
                              detail: "",
                              landmark: "",
                            )),
                  ),
                  FutureBuilder<List<SliderModel>>(
                    future: _slider,
                    builder: (context, sliderSnapshot) {
                      if (sliderSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox(
                          height: 160,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: const Color(0xFF1E88E5),
                            ),
                          ),
                        );
                      } else if (sliderSnapshot.hasError) {
                        return SizedBox(
                          height: 160,
                          child: Center(
                            child: Text(
                              "Failed to load banners",
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 16 : screenWidth * 0.04,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      } else if (!sliderSnapshot.hasData ||
                          sliderSnapshot.data!.isEmpty) {
                        return SizedBox(
                          height: 160,
                          child: Center(
                            child: Text(
                              "No banners available",
                              style: GoogleFonts.poppins(
                                fontSize: isTablet ? 16 : screenWidth * 0.04,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      final sliderItems = sliderSnapshot.data!;
                      return _buildSliderCard(context, sliderItems);
                    },
                  ),
                  SizedBox(height: 10,),
                  // Container(
                  //   height: 220, // adjusted height for cards
                  //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  //   decoration:  BoxDecoration(
                  //       color: Color(0xFF00B3A7),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.2),
                  //           spreadRadius: 1,
                  //           blurRadius: 3,
                  //           offset: Offset(0, 2),
                  //         ),
                  //       ]
                  //   ),
                  //   child: _childcategory.isEmpty
                  //       ? Center(
                  //     child: Text(
                  //       "Select a category to view subcategories",
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 12,
                  //         color: Colors.white,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   )
                  //       : ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: _childcategory.length,
                  //     itemBuilder: (context, index) {
                  //       final item = _childcategory[index];
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 6),
                  //         child: _buildCategoryCard(context, item),
                  //       );
                  //     },
                  //   ),
                  // )

                ],
              ),
              Positioned(
                bottom: 70,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade100],
                      // Subtle gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Softer shadow
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: screenWidth * 0.05),
                      Semantics(
                        label: _isSettingsActive ? 'Service' : 'Product',
                        child: InkWell(
                          key: _settingsIconKey,
                          onTap: () => _showSettingsDialog(context),
                          borderRadius: BorderRadius.circular(12),
                          child: _buildBottomNavIcon(
                            iconPath: _isSettingsActive
                                ? 'assets/icons/product.png'
                                : 'assets/icons/service.png',
                            label: _isSettingsActive ? 'Service' : 'Product',
                            index: 0,
                            onTap: () => _showSettingsDialog(context),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Container(
                        width: 1,
                        height: 60, // adjust height to your liking
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: category.map((item) {
                              return Row(
                                children: [
                                  Semantics(
                                    label: item.categoryName,
                                    child: _buildBottomNavIcon(
                                      iconPath: item.fullImageUrl,
                                      label: item.categoryName,
                                      index: category.indexWhere((element) =>
                                      element.id == item.id) +
                                          1,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SingleRequest(
                                              id: item.id.toString(),
                                              childCatid: item.id
                                                  .toString(), // ✅ pass subcategory
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Bottomnavbar(
                onProfileTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BusinessScreen()),
                  );
                },
                onToggle: () => print("Toggle switched"),
                onBoxTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorScreen()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget Header(LocationModel location) {
  //   Future<void> openWhatsApp() async {
  //     final Uri whatsappUrl = Uri.parse("https://wa.me/");
  //     if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
  //       throw Exception('Could not open WhatsApp');
  //     }
  //   }
  //
  //   return Container(
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFF00B3A7), Color(0xFF008D80)],
  //       ),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(35),
  //         bottomRight: Radius.circular(35),
  //       ),
  //     ),
  //     child: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Flexible(
  //                         child: Text(
  //                           location.main,
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 4),
  //                       const Icon(
  //                         Icons.keyboard_arrow_down,
  //                         color: Colors.white,
  //                         size: 20,
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     location.detail,
  //                     style: const TextStyle(
  //                       color: Colors.white70,
  //                       fontSize: 12,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: openWhatsApp,
  //               child: Container(
  //                 width: 40,
  //                 height: 40,
  //                 decoration: const BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   image: DecorationImage(
  //                     image: AssetImage('assets/icons/whatsapp.png'),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNewsTicker() {
    return Container(
      color: const Color(0xFF00B3A7), // background color
      height: 40,
      child: Marquee(
        text: "Filipra Private Limited .. News Live   ",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        velocity: 50.0,
        // speed of scrolling
        blankSpace: 100,
        // space between repeats
        pauseAfterRound: Duration.zero,
        startPadding: 10,
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, LocationModel location) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Search Box
          Container(
            height: 44,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF00B3A7), width: 1),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.red,
                ),
                SizedBox(width: 3),
                Row(
                  children: [
                    Text(location.main),
                    // Icon(
                    //   Icons.keyboard_arrow_down,
                    //   size: 18,
                    //   color: Colors.black,
                    // )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF00B3A7)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _isListening ? _stopListening() : _startListening();
                    },
                    child: ScaleTransition(
                      scale: _animation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Icon(
                          Icons.mic,
                          color: _isListening ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (text) {
                        setState(() {
                          _isSearching = text.isNotEmpty;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.shopping_cart, color: Colors.grey, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Shop',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Icon(Icons.keyboard_arrow_down,
                            color: Colors.grey, size: 18),
                      ],
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

  Widget _buildSliderCard(BuildContext context, List<SliderModel> sliderItems) {
    return SizedBox(
      height: 130,
      child: PageView.builder(
        itemCount: sliderItems.length,
        itemBuilder: (context, index) {
          final item = sliderItems[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              // rounded corners applied here
              child: Stack(
                children: [
                  // Background image
                  Image.network(
                    item.images,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    // ensures image fills and maintains aspect ratio
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image,
                            size: 40, color: Colors.grey),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleRequest(
              id: item.id.toString(),
              childCatid: item.subcategory.toString(),
            ),
          ),
        );
      },
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: 1.0,
        child: Container(
          width: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white], // Gradient for modern look
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow:[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ]
                      ),
                      child: Image.network(
                        item.categoryImg,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)
                    )
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Text(
                        item.categoryName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey, // Contrast with gradient background
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5,bottom: 5,left: 25,right: 25),
                      decoration: BoxDecoration(
                          color: Color(0xFF00B3A7),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Inquary"),
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavIcon({
    Key? key,
    required String iconPath,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final Color borderColor = (_selectedIndex == index)
        ? const Color(0xFF1E88E5)
        : Colors.grey.shade300;

    bool isNetworkImage = iconPath.startsWith('http');

    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        key: key,
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: isTablet ? 56 : 50, // Responsive size
              height: isTablet ? 56 : 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width:
                  _selectedIndex == index ? 2 : 1, // Thicker for selected
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: isNetworkImage
                    ? ClipOval(
                  child: Image.network(
                    iconPath,
                    fit: BoxFit.cover,
                    width: isTablet ? 48 : 42,
                    height: isTablet ? 48 : 42,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 28,
                        color: Color(0xFF1E88E5), // Blue for consistency
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 28,
                        height: 28,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: const Color(0xFF1E88E5),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Image.asset(
                  iconPath,
                  fit: BoxFit.cover,
                  width: isTablet ? 48 : 42,
                  height: isTablet ? 48 : 42,
                ),
              ),
            ),
            const SizedBox(height: 3), // Slightly more spacing
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: isTablet ? 12 : screenWidth * 0.03,
                fontWeight: FontWeight.w500,
                color: _selectedIndex == index
                    ? const Color(0xFF1E88E5) // Blue for selected
                    : Colors.grey.shade800, // Darker gray for unselected
              ),
            ),
          ],
        ),
      ),
    );
  }
}
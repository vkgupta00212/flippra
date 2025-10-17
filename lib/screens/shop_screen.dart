// import 'dart:ui';
// import 'package:flippra/screens/requestscreen.dart';
// import 'package:flippra/screens/widget/bottomnavbar.dart';
// import 'package:flippra/screens/widget/requestcard.dart';
// import 'package:flippra/screens/widget/singlerequest.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import '../backend/category/getbusinesscards/getbusinesscard.dart';
// import '../backend/home/getcategory/getchildcategory.dart';
// import 'cartscreen.dart';
//
// class ShopScreen extends StatefulWidget {
//   final String id;
//   final String childCatid;
//   const ShopScreen({Key? key, required this.id,required this.childCatid}) : super(key: key);
//
//   @override
//   State<ShopScreen> createState() => _ShopScreenState();
// }
//
// class _ShopScreenState extends State<ShopScreen> {
//   final MapController _mapController = MapController();
//   Position? _currentPosition;
//   String _locationText1 = 'Fetching location...';
//   String _locationText2 = '';
//   String _locationText3 = '';
//   int _selectedIndex = 0;
//   int _selectedServiceIndex = 0;
//   bool _isToggleRight = false;
//   late Future<List<GetBusinessCardModel>> _businesscard;
//   late List<CategoryModel> _childcategory = [];
//   bool _isLoading = true;
//   final GlobalKey<FloatingRequestCardState> _floatingCardKey =
//   GlobalKey<FloatingRequestCardState>();
//   OverlayEntry? _floatingEntry;
//   final Set<int> _cartItems = {};
//
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _fetchChildCategory();
//     _businesscard = GetBusinessCard.getbusinesscard(widget.id);
//   }
//
//   Future<void> _fetchChildCategory() async {
//     final data = await GetChildCategory.getchildcategorydetails(widget.childCatid);
//     setState(() {
//       _childcategory = data;
//       _isLoading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _hideFloatingRequestCard();
//     super.dispose();
//   }
//
//   void _hideFloatingRequestCard() {
//     _floatingEntry?.remove();
//     _floatingEntry = null;
//   }
//
//   void _showFloatingRequestCard() {
//     final overlay = Overlay.of(context);
//     if (overlay == null || _floatingEntry != null) return;
//
//     late OverlayEntry entry;
//     entry = OverlayEntry(
//       builder: (context) => Positioned(
//         bottom: 0,
//         left: 0,
//         right: 0,
//         child: FloatingRequestCard(
//           key: _floatingCardKey,
//           onRemove: () {
//             entry.remove();
//             _floatingEntry = null;
//           },
//         ),
//       ),
//     );
//
//     _floatingEntry = entry;
//     overlay.insert(entry);
//   }
//
//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (mounted) setState(() => _locationText1 = 'Location services disabled');
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (mounted) setState(() => _locationText1 = 'Location permissions denied');
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       if (mounted) {
//         setState(() =>
//         _locationText1 = 'Location permissions permanently denied');
//       }
//       return;
//     }
//
//     try {
//       final pos =
//       await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
//
//       if (!mounted) return;
//
//       _currentPosition = pos;
//
//       if (placemarks.isNotEmpty) {
//         final place = placemarks[0];
//         setState(() {
//           _locationText1 =
//           '${place.locality ?? 'Unknown'} - ${place.postalCode ?? ''}';
//           _locationText2 = place.subLocality ?? place.street ?? '';
//           _locationText3 = 'Near ${place.name ?? place.thoroughfare ?? ''}';
//         });
//       } else {
//         setState(() => _locationText1 = 'No location data available');
//       }
//
//       _mapController.move(LatLng(pos.latitude, pos.longitude), 16.0);
//     } catch (e) {
//       if (mounted) setState(() => _locationText1 = 'Error fetching location');
//     }
//   }
//
//   void _toggleVideoIconPosition() {
//     setState(() => _isToggleRight = !_isToggleRight);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF00B3A7),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               _buildMapSection(),
//               _buildBusinessCardList(),
//             ],
//           ),
//           _buildBackButton(),
//           _buildBottomNavigationBar(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMapSection() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.45,
//       color: Colors.grey[200],
//       child: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: const MapOptions(
//               initialCenter: LatLng(28.7041, 77.1025),
//               initialZoom: 11.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate:
//                 'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey={apiKey}',
//                 additionalOptions: const {
//                   'apiKey': '2a411b50aafc4c1996eca70d594a314c'
//                 },
//               ),
//               if (_currentPosition != null)
//                 CircleLayer(
//                   circles: [
//                     CircleMarker(
//                       point: LatLng(_currentPosition!.latitude,
//                           _currentPosition!.longitude),
//                       color: Colors.red.withOpacity(0.3),
//                       borderStrokeWidth: 1,
//                       borderColor: Colors.red,
//                       radius: 100,
//                     ),
//                   ],
//                 ),
//               if (_currentPosition != null)
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: LatLng(_currentPosition!.latitude,
//                           _currentPosition!.longitude),
//                       width: 40.0,
//                       height: 40.0,
//                       child: const Icon(Icons.location_pin,
//                           color: Colors.red, size: 40),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//           _buildLocationInfoBar(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationInfoBar() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 20.0),
//         decoration: const BoxDecoration(
//           color: Color(0xFF00B3A7),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30.0),
//             topRight: Radius.circular(30.0),
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: const BorderRadius.only(
//                     topRight: Radius.circular(50.0),
//                     bottomRight: Radius.circular(50.0),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(_locationText1,
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold)),
//                           Text(_locationText2,
//                               style: const TextStyle(
//                                   color: Colors.white70, fontSize: 12)),
//                           Text(_locationText3,
//                               style: const TextStyle(
//                                   color: Colors.white70, fontSize: 12)),
//                         ],
//                       ),
//                     ),
//                     const Icon(Icons.keyboard_arrow_down,
//                         color: Colors.white, size: 20),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(30.0),
//                   bottomLeft: Radius.circular(30.0),
//                 ),
//               ),
//               child: Row(
//                 children: const [
//                   Text('Filters',
//                       style: TextStyle(color: Colors.white, fontSize: 14)),
//                   SizedBox(width: 4),
//                   Icon(Icons.keyboard_arrow_down,
//                       color: Colors.white, size: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBusinessCardList() {
//     return Expanded(
//       child: FutureBuilder<List<GetBusinessCardModel>>(
//         future: _businesscard,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("No business cards available"));
//           }
//
//           final cards = snapshot.data!;
//           return Container(
//             color: const Color(0xFF00B3A7),
//             margin: const EdgeInsets.only(bottom: 100),
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: cards.length,
//               itemBuilder: (context, index) =>
//                   _buildBusinessCard(context, cards[index]),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildBusinessCard(BuildContext context, GetBusinessCardModel card) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: (card.fullImageUrl.isNotEmpty)
//                         ? NetworkImage(card.fullImageUrl)
//                         : const AssetImage(
//                         "assets/icons/business_card_placeholder.png")
//                     as ImageProvider,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               SizedBox(
//                 width: 100,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       if (_cartItems.contains(card.id)) {
//                         _cartItems.remove(card.id);
//                         _floatingCardKey.currentState?.removeAvatar(card);
//                         if (_cartItems.isEmpty) {
//                           _hideFloatingRequestCard();
//                         }
//                       } else {
//                         _cartItems.add(card.id);
//                         if (_floatingEntry == null) {
//                           _showFloatingRequestCard();
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             _floatingCardKey.currentState?.addAvatar(card);
//                           });
//                         } else {
//                           _floatingCardKey.currentState?.addAvatar(card);
//                         }
//                       }
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                     _cartItems.contains(card.id) ? Colors.red : Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                   ),
//                   child: Text(
//                     _cartItems.contains(card.id) ? 'Remove' : 'Add',
//                     style: const TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(card.productName,
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Text("₹ ${card.price}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold)),
//                     const SizedBox(width: 10),
//                     _buildRatingStars(double.tryParse(card.rating) ?? 0),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => const SingleRequest()));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30.0),
//                           bottomLeft: Radius.circular(30.0),
//                         ),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 10),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(Icons.send,
//                               color: Colors.black, size: 18),
//                         ),
//                         const SizedBox(width: 8),
//                         const Text('Request Now',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRatingStars(double rating) {
//     int fullStars = rating.floor();
//     bool hasHalfStar = (rating - fullStars) >= 0.5;
//
//     return Row(
//       children: List.generate(5, (index) {
//         if (index < fullStars) {
//           return const Icon(Icons.star, color: Colors.amber, size: 20);
//         } else if (index == fullStars && hasHalfStar) {
//           return const Icon(Icons.star_half, color: Colors.amber, size: 20);
//         } else {
//           return const Icon(Icons.star_border, color: Colors.amber, size: 20);
//         }
//       }),
//     );
//   }
//
//   Widget _buildBackButton() {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 10,
//       left: 10,
//       child: GestureDetector(
//         onTap: () => Navigator.of(context).pop(),
//         child: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.4),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomNavigationBar() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               spreadRadius: 2,
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//
//                 child: Container(
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.3),
//                       width: 1.5,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _isLoading
//                             ? const Center(child: CircularProgressIndicator())
//                             : SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: _childcategory.map((item) {
//                               return Row(
//                                 children: [
//                                   Semantics(
//                                     label: item.categoryName,
//                                     child: _buildBottomNavIcon(
//                                       iconPath: item.categoryImg,
//                                       label: item.categoryName,
//                                       index: _childcategory.indexWhere((element) => element.id == item.id) + 1,
//                                       onTap: () {
//                                         setState(() {
//                                           _businesscard = GetBusinessCard.getbusinesscard(item.id.toString());
//                                         });
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
//             Bottomnavbar(
//               onProfileTap: () => print("Profile tapped"),
//               onToggle: () => print("Toggle switched"),
//               onBoxTap: () => print("Box tapped"),
//             ),
//           ],
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
//               width: isTablet ? 56 : 40, // Responsive size
//               height: isTablet ? 56 : 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: borderColor,
//                   width: _selectedIndex == index ? 2 : 1, // Thicker for selected
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
//                   child: Image.network(
//                     iconPath,
//                     fit: BoxFit.cover,
//                     width: isTablet ? 48 : 42,
//                     height: isTablet ? 48 : 42,
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Icon(
//                         Icons.broken_image,
//                         size: 28,
//                         color: Color(0xFF1E88E5), // Blue for consistency
//                       );
//                     },
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return SizedBox(
//                         width: 28,
//                         height: 28,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: const Color(0xFF1E88E5),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//                     : Image.asset(
//                   iconPath,
//                   fit: BoxFit.cover,
//                   width: isTablet ? 48 : 42,
//                   height: isTablet ? 48 : 42,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 3), // Slightly more spacing
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: isTablet ? 12 : screenWidth * 0.028,
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
//
//   Widget _buildServiceIcon(String imagePath, String label, int index) {
//     bool isSelected = _selectedServiceIndex == index;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedServiceIndex = index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(2),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.red : const Color(0xFF00B3A7),
//               shape: BoxShape.circle,
//             ),
//             child: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(imagePath, fit: BoxFit.contain),
//               ),
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? Colors.black : Colors.grey.shade600,
//               fontSize: 12,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
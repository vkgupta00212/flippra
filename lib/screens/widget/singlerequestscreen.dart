import 'dart:ui';
import 'package:flippra/backend/category/getacceptvendor/getacceptvendor.dart';
import 'package:flippra/core/constant.dart';
import 'package:flippra/screens/widget/chatscreen2.dart';
import 'package:flippra/screens/widget/requestcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../backend/category/getbusinesscards/getbusinesscard.dart';
import '../../backend/home/getcategory/getchildcategory.dart';
import 'package:flutter/services.dart';
import '../../backend/order/showacceptvendor.dart';
import 'package:shimmer/shimmer.dart';


class SingleRequestScreen extends StatefulWidget {
  final GetBusinessCardModel card;
  // final String Rid;
  const SingleRequestScreen({Key? key, required this.card}) : super(key: key);

  @override
  State<SingleRequestScreen> createState() => _SingleRequestScreenState();
}

class _SingleRequestScreenState extends State<SingleRequestScreen> {
  final MapController _mapController = MapController();
  Position? _currentPosition;
  String _locationText1 = 'Fetching location...';
  String _locationText2 = '';
  String _locationText3 = '';
  int _selectedIndex = 0;
  int _selectedServiceIndex = 0;
  bool _isToggleRight = false;
  late Future<List<GetBusinessCardModel>> _businesscard;
  late List<CategoryModel> _childcategory = [];
  bool _isLoading = true;
  final GlobalKey<FloatingRequestCardState> _floatingCardKey =
  GlobalKey<FloatingRequestCardState>();
  OverlayEntry? _floatingEntry;
  final Set<int> _cartItems = {};
  final showacceptvendor = Get.put(GetAcceptVendorsController());
  final String Rid = "20";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    showacceptvendor.fetchAcceptedVendors(Rid);
    showacceptvendor.startAutoRefresh(requestId: Rid,intervalSeconds:1);
  }


  @override
  void dispose() {
    _hideFloatingRequestCard();
    super.dispose();
  }

  void _hideFloatingRequestCard() {
    _floatingEntry?.remove();
    _floatingEntry = null;
  }

  void _showFloatingRequestCard() {
    final overlay = Overlay.of(context);
    if (overlay == null || _floatingEntry != null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) =>
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingRequestCard(
              key: _floatingCardKey,
              onRemove: () {
                entry.remove();
                _floatingEntry = null;
              },
            ),
          ),
    );

    _floatingEntry = entry;
    overlay.insert(entry);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() =>
      _locationText1 = 'Location services disabled');
      return;
      }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() =>
        _locationText1 = 'Location permissions denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() =>
        _locationText1 = 'Location permissions permanently denied');
      }
      return;
    }

    try {
      final pos =
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final placemarks = await placemarkFromCoordinates(
          pos.latitude, pos.longitude);

      if (!mounted) return;

      _currentPosition = pos;

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        setState(() {
          _locationText1 =
          '${place.locality ?? 'Unknown'} - ${place.postalCode ?? ''}';
          _locationText2 = place.subLocality ?? place.street ?? '';
          _locationText3 = 'Near ${place.name ?? place.thoroughfare ?? ''}';
        });
      } else {
        setState(() => _locationText1 = 'No location data available');
      }

      _mapController.move(LatLng(pos.latitude, pos.longitude), 16.0);
    } catch (e) {
      if (mounted) setState(() => _locationText1 = 'Error fetching location');
    }
  }

  void _toggleVideoIconPosition() {
    setState(() => _isToggleRight = !_isToggleRight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(   // ✅ keeps content below system top bar
        child: Stack(
          children: [
            Column(
              children: [
                _buildMapSection(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildRequestVendor(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Column(
      children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.3,
          color: Colors.grey[200],
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(28.7041, 77.1025),
                  initialZoom: 11.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey={apiKey}',
                    additionalOptions: const {
                      'apiKey': '2a411b50aafc4c1996eca70d594a314c'
                    },
                  ),
                  if (_currentPosition != null)
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          color: Colors.red.withOpacity(0.3),
                          borderStrokeWidth: 1,
                          borderColor: Colors.red,
                          radius: 100,
                        ),
                      ],
                    ),
                  if (_currentPosition != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude),
                          width: 40.0,
                          height: 40.0,
                          child: const Icon(Icons.location_pin,
                              color: Colors.red, size: 40),
                        ),
                      ],
                    ),

                ],
              ),
            ],
          ),
          ),
        SizedBox(
          height: 140, // card height
          child: PageView(
            controller: PageController(
              viewportFraction: 0.85, // so left & right cards peek out
            ),
            children: [
                ServiceCard(
                title: widget.card.productName,
                subtitle: "",
                buttonText: "Request sent",
                imageAsset: widget.card.fullImageUrl,
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery
          .of(context)
          .padding
          .top + 10,
      left: 10,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  Widget emptyVendorProgress() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: List.generate(
            3,
                (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: const Color(0xFF00B3A7),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 25,bottom: 25,left: 20,right: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            child: Column(
                              children: [
                                _shimmerBox(
                                  height: 60,
                                  width: 100,
                                  borderRadius: 70,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _shimmerBox(height: 16, width: 80),
                                const SizedBox(height: 6),
                                _shimmerBox(height: 18, width: 140),
                                const SizedBox(height: 6),
                                _shimmerBox(height: 12, width: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double height,
    double? width,
    double borderRadius = 4,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildRequestVendor(BuildContext context) {
    return StreamBuilder<List<AcceptVendorModel>>(
      stream: showacceptvendor.vendorStream, // from controller
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // } else
         if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return emptyVendorProgress();
        }

        final vendors = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: vendors.map((vendor) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen2(card: widget.card,vendor: vendor,)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B3A7),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        children: [
                          VendorFooter(vendor),
                          const SizedBox(height: 5),
                          Container(
                            width: 350,
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 60,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: widget.card.fullImageUrl.isNotEmpty
                                              ? NetworkImage(widget.card.fullImageUrl)
                                              : const AssetImage("assets/icons/business_card_placeholder.png") as ImageProvider,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.card.price ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    Text(
                                      widget.card.productName ?? "N/A",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    const Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// class RequestVendorCard extends StatelessWidget {
//   const RequestVendorCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return _buildRequestVendor(context);
//   }
// }




Widget VendorFooter(AcceptVendorModel vendor) {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile / Vendor Image + Name
        Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(vendor.vendorImg),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              vendor.vendorName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined, color: Colors.white, size: 25),
                    const SizedBox(height: 4),
                    Text(
                      'Rating',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_emotions_outlined, color: Colors.white, size: 25),
                    const SizedBox(height: 4),
                    Text(
                      'Happy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.perm_identity_outlined, color: Colors.white, size: 25),
                    const SizedBox(height: 4),
                    Text(
                      "", // Example: show phone
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined, color: Colors.white, size: 25),
                    const SizedBox(height: 4),
                    Text(
                      "", // show location
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 25),
                    const SizedBox(height: 4),
                    Text(
                      "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class InfoCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final double width;

  const InfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.width,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B3A7), Color(0xFF006D5B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Icon(
              widget.icon,
              size: isTablet ? 28 : 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 12 : 9,
              color: Colors.white70,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;
  final String imageAsset;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
    required this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade600, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.12),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Service Image (Circular with border)
          Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade200, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[400],
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 10),

                // Action Button
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




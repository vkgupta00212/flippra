import 'dart:async';
import 'dart:math';
import 'package:flippra/backend/category/getbusinesscards/updatebusinesscard.dart';
import 'package:flippra/backend/getuser/getuser.dart';
import 'package:flippra/backend/insertquery/insertquery.dart';
import 'package:flippra/backend/request_accept/requestservice.dart';
import 'package:flippra/screens/widget/bottomnavbar.dart';
import 'package:flippra/screens/widget/requestcard.dart';
import 'package:flippra/screens/widget/singlerequestscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shimmer/shimmer.dart';
import '../../backend/category/getbusinesscards/getbusinesscard.dart';
import '../../backend/getnearvendor/getnearvendor.dart';
import '../../backend/home/getcategory/getchildcategory.dart';
import 'package:flutter/services.dart';
import '../../utils/shared_prefs_helper.dart';
import '../../backend/category/getbusinesscards/getbusinesscard.dart';
import '../../core/constant.dart';
import 'cancelrow.dart';


class SingleRequest extends StatefulWidget {
  final String id;
  final String childCatid;
  final int initialQuantity;

  const SingleRequest({
    Key? key,
    required this.id,
    required this.childCatid,
    this.initialQuantity = 0,
  }) : super(key: key);

  @override
  State<SingleRequest> createState() => _SingleRequestState();
}

class _SingleRequestState extends State<SingleRequest> {
  int quantity = 0;
  final MapController _mapController = MapController();
  Position? _currentPosition;
  String _locationText1 = 'Fetching location...';
  String _locationText2 = '';
  String _locationText3 = '';
  int _selectedIndex = 0;
  int _selectedServiceIndex = 0;
  bool _isToggleRight = false;
  // late Future<List<GetBusinessCardModel>> _businesscard;
  List<CategoryModel> _childcategory = [];
  bool _isLoading = true;
  final GlobalKey<FloatingRequestCardState> _floatingCardKey =
  GlobalKey<FloatingRequestCardState>();
  OverlayEntry? _floatingEntry;
  LatLng? _selectedLatLng;
  String? _selectedFilter;
  final getusercontroller = Get.put(GetUser());
  final requestService = Get.put(RequestService());
  final insertquery = Get.put(InsertQuery());
  final getNearVendor = Get.put(GetNearVendor());
  final updatebusinesscard = Get.put(UpdateBusinessCard());
  double minRange = 0.0;
  double maxRange = 50.0;
  String currentRadius = "10";
  String currentWork = "Milkman";
  String currentType = "Cowmilk";
  String currentVendorType = "Wholeseller";
  String? _rid = "20";
  Timer? _debounceTimer;
  final _business = Get.put(GetBusinessCardController());

  // String getRid() {
  //   if (_rid == null) {
  //     _rid = "20";
  //     debugPrint("Generated new RID: $_rid");
  //   }
  //   return _rid!;
  // }

  // void regenerateRid() {
  //   final random = Random();
  //   _rid = (10 + random.nextInt(90)).toString();
  //   debugPrint("RID regenerated: $_rid");
  // }

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
    _getCurrentLocation().then((_) => _fetchNearVendors());
    _fetchChildCategory();
    _loadUser();

    // default filter at start
    _selectedFilter = "All";
    _fetchBusinessCards(
      subcategoryId: widget.id,
      vendorType: _selectedFilter ?? "All",
    );

    minRange = 00.0;
    maxRange = 50.0;
  }

  Future<void> _fetchNearVendors() async {
    // Use current position if available, else selected city coords, else skip
    if (_currentPosition == null && _selectedLatLng == null) {
      debugPrint('⚠️ No location available for fetching vendors');
      return;
    }

    final double lat = _currentPosition?.latitude ?? _selectedLatLng!.latitude;
    final double lng = _currentPosition?.longitude ?? _selectedLatLng!.longitude;

    await getNearVendor.fetchNearVendors(
      token: 'wvnwivnoweifnqinqfinefnq',  // Keep hardcoded or make dynamic if you have user token
      lat: lat.toString(),
      log: lng.toString(),
      radius: currentRadius,
      work: currentWork,  // Dynamic from category
      type: currentType,  // Dynamic from category
      vendorType: currentVendorType,  // Dynamic from filter
    );

    if (mounted) {
      setState(() {});  // Rebuild to show new markers on map
      // Optional: Animate map to fit vendors (add later in Step 5)
    }
  }

  Future<void> _fetchBusinessCards({required String subcategoryId, required String vendorType,}) async {
    try {
      // Optional: Show loading
      _business.hasInitialData.value = false;
      _business.cards.clear();

      // Fetch from API via controller
      await _business.getBusinessCardStream(
        subcategoryId: subcategoryId,
        vendorType: vendorType,
      );

      // Update UI
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error fetching business cards: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load cards')),
        );
      }
    }
  }

  Future<void> _loadUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    if (!mounted) return;
    if (phone != null) {
      await getusercontroller.getuserdetails(
        token: 'wvnwivnoweifnqinqfinefnq',
        phone: phone,
      );
    } else {
      debugPrint('⚠️ No phone number found in SharedPreferences');
    }
  }

  void _increase() {
    setState(() => quantity++);
  }

  void _decrease() {
    setState(() {
      if (quantity > 0) quantity--;
    });
  }

  Future<Map<String, dynamic>?> _showCitySelector(BuildContext context) {
    final Map<String, LatLng> cityCoordinates = {
      'Delhi': LatLng(28.7041, 77.1025),
      'Mumbai': LatLng(19.0760, 72.8777),
      'Bangalore': LatLng(12.9716, 77.5946),
      'Kolkata': LatLng(22.5726, 88.3639),
      'Chennai': LatLng(13.0827, 80.2707),
      'Hyderabad': LatLng(17.3850, 78.4867),
      'Jaipur': LatLng(26.9124, 75.7873),
      'Lucknow': LatLng(26.8467, 80.9462),
      'Pune': LatLng(18.5204, 73.8567),
      'Goa': LatLng(15.2993, 74.1240),
    };

    RangeValues _selectedRange = RangeValues(minRange, maxRange);
    final TextEditingController _customLocationController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 420,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select City & Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        itemCount: cityCoordinates.keys.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final city = cityCoordinates.keys.elementAt(index);
                          return ListTile(
                            title: Text(city),
                            onTap: () {
                              Navigator.pop(context, {
                                'city': city,
                                'customLocation': null,
                                'range': _selectedRange,
                                'coords': cityCoordinates[city],
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // TextField(
                    //   controller: _customLocationController,
                    //   decoration: InputDecoration(
                    //     hintText: 'Enter custom location',
                    //     prefixIcon: const Icon(Icons.location_on_outlined),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //       horizontal: 12,
                    //       vertical: 12,
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select Range',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    RangeSlider(
                      values: _selectedRange,
                      min: 0,
                      max: 100,
                      divisions: 20,
                      labels: RangeLabels(
                        '${_selectedRange.start.round()} km',
                        '${_selectedRange.end.round()} km',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _selectedRange = values;
                        });

                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                          currentRadius = values.start.round().toString();
                          _fetchNearVendors(); // API is called with new radius
                        });
                      },
                    ),
                    Text(
                      'Range: ${_selectedRange.start.round()} - ${_selectedRange.end.round()} km',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            'city': null,
                            'customLocation': _customLocationController.text.isNotEmpty
                                ? _customLocationController.text
                                : null,
                            'range': _selectedRange,
                            'coords': null,
                          });
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'city': null,
                              'customLocation': _customLocationController.text.isNotEmpty
                                  ? _customLocationController.text
                                  : null,
                              'range': _selectedRange,   // still return it (optional)
                              'coords': null,
                            });
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _showFilterSelector(BuildContext context) {
    final filters = ['All', 'Retailer', 'Wholeseller', 'Reseller'];
    String? selected = _selectedFilter;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: const BoxConstraints(maxHeight: 400),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select Filter',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        IconButton(
                            icon: const Icon(Icons.close, size: 24),
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filters.length,
                        itemBuilder: (context, index) {
                          final f = filters[index];
                          final isSelected = selected == f;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = f;
                              });
                              _fetchBusinessCards(
                                subcategoryId: widget.id,
                                vendorType: f,
                              );
                              currentVendorType = f;
                              _fetchNearVendors();
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? Colors.blue : Colors.transparent,
                                      border: Border.all(
                                          color: isSelected ? Colors.blue : Colors.grey.shade400, width: 2),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    f,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected ? Colors.blue : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleRequest(BuildContext context, GetBusinessCardModel card) async {
    debugPrint("🚀 _handleRequest started");
    debugPrint(_rid);
    try {

      await _loadUser();
      debugPrint("🟢 _loadUser completed");

      if (getusercontroller.users.isEmpty) {
        debugPrint('⚠️ No user data found, cannot send request');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ User not found. Please login again.')),
        );
        return;
      }

      final user = getusercontroller.users.first;

      debugPrint("📡 Sending request...");
      final success = await requestService.registerService(
        token: 'wvnwivnoweifnqinqfinefnq',
        firstname: user.firstName,
        lastname: user.lastName,
        email: user.email,
        phoneNumber: user.phoneNumber,
        images: '',
        service: card.service,
        cardid: card.id.toString(),
        rid: _rid.toString()
      );
      debugPrint("✅ Request completed with success flag: $success");
      await UpdateBusinessCard.updateBusinessCard(
        id: card.id.toString(),
        request: "Yes",
      );

      debugPrint("💬 Message: ${requestService.message.value}");

      if (!context.mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ ${requestService.message.value}')),
        );

        // Optional short delay before navigating
        await Future.delayed(const Duration(milliseconds: 300));

        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleRequestScreen(card: card),
          ),
        );
        debugPrint("🟢 Navigation to SingleRequestScreen done");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ ${requestService.message.value}')),
        );
        debugPrint("❌ Request failed: ${requestService.message.value}");
      }
    } catch (e) {
      // Step 5: Catch unexpected errors
      debugPrint('❌ Exception in _handleRequest: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Something went wrong. Please try again.')),
      );
    }
  }

  Future<void> _handleQuery(BuildContext context, GetBusinessCardModel card) async {
    try {
      if (getusercontroller.users.isEmpty) {
        debugPrint('Warning: No user data found');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Warning: User not found. Please login again.')),
        );
        return;
      }

      final user = getusercontroller.users.first;
      debugPrint("Fetched user → Name: ${user.firstName}, Phone: ${user.phoneNumber}");

      // Current date-time
      final now = DateTime.now();
      final formattedDate =
          "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} "
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      // --------------------------------------------------------------
      // 1. Full address line (city / custom) – same as you already had
      // --------------------------------------------------------------
      final cityOrCustom = _locationText1.trim().isNotEmpty
          ? _locationText1.trim()
          : "Unknown Location";

      // --------------------------------------------------------------
      // 2. Range (min km – max km) – exactly what you show under the city
      // --------------------------------------------------------------
      final rangeText = '$_locationText2 $_locationText3';   // e.g. "5 km 30 km"

      // --------------------------------------------------------------
      // 3. Combine them into ONE clean string (or send separately)
      // --------------------------------------------------------------
      final fullAddress = '$cityOrCustom, $rangeText';

      debugPrint("Selected Location → $fullAddress");
      debugPrint("Time → $formattedDate");

      // --------------------------------------------------------------
      // API CALL – send the combined address (or split fields if you prefer)
      // --------------------------------------------------------------
      final success = await insertquery.insertquery(
        token: 'wvnwivnoweifnqinqfinefnq',
        Name: user.firstName,
        Phone: user.phoneNumber,
        Problem: card.productName,
        Datetimes: formattedDate,
        Address: fullAddress,          // <-- THIS NOW CONTAINS CITY + RANGE
      );

      if (!mounted) return;

      final msg = insertquery.message.value.isNotEmpty
          ? insertquery.message.value
          : (success ? "Query sent successfully!" : "Query failed!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? "Success: $msg" : "Error: $msg"),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('Exception in _handleQuery: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warning: Something went wrong. Please try again.')),
      );
    }
  }

  Future<void> _fetchChildCategory() async {
    final data = await GetChildCategory.getchildcategorydetails(widget.id);
    if (!mounted) return;
    setState(() {
      _childcategory = data;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _hideFloatingRequestCard();
    _debounceTimer?.cancel();
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
      builder: (context) => Positioned(
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
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _locationText1 = 'Location services disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _locationText1 = 'Location permissions denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() => _locationText1 = 'Location permissions permanently denied');
      }
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (!mounted) return;

      _currentPosition = pos;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _locationText1 = '${place.locality ?? 'Unknown'} - ${place.postalCode ?? ''}';
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
      backgroundColor: const Color(0xFF00B3A7),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildMapSection(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFF00B3A7),
                    child: _buildBusinessCardList(), // ← NOW WORKS
                  ),
                ),
              ],
            ),
            _buildBackButton(),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      color: Colors.grey[200],
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : const LatLng(28.7041, 77.1025), // default Delhi
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://maps.geoapify.com/v1/tile/osm-carto/{z}/{x}/{y}.png?apiKey={apiKey}',
                additionalOptions: const {
                  'apiKey': '2a411b50aafc4c1996eca70d594a314c',
                },
              ),
              if (_currentPosition != null && _selectedLatLng == null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      color: Colors.red.withOpacity(0.3),
                      borderStrokeWidth: 2,
                      borderColor: Colors.red,
                      radius: 150, // NOTE: flutter_map treats this as pixels
                    ),
                  ],
                ),
              if (_currentPosition != null && _selectedLatLng == null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      width: 40.0,
                      height: 40.0,
                      child: const Icon(Icons.pin_drop, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              if (_selectedLatLng != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLatLng!,
                      width: 40.0,
                      height: 40.0,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                    ),
                  ],
                ),
              // Markers for near vendors
              MarkerLayer(
                markers: _buildVendorMarkers(getNearVendor.vendors.value),
              ),
            ],
          ),
          _buildLocationInfoBar(),
        ],
      ),
    );
  }

  Widget _buildLocationInfoBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        decoration: const BoxDecoration(
          color: Color(0xFF00B3A7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final result = await _showCitySelector(context);
                  if (result != null) {
                    setState(() {
                      _locationText1 = result ['city'] ??
                          result['customLocation'] ??
                          _locationText1;

                      final range = result['range'] as RangeValues;
                      _locationText2 = '${range.start.round()} km';
                      _locationText3 = '${range.end.round()} km';

                      _selectedLatLng = result['coords'];
                      if (_selectedLatLng != null) {
                        _mapController.move(_selectedLatLng!, 12);
                      }
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _locationText1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$_locationText2 $_locationText3',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.7),
            ),
            GestureDetector(
              onTap: () => _showFilterSelector(context), // Just opens the dialog
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedFilter ?? 'All',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Marker> _buildVendorMarkers(
      List<GetNearVendorModel> vendors, {
        double markerSize = 70.0,
        double imageRadius = 28.0,
        Color? borderColor,
        Color? labelBgColor,
        Color? labelTextColor,
        Color? shadowColor,
        String? fallbackImage, // Provide a local asset or blank image for missing URLs
      }) {
    borderColor ??= Colors.white;
    labelBgColor ??= Colors.white;
    labelTextColor ??= Colors.black87;
    shadowColor ??= Colors.black26;
    fallbackImage ??= 'assets/placeholder.png'; // Ensure this exists in assets!

    return vendors.map((vendor) {
      final double? vlat = double.tryParse(vendor.lat);
      final double? vlog = double.tryParse(vendor.log);
      if (vlat == null || vlog == null) return null;

      final String imageUrl = vendor.vendorImg;

      return Marker(
        point: LatLng(vlat, vlog),
        width: markerSize,
        height: markerSize + 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade50,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.cyan, width: 3),
              ),
              child: CircleAvatar(
                radius: imageRadius,
                backgroundImage: imageUrl.startsWith('http')
                    ? NetworkImage(imageUrl)
                    : AssetImage(imageUrl) as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: labelBgColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                vendor.vendorName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: labelTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).whereType<Marker>().toList();
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
                  color: Colors.white,
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

  Widget _buildBusinessCardList() {
    return StreamBuilder<List<GetBusinessCardModel>>(
      stream: _business.getBusinessCardStream(
        subcategoryId: widget.id,
        vendorType: _selectedFilter ?? "",
      ),
      builder: (context, snapshot) {
        // ⏳ Still waiting for data -> show progress
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_business.hasInitialData.value) {
          return emptyVendorProgress();
        }

        // 🌀 While refreshing / updating but no data yet
        if (snapshot.hasData && snapshot.data!.isEmpty &&
            !_business.hasInitialData.value) {
          return emptyVendorProgress();
        }

        // ❌ After data fetched but empty list
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            color: const Color(0xFF00B3A7),
            height: MediaQuery.of(context).size.height * 0.8,
            alignment: Alignment.center,
            child: const Text(
              'No vendor found',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        // ✅ Show vendor cards
        final businessCards = snapshot.data!;
        return Container(
          color: const Color(0xFF00B3A7),
          padding: const EdgeInsets.only(bottom: 100),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: businessCards.length,
            itemBuilder: (context, i) =>
                _buildBusinessCard(context, businessCards[i]),
          ),
        );
      },
    );
  }

  Widget _buildBusinessCard(BuildContext context, GetBusinessCardModel card) {
    final bool isRequested = card.request == "Yes";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF8FFFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    Hero(
                      tag: 'card_${card.id}',
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.teal.shade100, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            card.fullImageUrl.isNotEmpty
                                ? card.fullImageUrl
                                : 'https://via.placeholder.com/72',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/icons/business_card_placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // PRODUCT NAME + PRICE + RATING + CART
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.productName,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '₹${card.price}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(width: 6),
                              _buildRatingStars(
                                  double.tryParse(card.rating) ?? 0),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.add_shopping_cart,
                                  size: 16,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (!isRequested)
                  DualSliderButton(
                    onEnquiry: () => _handleQuery(context, card),
                    onRequest: () => _handleRequest(context, card),
                  )
                else
                  _buildRequestSentRow(context, card),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestSentRow(BuildContext context, GetBusinessCardModel card) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SingleRequestScreen(card: card),
                ),
              );
            },
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade300, width: 1),
              ),
              child: const Center(
                child: Text(
                  "Request Sent",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 34,
          child: CancelButton(card: card),
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 14,
          color: Colors.orange.shade600,
        );
      }),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
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

  Widget emptyshortcircullar() {
    final double iconSize = 32;
    final double labelHeight = 5;
    final double spacing = 6;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(
          5, // Show 5 placeholders (adjust as needed)
              (_) => Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular Icon Placeholder
                _shimmershortBox(
                  height: iconSize,
                  width: iconSize,
                  borderRadius: iconSize / 2,
                ),
                SizedBox(height: spacing),
                // Label Placeholder
                _shimmershortBox(
                  height: labelHeight,
                  width: 50,
                  borderRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmershortBox({
    required double height,
    required double width,
    required double borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _isLoading
                          ? emptyshortcircullar()
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _childcategory.map((item) {
                            final int currentIndex = _childcategory
                                .indexWhere((e) => e.id == item.id) +
                                1;

                            return Row(
                              children: [
                                Semantics(
                                  label: item.categoryName,
                                  child: _buildBottomNavIcon(
                                    iconPath: item.categoryImg,
                                    label: item.categoryName,
                                    index: currentIndex,
                                    childId: item.id.toString(), // ADD THIS LINE
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
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavIcon({
    Key? key,
    required String iconPath,
    required String label,
    required int index,
    required String childId, // ADD THIS: child category ID
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final Color borderColor = (_selectedIndex == index)
        ? const Color(0xFF1E88E5)
        : Colors.grey.shade300;

    final bool isNetworkImage = iconPath.startsWith('http');

    return Semantics(
      label: label,
      button: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          key: key,
          onTap: () {
            // UPDATE UI
            setState(() {
              _selectedIndex = index;
            });

            // FETCH NEW CARDS
            _fetchBusinessCards(
              subcategoryId: childId,
              vendorType: _selectedFilter ?? "All",
            );
          },
          borderRadius: BorderRadius.circular(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isTablet ? 56 : 40,
                height: isTablet ? 56 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: _selectedIndex == index ? 2 : 1,
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
                          color: Color(0xFF1E88E5),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          width: 28,
                          height: 28,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
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
              const SizedBox(height: 3),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 12 : screenWidth * 0.028,
                  fontWeight: FontWeight.w500,
                  color: _selectedIndex == index
                      ? const Color(0xFF1E88E5)
                      : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(String imagePath, String label, int index) {
    final bool isSelected = _selectedServiceIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedServiceIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : const Color(0xFF00B3A7),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class DualSliderButton extends StatefulWidget {
  final VoidCallback onEnquiry;
  final VoidCallback onRequest;

  const DualSliderButton({
    Key? key,
    required this.onEnquiry,
    required this.onRequest,
  }) : super(key: key);

  @override
  State<DualSliderButton> createState() => _DualSliderButtonState();
}

class _DualSliderButtonState extends State<DualSliderButton>
    with SingleTickerProviderStateMixin {
  double _position = 0;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _iconAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _labelOpacityAnimationLeft;
  late Animation<double> _labelOpacityAnimationRight;
  late Animation<double> _positionAnimation;
  bool _isDoneIcon = false;
  String? _successMessage;
  bool _isResetting = false;
  double? _startPosition;
  double? _targetPosition;

  @override
  void initState() {
    super.initState();

    // Initialize knob position after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.of(context).size.width * 0.8;
      const circleSize = 36.0;
      setState(() {
        _position = (width - circleSize) / 2;
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // FIX: Colors.grey[350] can be null. Use shade300 to guarantee a Color.
    _colorAnimation = ColorTween(
      begin: Colors.grey.shade300,
      end: const Color(0xFF00B3A7),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));

    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _labelOpacityAnimationLeft = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _labelOpacityAnimationRight = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _positionAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    const height = 35.0;
    const circleSize = 30.0;
    final centerPosition = (width - circleSize) / 2;
    final minLimit = width * 0.02;
    final maxLimit = width * 0.97 - circleSize;

    final double effectivePosition = _isResetting
        ? _startPosition! + (_targetPosition! - _startPosition!) * _positionAnimation.value
        : _position;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bgColor = _colorAnimation.value ?? Colors.grey.shade300;
        return Container(
          width: width,
          height: height,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF00B3A7).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            gradient: LinearGradient(
              colors: [bgColor.withOpacity(0.85), bgColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1 - _textFadeAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: AnimatedOpacity(
                        opacity: _position < centerPosition
                            ? _labelOpacityAnimationLeft.value
                            : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          'Enquiry | send',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28),
                      child: AnimatedOpacity(
                        opacity: _position > centerPosition
                            ? _labelOpacityAnimationRight.value
                            : 0.5,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          'Request | send',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w100,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_successMessage != null)
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Center(
                    child: Text(
                      _successMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  ),
              Positioned(
                left: effectivePosition,
                child: GestureDetector(
                  onHorizontalDragStart: (_) => HapticFeedback.lightImpact(),
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _position += details.delta.dx;
                      _position = _position.clamp(minLimit, maxLimit);
                      final progress =
                          ((_position - minLimit) / (maxLimit - minLimit) - 0.5).abs() * 2;
                      _controller.value = progress.clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragEnd: (_) async {
                    _targetPosition = centerPosition;
                    if (_position <= minLimit + 12) {
                      // Slide left → Enquiry
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _position = minLimit;
                        _isDoneIcon = true;
                        _successMessage = 'Enquiry sent';
                      });
                      await _controller.forward();
                      await Future.delayed(const Duration(milliseconds: 1000));
                      widget.onEnquiry();
                      setState(() {
                        _isDoneIcon = false;
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _successMessage = null;
                        _position = centerPosition;
                      });
                    } else if (_position >= maxLimit - 12) {
                      // Slide right → Request
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _position = maxLimit;
                        _isDoneIcon = true;
                        _successMessage = 'Request sent';
                      });
                      await _controller.forward();
                      await Future.delayed(const Duration(milliseconds: 1000));
                      widget.onRequest();
                      setState(() {
                        _isDoneIcon = false;
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _successMessage = null;
                        _position = centerPosition;
                      });
                    } else {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _startPosition = _position;
                        _isResetting = true;
                      });
                      await _controller.reverse();
                      setState(() {
                        _isResetting = false;
                        _position = centerPosition;
                      });
                    }
                  },
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1.2,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: const Color(0xFF00B3A7).withOpacity(0.3),
                            spreadRadius: 0.5,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) => ScaleTransition(
                          scale: animation,
                          child: FadeTransition(opacity: animation, child: child),
                        ),
                        child: Icon(
                          _isDoneIcon ? Icons.done : Icons.arrow_forward_ios,
                          key: ValueKey<bool>(_isDoneIcon),
                          size: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

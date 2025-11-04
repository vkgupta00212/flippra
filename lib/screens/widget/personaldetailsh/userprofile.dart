import 'dart:convert';
import 'dart:io';
import 'package:flippra/backend/getkyc/getkyc.dart';
import 'package:flippra/screens/widget/personaldetailsh/updateprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../backend/getkyc/insertkyc.dart';
import '../../../core/constant.dart';
import '../../../backend/getuser/getuser.dart';
import '../../../utils/shared_prefs_helper.dart';
import '../../../backend/update/update.dart';



final ImagePicker _picker = ImagePicker();

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GetUser _getuser = Get.put(GetUser());
  final UpdateUser _updateuser = Get.put(UpdateUser());
  final InsertKycController _insertKyc = Get.put(InsertKycController());
  final GetKyc _getkyc = Get.put(GetKyc());




  // ------------------- KYC images (Base64) -------------------
  String? _aadharFront;
  String? _aadharBack;
  String? _panFront;
  String? _panBack;
  String? _gst;

  // ------------------- Helpers -------------------
  bool _isAadharComplete() => _aadharFront != null && _aadharBack != null;
  bool _isPanComplete() => _panFront != null && _panBack != null;
  bool _isGstComplete() => _gst != null;
  bool _allKycComplete() =>
      _isAadharComplete() && _isPanComplete() && _isGstComplete();

  Future<void> uploaddocs(
      final String aadharFront,
      final String aadharBack,
      final String panFront,
      final String panBack,
      final String gst,
      ) async {
    try {
      print("🚀 [UploadDocs] Starting upload...");
      final phone = await SharedPrefsHelper.getPhoneNumber();

      if (phone == null || phone.isEmpty) {
        print("⚠️ [UploadDocs] Phone number not found!");
        Get.snackbar("Error", "No phone number found. Please login again.");
        return;
      }

      // Clean Base64 (remove prefix if exists)
      String clean(String? s) =>
          s?.replaceFirst(RegExp(r'^data:image/[^;]+;base64,'), '') ?? '';

      final Map<String, dynamic> body = {
        "token": "wvnwivnoweifnqinqfinefnq",
        "AadharFront": clean(aadharFront),
        "AadharBack": clean(aadharBack),
        "PencardFront": clean(panFront),
        "PencardBack": clean(panBack),
        "Gst": clean(gst),
        "Phone": phone,
      };

      print("🚀 Uploading KYC data for phone: $phone");
      print("📦 Body (truncated): ${jsonEncode(body).substring(0, 300)}...");

      await _insertKyc.insertKyc(
        token: body["token"],
        aadharFront: body["AadharFront"],
        aadharBack: body["AadharBack"],
        pancardFront: body["PencardFront"],
        pancardBack: body["PencardBack"],
        gst: body["Gst"],
        phone: body["Phone"],
      );

      if (_insertKyc.success.value) {
        print("✅ [UploadDocs] ${_insertKyc.message.value}");
        Get.snackbar("Success", _insertKyc.message.value);
      } else {
        print("⚠️ [UploadDocs] ${_insertKyc.message.value}");
        Get.snackbar("Failed", _insertKyc.message.value);
      }
    } catch (e, stack) {
      print("❌ [UploadDocs] Exception: $e");
      print(stack);
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber(); // ✅ Await here

    if (phone != null) {
      await _getuser.getuserdetails(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );
    } else {
      print("No phone number found in SharedPreferences");
    }
  }

  // ------------------- Image pick callback -------------------
  void _onImagePicked(String base64, String side, String docType) {
    setState(() {
      if (docType == 'Aadhar Card') {
        if (side == 'Front') _aadharFront = base64;
        if (side == 'Back') _aadharBack = base64;
      } else if (docType == 'PAN Card') {
        if (side == 'Front') _panFront = base64;
        if (side == 'Back') _panBack = base64;
      } else if (docType == 'GST Certificate') {
        _gst = base64;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 0,
      ),
      body: Obx(() {
        if (_getuser.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = _getuser.users;
        if (users.isEmpty) {
          return const Center(child: Text("No user data"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Profile Card ===
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: AppColors.avatarBackground,
                              child: Text(
                                users.first.firstName[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pillButtonGradientStart,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${users.first.firstName} ${users.first.lastName}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "+91 ${users.first.phoneNumber}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.pillButtonGradientStart,
                          size: 19,
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EditProfileScreen()),
                          );
                          if (result == true) {
                            await _fetchUser();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Profile updated successfully!'),
                                backgroundColor: AppColors
                                    .pillButtonGradientEnd
                                    .withOpacity(0.9),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === Contact Details ===
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Details',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.email, 'Email', users.first.email,
                        0, 3),
                    _buildDetailRow(Icons.location_city, 'City',
                        users.first.city, 1, 3),
                    _buildDetailRow(Icons.person, 'Gender',
                        users.first.gender, 2, 3),
                  ],
                ),
              ),

              // === Upload Documents ===
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Documents',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ---- AADHAR ----
                    _buildUploadRow(
                      context,
                      icon: Icons.credit_card,
                      title: 'Aadhar Card',
                      index: 0,
                      total: 3,
                      docType: 'Aadhar Card',
                      frontBase64: _aadharFront,
                      backBase64: _aadharBack,
                      onSubmitPressed: () {
                        // 🧠 Only Aadhar has data, rest are blank
                        uploaddocs(
                          _aadharFront ?? "", // aadhar front image base64
                          _aadharBack ?? "",  // aadhar back image base64
                          "",                 // pan front empty
                          "",                 // pan back empty
                          "",                 // gst empty
                        );
                      },
                    ),


                    // ---- PAN ----
                    _buildUploadRow(
                      context,
                      icon: Icons.badge,
                      title: 'PAN Card',
                      index: 1,
                      total: 3,
                      docType: 'PAN Card',
                      frontBase64: _panFront,
                      backBase64: _panBack,
                        onSubmitPressed: () {
                          // 🧠 Only Aadhar has data, rest are blank
                          uploaddocs(
                            "", // aadhar front image base64
                            "",  // aadhar back image base64
                            _panFront ??"",                 // pan front empty
                            _panBack ?? "",                 // pan back empty
                            "",                 // gst empty
                          );
                        }
                    ),

                    // ---- GST ----
                    _buildUploadRow(
                      context,
                      icon: Icons.receipt_long,
                      title: 'GST Certificate',
                      index: 2,
                      total: 3,
                      docType: 'GST Certificate',
                      singleBase64: _gst,
                      onSubmitPressed: () {
                        // 🧠 Only Aadhar has data, rest are blank
                        uploaddocs(
                          "", // aadhar front image base64
                          "",  // aadhar back image base64
                          "",                 // pan front empty
                          "",                 // pan back empty
                          _gst ?? "",                 // gst empty
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, int index, int total) {
    BorderRadius radius;
    if (index == 0) {
      radius = const BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12));
    } else if (index == total - 1) {
      radius = const BorderRadius.only(
          bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12));
    } else {
      radius = BorderRadius.zero;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.containerBackground,
          borderRadius: radius,
          gradient: LinearGradient(
            colors: [AppColors.footerGradientEnd, AppColors.pillButtonGradientStart],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
                color: AppColors.cardShadowColor,
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
          border: Border.all(color: AppColors.iconGradientStart, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              child: Icon(icon,
                  color: AppColors.pillButtonGradientStart, size: 25),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadRow(
      BuildContext context, {
        required IconData icon,
        required String title,
        required int index,
        required int total,
        required String docType,
        String? frontBase64,
        String? backBase64,
        String? singleBase64,
        required VoidCallback onSubmitPressed,   // ← you will pass your own function here
      }) {
    // ---------- radius ----------
    BorderRadius radius;
    if (index == 0) {
      radius = const BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16));
    } else if (index == total - 1) {
      radius = const BorderRadius.only(
          bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16));
    } else {
      radius = BorderRadius.zero;
    }

    // ---------- status ----------
    String status = 'Tap to upload';
    if (docType == 'GST Certificate') {
      status = singleBase64 == null ? 'Tap to upload' : 'Uploaded';
    } else {
      final front = frontBase64 != null;
      final back  = backBase64 != null;
      if (front && back) {
        status = 'Both sides uploaded';
      } else if (front) {
        status = 'Front uploaded – add back';
      } else if (back) {
        status = 'Back uploaded – add front';
      }
    }

    // ---------- per-side state ----------
    final bool frontDone = frontBase64 != null;
    final bool backDone  = backBase64  != null;
    final bool gstDone   = singleBase64 != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DocumentUploadScreen(
                documentType: title,
                docType: docType,
                onImagePicked: (base64, side) =>
                    _onImagePicked(base64, side, docType),
                frontBase64: frontBase64,
                backBase64: backBase64,
                singleBase64: singleBase64,
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.containerBackground,
            borderRadius: radius,
            gradient: LinearGradient(
              colors: [
                AppColors.footerGradientEnd.withOpacity(0.8),
                AppColors.pillButtonGradientStart.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
                color: AppColors.iconGradientStart.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                  color: AppColors.cardShadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              // ----- Header row (icon + title + arrow) -----
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon,
                        color: AppColors.pillButtonGradientStart, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText),
                        ),
                        Text(
                          status,
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: AppColors.pillButtonGradientStart),
                ],
              ),
              const SizedBox(height: 8),

              // ----- PREVIEW -----
              if (docType == 'GST Certificate' && singleBase64 != null)
                _previewImage(singleBase64, 'GST')
              else if (docType != 'GST Certificate') ...[
                if (frontBase64 != null) _previewImage(frontBase64, 'Front'),
                if (backBase64  != null) _previewImage(backBase64,  'Back'),
              ],

              const SizedBox(height: 14),

              // ----- ACTION ROW (upload buttons + Submit) -----
              if (docType != 'GST Certificate') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Front button
                    _sideUploadButton(
                      label: 'Front',
                      isDone: frontDone,
                      onTap: () async {
                        final picked = await _pickSingleSide(
                            context, docType, 'Front');
                        if (picked != null) {
                          _onImagePicked(picked, 'Front', docType);
                        }
                      },
                    ),
                    // Back button
                    _sideUploadButton(
                      label: 'Back',
                      isDone: backDone,
                      onTap: () async {
                        final picked = await _pickSingleSide(
                            context, docType, 'Back');
                        if (picked != null) {
                          _onImagePicked(picked, 'Back', docType);
                        }
                      },
                    ),
                    // Submit button (your function)
                    _submitButton(onSubmitPressed),
                  ],
                ),
              ] else ...[
                // GST – single upload + submit
                Row(
                  children: [
                    _sideUploadButton(
                      label: 'Upload',
                      isDone: gstDone,
                      onTap: () async {
                        final picked = await _pickSingleSide(
                            context, docType, '');
                        if (picked != null) {
                          _onImagePicked(picked, '', docType);
                        }
                      },
                    ),
                    const Spacer(),
                    _submitButton(onSubmitPressed),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

// ---------- Small upload button (unchanged) ----------
  Widget _sideUploadButton({
    required String label,
    required bool isDone,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDone ? Colors.green.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDone ? Colors.green : AppColors.pillButtonGradientStart,
              width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.cloud_upload,
              size: 18,
              color: isDone ? Colors.green : AppColors.pillButtonGradientStart,
            ),
            const SizedBox(width: 4),
            Text(
              isDone ? '$label Done' : label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDone ? Colors.green : AppColors.pillButtonGradientStart,
              ),
            ),
          ],
        ),
      ),
    );
  }

// ---------- Submit button (your function) ----------
  Widget _submitButton(VoidCallback onPressed) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,          // ← you will fill this later
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.pillButtonGradientStart,
                AppColors.pillButtonGradientEnd
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Submit',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

// ---------- Pick ONE side (front / back / gst) ----------
  Future<String?> _pickSingleSide(BuildContext context, String docType, String side) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(_, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(_, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return null;

    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (file == null) {
        print("⚠️ No file picked.");
        return null;
      }

      print("📸 Picked file path: ${file.path}");

      final bytes = await File(file.path).readAsBytes();
      final base64String = base64Encode(bytes);
      print("✅ Converted image (${bytes.lengthInBytes} bytes) to base64 string of length: ${base64String.length}");

      // Return without data:image/jpeg prefix (most APIs prefer raw base64)
      return base64String;
    } catch (e, stack) {
      print("❌ Error while picking/encoding image: $e");
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to pick or encode image'),
          backgroundColor: Colors.red.withOpacity(.9),
        ),
      );
      return null;
    }
  }

  Widget _previewImage(String base64, String label) {
    final bytes = base64Decode(base64.split(',').last);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 12)),
          SizedBox(
            width: 40,
            height: 40,
            child: Image.memory(bytes, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  //  SUBMIT BUTTON
  // ---------------------------------------------------------------
  // Widget _buildSubmitButton() {
  //   final bool canSubmit = _allKycComplete();
  //
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 12),
  //     child: SizedBox(
  //       height: 56,
  //       width: double.infinity,
  //       child: ElevatedButton(
  //         onPressed: canSubmit ? _submitKycToServer : null,
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.transparent,
  //           elevation: 0,
  //           shadowColor: Colors.transparent,
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
  //         ),
  //         child: Ink(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: canSubmit
  //                   ? [AppColors.pillButtonGradientStart, AppColors.pillButtonGradientEnd]
  //                   : [Colors.grey.shade400, Colors.grey.shade500],
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //             ),
  //             borderRadius: BorderRadius.circular(28),
  //           ),
  //           child: Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               canSubmit ? 'Submit KYC' : 'Complete All Documents First',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// ---------------------------------------------------------------
//  DocumentUploadScreen – picks image, encodes, calls back
// ---------------------------------------------------------------
class DocumentUploadScreen extends StatelessWidget {
  final String documentType;
  final String docType;
  final Function(String base64, String side) onImagePicked;
  final String? frontBase64;
  final String? backBase64;
  final String? singleBase64;

  const DocumentUploadScreen({
    Key? key,
    required this.documentType,
    required this.docType,
    required this.onImagePicked,
    this.frontBase64,
    this.backBase64,
    this.singleBase64,
  }) : super(key: key);

  // -------------------------------------------------------------
  //  Encode file → Base64 (data:image/jpeg;base64,...)
  // -------------------------------------------------------------
  Future<String> _encodeToBase64(XFile file) async {
    final bytes = await file.readAsBytes();
    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  }

  // -------------------------------------------------------------
  //  Bottom sheet – source + side selection
  // -------------------------------------------------------------
  Future<void> _showPicker(BuildContext ctx) async {
    final needSide = docType == 'Aadhar Card' || docType == 'PAN Card';

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: ctx,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(_, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(_, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(_),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    String side = '';
    if (needSide) {
      side = await showDialog<String>(
        context: ctx,
        builder: (_) => SimpleDialog(
          title: const Text('Select side'),
          children: ['Front', 'Back']
              .map((s) => SimpleDialogOption(
            onPressed: () => Navigator.pop(_, s),
            child: Text(s),
          ))
              .toList(),
        ),
      ) ??
          '';
      if (side.isEmpty) return;
    }

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)),
            const SizedBox(width: 16),
            Text('Opening $documentType...'),
          ],
        ),
        backgroundColor:
        AppColors.pillButtonGradientEnd.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (file != null) {
        final base64 = await _encodeToBase64(file);
        onImagePicked(base64, side);
        ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('$documentType $side uploaded!'),
            backgroundColor: Colors.green.withOpacity(.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
        if (ctx.mounted) Navigator.pop(ctx);
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: const Text(
              'Failed to open camera/gallery. Allow permissions in Settings.'),
          backgroundColor: Colors.red.withOpacity(.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'Open Settings',
            textColor: Colors.white,
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$documentType Upload',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file,
                size: 50, color: AppColors.pillButtonGradientStart),
            const SizedBox(height: 18),
            Text('Upload $documentType',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText)),
            const SizedBox(height: 8),
            Text('Tap below to select from gallery or take a photo',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.secondaryText),
                textAlign: TextAlign.center),
            const SizedBox(height: 25),
            _buildUploadButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showPicker(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.pillButtonGradientStart,
                  AppColors.pillButtonGradientEnd
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text('Upload $documentType',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
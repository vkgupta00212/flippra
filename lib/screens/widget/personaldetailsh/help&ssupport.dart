import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/getforms/getforms.dart';
import '../../../core/constant.dart';
import '../../../utils/shared_prefs_helper.dart';

class HelpDetailsScreen  extends StatefulWidget {
  const HelpDetailsScreen ({Key? key}) : super(key: key);

  @override
  State<HelpDetailsScreen > createState() => _HelpDetailsScreenState();
}

class _HelpDetailsScreenState extends State<HelpDetailsScreen > {
  final GetForms _getForms = Get.put(GetForms());

  Future<void> _fetchForms() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    print("📱 Phone from SharedPrefs: $phone");
    if (phone != null) {
      await _getForms.getforms(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );
      print("🏦 Number of banks fetched: ${_getForms.forms.length}");
      for (var forms in _getForms.forms) {
        print("id: ${forms.id}");
        print(" forms type: ${forms.FormType}");
        print("form description: ${forms.FormDescription}");
      }
    } else {
      print("⚠️ No phone number found in SharedPreferences");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No phone number found. Please log in again.",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank Account Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 0,
        centerTitle: false,
      ),
      body: Obx(() {
        if (_getForms.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBackground),
            ),
          );
        }
        if (_getForms.forms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "No details found.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchForms,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBackground,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    "Retry",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        final forms = _getForms.forms.first;
        final details = [
          {"label": "id", "value": forms.id, "icon": Icons.person},
          {"label": "Form type", "value": forms.FormType, "icon": Icons.account_balance},
          {"label": "From Descrition", "value": forms.FormDescription, "icon": Icons.credit_card},
        ];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.length,
              itemBuilder: (context, index) {
                final item = details[index];
                return _buildDetailRow(
                  item["label"] as String,
                  item["value"] as String,
                  item["icon"] as IconData,
                  index,
                  details.length,
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, int index, int total) {
    BorderRadius radius;
    if (index == 0) {
      radius = const BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16),
      );
    } else if (index == total - 1) {
      radius = const BorderRadius.only(
        bottomRight: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      );
    } else {
      radius = BorderRadius.zero;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              color: AppColors.iconGradientStart.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryText,
                size: 24,
                semanticLabel: label,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

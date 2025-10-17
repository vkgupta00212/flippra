import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/getbank/getbankdetailsh.dart';
import '../../../core/constant.dart';
import '../../../utils/shared_prefs_helper.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final GetBankController _getbank = Get.put(GetBankController());

  Future<void> _fetchBankDetails() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    print("📱 Phone from SharedPrefs: $phone");
    if (phone != null) {
      await _getbank.getBankDetails(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );
      print("🏦 Number of banks fetched: ${_getbank.banks.length}");
      for (var bank in _getbank.banks) {
        print("🏦 Account Holder: ${bank.accountHolder}");
        print("🏦 Bank Name: ${bank.bankName}");
        print("🏦 Account Number: ${bank.accountNumber}");
        print("🏦 IFSC: ${bank.ifsc}");
        print("🏦 Branch: ${bank.branch}");
        print("🏦 Phone: ${bank.phone}");
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
    _fetchBankDetails();
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
        if (_getbank.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBackground),
            ),
          );
        }
        if (_getbank.banks.isEmpty) {
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
                  "No bank details found.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchBankDetails,
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
        final bank = _getbank.banks.first;
        final details = [
          {"label": "Account Holder", "value": bank.accountHolder, "icon": Icons.person},
          {"label": "Bank Name", "value": bank.bankName, "icon": Icons.account_balance},
          {"label": "Account Number", "value": bank.accountNumber, "icon": Icons.credit_card},
          {"label": "IFSC Code", "value": bank.ifsc, "icon": Icons.code},
          {"label": "Branch", "value": bank.branch, "icon": Icons.location_on},
          {"label": "Phone", "value": bank.phone, "icon": Icons.phone},
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

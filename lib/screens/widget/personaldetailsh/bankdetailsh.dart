import 'package:flippra/screens/widget/personaldetailsh/updatebankdetailsh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/getbank/getbankdetailsh.dart';
import '../../../backend/getbank/insertbankdetailsh.dart';
import '../../../core/constant.dart';
import '../../../utils/shared_prefs_helper.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final GetBankController _bankController = Get.put(GetBankController());
  final InsertBankController _insertBankController = Get.put(InsertBankController());

  String? _phone;
  final String _token = "wvnwivnoweifnqinqfinefnq"; // Replace with real token later

  @override
  void initState() {
    super.initState();
    _loadAndFetch();
  }

  /// Load phone & fetch bank details
  Future<void> _loadAndFetch() async {
    // Reset state
    _bankController.isLoading.value = true;
    _bankController.errorMessage.value = '';
    _bankController.banks.clear();

    _phone = await SharedPrefsHelper.getPhoneNumber();

    // If phone is missing, we'll still allow form (phone field non-editable)
    if (_phone == null || _phone!.isEmpty) {
      _bankController.isLoading.value = false;
      return;
    }

    // Fetch bank details
    final success = await _bankController.getBankDetails(token: _token, phone: _phone!);

    if (!success && _bankController.errorMessage.value.isEmpty) {
      _bankController.errorMessage.value = "Failed to load bank details. Please try again.";
    }

    _bankController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pillButtonGradientStart,
        elevation: 1,
        shadowColor: AppColors.shadowColor,
        title: Row(
          children: [
            Text(
              "Bank Details",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryText,
              ),
            ),
            const Spacer(),
            Obx(() {
              final hasBank = _bankController.banks.isNotEmpty;
              return hasBank
                  ? SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, size: 18,color: Colors.black,),
                  label: Text(
                    "Edit",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final bank = _bankController.banks.first;
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditBankDetailsScreen(bank: bank),
                      ),
                    );

                    if (result == true) {
                      await _loadAndFetch();
                      _showSnack(context, "Bank details updated successfully!", Colors.green);
                    }
                  },
                ),
              )
                  : const SizedBox();
            }),
          ],
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: Obx(() {
        // Loading State
        if (_bankController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Real Error State (Network, API fail, etc.)
        if (_bankController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  _bankController.errorMessage.value,
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadAndFetch,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pillButtonGradientStart,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        // No error → decide based on bank existence
        final hasBank = _bankController.banks.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.containerBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.containerShadowColor,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: hasBank
                ? _buildBankDetailsView(_bankController.banks.first)
                : _buildInsertBankForm(),
          ),
        );
      }),
    );
  }

  /// ================= BANK DETAILS VIEW =================
  Widget _buildBankDetailsView(BankModel bank) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow("Account Holder", bank.accountHolder),
        const SizedBox(height: 16),
        _buildDetailRow("Bank Name", bank.bankName),
        const SizedBox(height: 16),
        _buildDetailRow("Account Number", bank.accountNumber),
        const SizedBox(height: 16),
        _buildDetailRow("IFSC Code", bank.ifsc),
        const SizedBox(height: 16),
        _buildDetailRow("Branch", bank.branch),
        const SizedBox(height: 16),
        _buildDetailRow("Phone", bank.phone),
      ],
    );
  }

  /// ================= INSERT FORM =================
  Widget _buildInsertBankForm() {
    final formKey = GlobalKey<FormState>();
    final accountNumberCtrl = TextEditingController();
    final ifscCtrl = TextEditingController();
    final branchCtrl = TextEditingController();
    final holderCtrl = TextEditingController();
    final bankNameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    return Form(
      key: formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: holderCtrl,
            label: "Account Holder Name",
            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: bankNameCtrl,
            label: "Bank Name",
            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: accountNumberCtrl,
            label: "Account Number",
            keyboardType: TextInputType.number,
            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: ifscCtrl,
            label: "IFSC Code",
            validator: (v) {
              final val = v?.trim();
              if (val == null || val.isEmpty) return 'Required';
              if (val.length != 11) return 'IFSC must be 11 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: branchCtrl,
            label: "Branch",
            validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: phoneCtrl,
            label: "Phone Number",
            keyboardType: TextInputType.phone,
            enabled: true,
          ),
          const SizedBox(height: 28),

          // Submit Button
          Obx(() {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _insertBankController.isLoading.value
                    ? null
                    : () async {
                  if (!formKey.currentState!.validate()) return;

                  final phoneToUse = phoneCtrl.text.trim();
                  if (phoneToUse.isEmpty) {
                    _showSnack(context, "Phone number is required", Colors.red);
                    return;
                  }

                  await _insertBankController.insertBankDetails(
                    token: _token,
                    accountNumber: accountNumberCtrl.text.trim(),
                    ifsc: ifscCtrl.text.trim().toUpperCase(),
                    branch: branchCtrl.text.trim(),
                    accountHolder: holderCtrl.text.trim(),
                    bankName: bankNameCtrl.text.trim(),
                    phone: phoneToUse,
                  );

                  if (_insertBankController.isSuccess.value) {
                    await _loadAndFetch(); // Refresh
                    _showSnack(context, "Bank details added successfully!", Colors.green);
                  } else {
                    final msg = _insertBankController.errorMessage.value.isNotEmpty
                        ? _insertBankController.errorMessage.value
                        : "Failed to add bank details";
                    _showSnack(context, msg, Colors.red);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: AppColors.secondaryText.withOpacity(0.3),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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
                    child: _insertBankController.isLoading.value
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                        : Text(
                      "Add Bank Details",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  /// ================= REUSABLE UI HELPERS =================
  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.containerBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(color: AppColors.primaryText, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      style: GoogleFonts.poppins(color: AppColors.primaryText, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.pillButtonGradientStart, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        filled: true,
        fillColor: enabled ? AppColors.containerBackground : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
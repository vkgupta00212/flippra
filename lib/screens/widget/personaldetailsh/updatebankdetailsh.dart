import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/getbank/getbankdetailsh.dart'; // BankModel
import '../../../backend/getbank/updatebankdetailsh.dart';
import '../../../core/constant.dart';
import '../../../utils/shared_prefs_helper.dart';

class EditBankDetailsScreen extends StatefulWidget {
  final BankModel bank;

  const EditBankDetailsScreen({Key? key, required this.bank}) : super(key: key);

  @override
  State<EditBankDetailsScreen> createState() => _EditBankDetailsScreenState();
}

class _EditBankDetailsScreenState extends State<EditBankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final UpdateBankController _updateBankController = Get.put(UpdateBankController());

  late TextEditingController _accountNumberCtrl;
  late TextEditingController _ifscCtrl;
  late TextEditingController _branchCtrl;
  late TextEditingController _holderCtrl;
  late TextEditingController _bankNameCtrl;
  late TextEditingController _phoneCtrl;

  String _token = "wvnwivnoweifnqinqfinefnq"; // Replace with real token later
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _accountNumberCtrl = TextEditingController(text: widget.bank.accountNumber);
    _ifscCtrl = TextEditingController(text: widget.bank.ifsc);
    _branchCtrl = TextEditingController(text: widget.bank.branch);
    _holderCtrl = TextEditingController(text: widget.bank.accountHolder);
    _bankNameCtrl = TextEditingController(text: widget.bank.bankName);
    _phoneCtrl = TextEditingController(text: widget.bank.phone);
  }

  @override
  void dispose() {
    _accountNumberCtrl.dispose();
    _ifscCtrl.dispose();
    _branchCtrl.dispose();
    _holderCtrl.dispose();
    _bankNameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.containerBackground,
        elevation: 1,
        shadowColor: AppColors.shadowColor,
        title: Text(
          "Edit Bank Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: Obx(() {
        final isLoading = _updateBankController.isLoading.value;
        final message = _updateBankController.message.value;

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
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
              child: Column(
                children: [
                  _buildTextField(
                    controller: _accountNumberCtrl,
                    label: "Account Number",
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _ifscCtrl,
                    label: "IFSC Code",
                    validator: (v) =>
                    (v?.length ?? 0) != 11 ? '11 characters required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _branchCtrl,
                    label: "Branch",
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _holderCtrl,
                    label: "Account Holder Name",
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _bankNameCtrl,
                    label: "Bank Name",
                    validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // ✅ Non-editable phone number
                  _buildTextField(
                    controller: _phoneCtrl,
                    label: "Phone Number",
                    keyboardType: TextInputType.phone,
                    enabled: false, // 🔒 non-editable
                  ),
                  const SizedBox(height: 28),

                  // ✅ Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading || _isSubmitting ? null : _updateBankDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor:
                        AppColors.secondaryText.withOpacity(0.3),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
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
                          child: isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : Text(
                            "Save Changes",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        color: message.toLowerCase().contains("updated")
                            ? Colors.green
                            : Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _updateBankDetails() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final success = await _updateBankController.updateBankDetails(
      token: _token,
      accountNumber: _accountNumberCtrl.text.trim(),
      ifsc: _ifscCtrl.text.trim().toUpperCase(),
      branch: _branchCtrl.text.trim(),
      accountHolder: _holderCtrl.text.trim(),
      bankName: _bankNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );

    if (mounted) {
      setState(() => _isSubmitting = false);

      if (success) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bank details updated successfully!'),
            backgroundColor: Colors.green.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_updateBankController.message.value),
            backgroundColor: Colors.red.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // ✅ Reusable styled text field
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
      readOnly: !enabled,
      style: GoogleFonts.poppins(
        color: enabled ? AppColors.primaryText : Colors.grey.shade600,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: AppColors.secondaryText,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.pillButtonGradientStart,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        filled: true,
        fillColor: enabled
            ? AppColors.containerBackground
            : Colors.grey.shade100,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}

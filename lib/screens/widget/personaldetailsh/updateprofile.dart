import 'package:flippra/screens/homescreens/home/home_screen_category.dart';
import 'package:flippra/screens/widget/personaldetailsh/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/update/update.dart';
import '../../../backend/getuser/getuser.dart';
import '../../../core/constant.dart';
import '../../../utils/shared_prefs_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // GetX Controllers
  final GetUser _getUser = Get.find<GetUser>();
  final UpdateUser _updateUser = Get.find<UpdateUser>();

  // Form state
  String _selectedGender = "Male";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    if (phone == null) {
      _showSnackBar("Phone number not found. Please login again.", isError: true);
      return;
    }

    await _getUser.getuserdetails(
      token: "wvnwivnoweifnqinqfinefnq",
      phone: phone,
    );

    if (_getUser.users.isNotEmpty) {
      final user = _getUser.users.first;
      setState(() {
        _firstNameController.text = user.firstName;
        _lastNameController.text = user.lastName;
        _emailController.text = user.email;
        _mobileController.text = user.phoneNumber;
        _cityController.text = user.city;
        _selectedGender = user.gender;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_updateUser.isLoading.value) return;

    try {
      await _updateUser.updateuser(
        token: "wvnwivnoweifnqinqfinefnq",
        firstname: _firstNameController.text.trim(),
        lastname: _lastNameController.text.trim(),
        Gender: _selectedGender,
        Email: _emailController.text.trim(),
        City: _cityController.text.trim(),
        phone: _mobileController.text.trim(),
      );

      if (mounted) {
        _showSnackBar("Profile updated successfully!");
        Navigator.pop(context, true); // Return true to refresh parent
      }
    } catch (e) {
      _showSnackBar("Failed to update profile. Please try again.", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: Obx(() {
        if (_getUser.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
                  // First Name
                  _buildTextField(
                    controller: _firstNameController,
                    label: "First Name",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "First name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Last Name
                  _buildTextField(
                    controller: _lastNameController,
                    label: "Last Name",
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (!GetUtils.isEmail(value.trim())) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone (Disabled)
                  _buildTextField(
                    controller: _mobileController,
                    label: "Phone",
                    keyboardType: TextInputType.phone,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  // City
                  _buildTextField(
                    controller: _cityController,
                    label: "City",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "City is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    dropdownColor: AppColors.containerBackground,
                    style: GoogleFonts.poppins(color: AppColors.primaryText, fontSize: 16),
                    decoration: _inputDecoration("Gender"),
                    items: ["Male", "Female", "Other"]
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender, style: GoogleFonts.poppins(color: AppColors.primaryText)),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) return "Select gender";
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _updateUser.isLoading.value ? null : _saveProfile,
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
                            colors: [AppColors.pillButtonGradientStart, AppColors.pillButtonGradientEnd],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Obx(() => _updateUser.isLoading.value
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : Text(
                            "Save Profile",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // Reusable TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: GoogleFonts.poppins(color: AppColors.primaryText, fontSize: 16),
      decoration: _inputDecoration(label, enabled: enabled),
      validator: validator,
    );
  }

  // Shared Input Decoration
  InputDecoration _inputDecoration(String label, {bool enabled = true}) {
    return InputDecoration(
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
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      filled: true,
      fillColor: enabled ? AppColors.containerBackground : Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
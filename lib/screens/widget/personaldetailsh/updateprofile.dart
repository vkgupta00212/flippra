import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/update/update.dart';
import '../../../backend/getuser/getuser.dart';
import '../../../utils/shared_prefs_helper.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  final GetUser _getuser = Get.put(GetUser());
  final UpdateUser _updateuser = Get.put(UpdateUser());

  String selectedGender = "Male"; // default

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final phone = await SharedPrefsHelper.getPhoneNumber();
    if (phone != null) {
      await _getuser.getuserdetails(
        token: "wvnwivnoweifnqinqfinefnq",
        phone: phone,
      );

      // ✅ Once data is fetched, set controllers
      if (_getuser.users.isNotEmpty) {
        final user = _getuser.users.first;
        setState(() {
          _fullNameController.text =
              "${user.firstName} ${user.lastName}".trim();
          _emailController.text = user.email;
          _mobileController.text = user.phoneNumber;
          _cityController.text = user.city;
          selectedGender = user.gender;
        });
      }
    } else {
      print("⚠️ No phone number found in SharedPreferences");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile",
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),)),
      body: Obx(() {
        if (_getuser.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // ✅ Full Name
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),

                // ✅ Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),

                // ✅ Phone
                TextField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),

                // ✅ City
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),

                // ✅ Gender Dropdown
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: ["Male", "Female", "Other"]
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 25),


                ElevatedButton(
                  onPressed: () async {
                    // Split name into first & last name
                    final fullName =
                    _fullNameController.text.trim().split(" ");
                    final firstname =
                    fullName.isNotEmpty ? fullName[0] : "";
                    final lastname = fullName.length > 1
                        ? fullName.sublist(1).join(" ")
                        : "";

                    await _updateuser.updateuser(
                      token: "wvnwivnoweifnqinqfinefnq", // replace with real token
                      firstname: firstname,
                      lastname: lastname,
                      Gender: selectedGender,
                      Email: _emailController.text.trim(),
                      City: _cityController.text.trim(),
                      phone: _mobileController.text.trim(),
                    );

                    Get.snackbar(
                      "Update",
                      _updateuser.message.value,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Obx(() => _updateuser.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Save Profile")),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homeasz/models/user_model.dart';
import 'package:homeasz/providers/user_provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:homeasz/utils/constants.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // handle password visibility
  bool _isPasswordVisible = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // get user data
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final User? user = userProvider.user;
    if (user != null) {
      fullNameController.text =
          user.firstName != "" ? "${user.firstName} ${user.lastName}" : "";
      emailController.text = user.email;
      phoneNoController.text = user.phone;
      addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    fullNameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _getLocation() {
    print("Get Location");
  }

  void _updateProfile() async {
    String fullName = fullNameController.text;
    String email = emailController.text;
    String phoneNo = phoneNoController.text;
    String password = passwordController.text;
    String address = addressController.text;

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // check if any field is empty
    if (fullName.isEmpty ||
        email.isEmpty ||
        phoneNo.isEmpty ||
        password.isEmpty ||
        address.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required"),
        ),
      );
      return;
    }

    // split full name
    List<String> names = fullName.split(" ");
    String firstName = names[0];
    String lastName = names.sublist(1).join(" ");

    // get user provider
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUser(
        User(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phoneNo,
          address: address,
        ),
      );
      if (userProvider.user != null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully"),
          ),
        );
      }
    } on Exception catch (e) {
      Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update profile: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: Text("Edit Profile",
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // -- IMAGE with ICON
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: const Icon(LineAwesomeIcons.user, size: 60),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).primaryColor),
                        child: const Icon(LineAwesomeIcons.camera_solid,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // -- Form Fields
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                            label: Text(tFullName),
                            prefixIcon: Icon(LineAwesomeIcons.user)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        readOnly: true,
                        // dont outline on tap
                        controller: emailController,
                        decoration: const InputDecoration(
                            label: Text(tEmail),
                            prefixIcon: Icon(LineAwesomeIcons.envelope_open)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phoneNoController,
                        decoration: const InputDecoration(
                            label: Text(tPhoneNo),
                            prefixIcon: Icon(LineAwesomeIcons.phone_solid)),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: addressController,
                        decoration:  InputDecoration(
                          label: const Text("Address"),
                          prefixIcon: const Icon(LineAwesomeIcons.house_damage_solid),
                          suffixIcon: IconButton(
                            icon: const Icon(LineAwesomeIcons.map_marker_alt_solid),
                            onPressed: _getLocation,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: !_isPasswordVisible,
                        controller: passwordController,
                        decoration: InputDecoration(
                          label: const Text(tPassword),
                          prefixIcon: const Icon(Icons.fingerprint),
                          suffixIcon: IconButton(
                            icon: Icon(!_isPasswordVisible
                                ? LineAwesomeIcons.eye_slash
                                : LineAwesomeIcons.eye),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      // -- Form Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {_updateProfile()},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text("Update Profile",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(height: 40.0),

                      // -- Created Date and Delete Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: tJoined,
                              style: const TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                    text: tJoinedAt,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.1),
                                elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none),
                            child: const Text("Delete Account"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

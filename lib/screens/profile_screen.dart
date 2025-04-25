import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_plus/screens/login_screen.dart';
import 'package:grocery_plus/widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var auth = FirebaseAuth.instance;

  void logoutUser() {
    auth.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (c) => LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
        child: Column(
          children: [
            ProfileWidget(
                leadingIcon: Icons.logout,
                title: "Logout",
                ontap: () {
                  logoutUser();
                })
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_plus/constants/colors.dart';
import 'package:grocery_plus/screens/bottom_Nav_bar.dart';
import 'package:grocery_plus/screens/forget_password_screen.dart';
import 'package:grocery_plus/screens/signup_screen.dart';
import 'package:grocery_plus/widgets/custom_text_field.dart';
import 'package:grocery_plus/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (c) => BottomNavBar()),
            (route) => false);
      } else {
        await auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Please verify ypur email before logging in.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } on FirebaseAuthException catch (e) {
      String message = "An error occured";
      if (e.code == 'user-not-found') {
        message = "No user found with this email.";
      } else if (e.code == 'wrong password') {
        message = "incorrect password.";
      } else if (e.code == 'invalid-email') {
        message = "invalid email address.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "images/splash_image.png",
                      height: 100,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome to ",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: AppColors.fontColor,
                              )),
                          Text("Grocery Plus",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Please Login to your Account!",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.fontGrayColor,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Email",
                            prefixIcon: Icon(
                              Icons.mail,
                              color: AppColors.primaryColor,
                            ),
                            controller: emailController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            hintText: "Password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.primaryColor,
                            ),
                            controller: passwordController,
                            suffixIcon: Icon(
                              Icons.visibility_off,
                            ),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) =>
                                                ForgetPasswordScreen()));
                                  },
                                  child: Text("Forget Password?"))),
                          SizedBox(
                            height: 50,
                          ),
                          PrimaryButton(
                            title: "Next",
                            icon: Icons.arrow_forward,
                            ontap: () {
                              loginUser(emailController.text,
                                  passwordController.text);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an Account?"),
                              const SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => SignUpScreen()));
                                },
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

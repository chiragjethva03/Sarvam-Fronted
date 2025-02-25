import 'package:flutter/material.dart';
import 'signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Sarvam/screens/BottomaNvigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Sarvam/consts/App_Colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    final String backendUrl = "http://192.168.96.182:4000/login";

    if (_emailController.text.isEmpty) {
      _showSnackbar(context, "Please enter your email!");
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showSnackbar(context, "Please enter your password!");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackbar(context, "✅ Login Successful!");

        // ✅ Store JWT Token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", responseData["token"]);

        // ✅ Navigate to Home Page
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      } else {
        _showSnackbar(
            context, responseData["message"] ?? "Login failed! Try again.");
      }
    } catch (e) {
      _showSnackbar(context, "Error connecting to server! Please try again.");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Ensure a fresh login
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        // ✅ Send user details to backend to check if they exist
        final response = await http.post(
          Uri.parse("http://192.168.144.182:4000/google-login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": user.email,
            "username": user.displayName ?? "Google User",
            "profilePic": user.photoURL,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          // ✅ Store JWT Token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth_token", responseData["token"]);

          // ✅ Navigate to Home Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["message"] ?? "Login failed!")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing in with Google!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.85; // Adjust width for responsiveness
    final baseWidth = 360.0;
    final scaleFactor = screenWidth / baseWidth;

    return Scaffold(
      backgroundColor: AppColor.App_Bg_Primary,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // ✅ Background Oval Shape (Separate from Text)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 180 * scaleFactor,
                decoration: BoxDecoration(
                  color: Color(0xFFACE7C0).withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50 * scaleFactor),
                    bottomRight: Radius.circular(50 * scaleFactor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20 * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30 * scaleFactor),

                  // ✅ "Sign In" Heading (Matches Signup Page)
                  Container(
                    margin: EdgeInsets.only(left: 10 * scaleFactor),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 26 * scaleFactor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10 * scaleFactor),

                  // ✅ Subtitle (Matches Signup Page)
                  Container(
                    margin: EdgeInsets.only(left: 10 * scaleFactor),
                    child: Text(
                      "Welcome back, your next Adventure awaits!",
                      style: TextStyle(
                        fontSize: 23 * scaleFactor,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  SizedBox(height: 40 * scaleFactor),

                  // ✅ Username Field
                  Container(
                    margin: EdgeInsets.only(top: 40 * scaleFactor),
                    child: Column(
                      children: [
                        _buildTextField("Email Address", Icons.person,
                            _emailController, scaleFactor),
                        SizedBox(height: 20 * scaleFactor),
                        _buildPasswordField("Password", Icons.lock,
                            _passwordController, scaleFactor),

                        // ✅ Forgot Password (Centered)
                        Align(
                          alignment:
                              Alignment.centerRight, // ✅ Aligned to the right
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                fontSize: 16 * scaleFactor,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors
                                    .blue, // ✅ Underline color set to blue
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 5 * scaleFactor),

                        // ✅ Login Button (Matches Signup Page)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _signIn(
                                  context); // ✅ Pass context inside a function
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15 * scaleFactor),
                              backgroundColor: Colors.blue, // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(18 * scaleFactor),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 22 * scaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20 * scaleFactor),

                        // ✅ Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.black45)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10 * scaleFactor),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  fontSize: 16 * scaleFactor,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.black45)),
                          ],
                        ),
                        SizedBox(height: 20 * scaleFactor),

                        // ✅ Google Sign In Button (Matches Signup Page)
                        SizedBox(
                          height: 53 * scaleFactor,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                _signInWithGoogle, // Add Google sign-in function here
                            icon: Image.asset(
                              "assets/icons/google.png",
                              height: 27 * scaleFactor,
                              width: 27 * scaleFactor,
                            ),
                            label: Text(
                              "Continue with Google",
                              style: TextStyle(
                                fontSize: 18 * scaleFactor,
                                color: Colors.black,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Color(0xFFACE7C0)
                                      .withOpacity(0.3)), // Button color
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18 * scaleFactor),
                                ),
                              ),
                              elevation:
                                  WidgetStateProperty.all(0), // No shadow
                              overlayColor: WidgetStateProperty.all(
                                  Colors.transparent), // No hover effect
                              splashFactory:
                                  NoSplash.splashFactory, // No ripple effect
                            ),
                          ),
                        ),
                        SizedBox(height: 40 * scaleFactor),

                        // ✅ Signup Link (Matches Signup Page)
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(
                                      fontSize: 20 * scaleFactor,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      fontSize: 20 * scaleFactor,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20 * scaleFactor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Function for Username & Email Fields
  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, double scaleFactor) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54),
        floatingLabelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(icon, size: 24 * scaleFactor),
        filled: true,
        fillColor:
            Color(0xFFACE7C0).withOpacity(0.2), // ✅ Matched with Signup page
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18 * scaleFactor),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18 * scaleFactor),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18 * scaleFactor),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, IconData icon,
      TextEditingController controller, double scaleFactor) {
    bool _isPasswordVisible = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextField(
          controller: controller,
          obscureText: !_isPasswordVisible,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black54),
            floatingLabelStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(icon, size: 24 * scaleFactor),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                size: 24 * scaleFactor,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: Color(0xFFACE7C0).withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scaleFactor),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scaleFactor),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18 * scaleFactor),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:Sarvam/auth/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  bool _isPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signUp() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your username!")),
      );
      return;
    }

    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email address!")),
      );
      return;
    }

    String email = _emailController.text;
    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid Gmail address!")),
      );
      return;
    }

    if (_mobileNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your mobile number!")),
      );
      return;
    }

    // Validate mobile number length and digits
    if (!RegExp(r'^\d{10}$').hasMatch(_mobileNumberController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 10-digit mobile number!")),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your password!")),
      );
      return;
    }

    String password = _passwordController.text;
    RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character!")),
      );
      return;
    }

    final String apiUrl = "http://192.168.96.182:4000/signup";

    try {
      // Constructing the JSON payload
      final Map<String, dynamic> payload = {
        "username": _usernameController.text.trim(),
        "email": _emailController.text.trim(),
        "password": _passwordController.text,
        "mobileNumber": _mobileNumberController.text.trim()
      };

      print("Payload Sent to Backend: $payload");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"])),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print(
            "Response Error: ${response.body}"); // Debug: Print error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup failed! Try again.")),
        );
      }
    } catch (e) {
      print("Exception: $e"); // Debug: Print the exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error connecting to server!")),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Welcome, ${user.displayName}!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing in with Google!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseWidth = 360.0;
    final scaleFactor = screenWidth / baseWidth;

    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.blue.withOpacity(0.3),
        selectionHandleColor: Colors.blue,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF6FFFB),
        body: SingleChildScrollView(
          child: Stack(
            children: [
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
                    Container(
                      margin: EdgeInsets.only(left: 10 * scaleFactor),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 26 * scaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10 * scaleFactor),
                    Container(
                      margin: EdgeInsets.only(left: 10 * scaleFactor),
                      child: Text(
                        "Signup and Discover Your Next Great Adventure!",
                        style: TextStyle(
                          fontSize: 23 * scaleFactor,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 40 * scaleFactor),
                    _buildTextField("Username", Icons.person,
                        _usernameController, scaleFactor),
                    SizedBox(height: 20 * scaleFactor),
                    _buildTextField("Email Address", Icons.email,
                        _emailController, scaleFactor),
                    SizedBox(height: 20 * scaleFactor),
                    _buildMobileNumberField(scaleFactor),
                    SizedBox(height: 20 * scaleFactor),
                    _buildPasswordField("Password", Icons.lock, true,
                        _passwordController, scaleFactor),
                    SizedBox(height: 30 * scaleFactor),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 15 * scaleFactor),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18 * scaleFactor),
                          ),
                        ),
                        child: Text(
                          "Create account",
                          style: TextStyle(
                            fontSize: 22 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20 * scaleFactor),
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
                    SizedBox(
                      height: 53 * scaleFactor,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFACE7C0).withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18 * scaleFactor),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 40 * scaleFactor),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 20 * scaleFactor,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "Sign In",
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
            ],
          ),
        ),
      ),
    );
  }

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
  }

  Widget _buildMobileNumberField(double scaleFactor) {
    return Row(
      children: [
        Container(
          height: 57 * scaleFactor, // Ensures consistent height
          width: 70 * scaleFactor, // Increased width
          decoration: BoxDecoration(
            color: Color(0xFFACE7C0).withOpacity(0.2),
            borderRadius: BorderRadius.circular(18 * scaleFactor),
            border: Border.all(
                color: Colors.black.withOpacity(0.1)), // Default border color
          ),
          padding: EdgeInsets.symmetric(horizontal: 12 * scaleFactor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone, color: Colors.black, size: 20 * scaleFactor),
              SizedBox(width: 3 * scaleFactor),
              Text(
                "+91",
                style: TextStyle(
                  fontSize: 16 * scaleFactor,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10 * scaleFactor),
        Expanded(
          child: SizedBox(
            height: 60 * scaleFactor, // Ensures consistent height
            child: TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              cursorColor: Colors.black,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                hintText: "Enter mobile number",
                hintStyle: TextStyle(color: Colors.black54),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, IconData icon, bool isPassword,
      TextEditingController controller, double scaleFactor) {
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
  }
}

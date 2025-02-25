import 'package:flutter/material.dart';
import 'package:Sarvam/auth/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Sarvam/screens/BottomaNvigation.dart';
import 'package:Sarvam/consts/App_Colors.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isPasswordVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  bool otpSent = false;

  // List of OTP controllers
  List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());

  List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  List<Color> otpBorderColors = List.generate(6, (_) => Colors.grey);

// State variables
  bool isVerifying = false;
  String otpErrorMessage = "";
  bool isResending = false;
  bool showResendLoader = false; // To show/hide resend text & loader

  Future<void> _signUp() async {
    if (_usernameController.text.isEmpty) {
      _showSnackbar("Please enter your username!");
      return;
    }

    if (_emailController.text.isEmpty ||
        !RegExp(r'^[a-z0-9._%+-]+@gmail\.com$')
            .hasMatch(_emailController.text)) {
      _showSnackbar("Please enter a valid Gmail address!");
      return;
    }

    if (_mobileNumberController.text.isEmpty ||
        !RegExp(r'^\d{10}$').hasMatch(_mobileNumberController.text)) {
      _showSnackbar("Please enter a valid 10-digit mobile number!");
      return;
    }

    if (_passwordController.text.isEmpty ||
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$')
            .hasMatch(_passwordController.text)) {
      _showSnackbar(
          "Password must contain uppercase, lowercase, number, and special character!");
      return;
    }
    // Call API to send OTP
    final String otpApiUrl = "http://192.168.96.182:4000/send-otp";
    try {
      final response = await http.post(
        Uri.parse(otpApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": _emailController.text.trim()}),
      );

      if (response.statusCode == 200) {
        _showSnackbar("OTP sent to your email!");
        _showOtpBottomSheet();
      } else {
        _showSnackbar("Failed to send OTP. Try again.");
      }
    } catch (e) {
      _showSnackbar("Error connecting to server!");
    }
  }

  void _showOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Verify Your OTP",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter the 6-digit OTP sent to your email",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 20),
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 40,
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                otpBorderColors[index] =
                                    Colors.black; // Black on hover
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                otpBorderColors[index] =
                                    Colors.blue; // Change to blue after hover
                              });
                            },
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _otpFocusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: otpBorderColors[index]),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 5) {
                                    FocusScope.of(context).requestFocus(
                                        _otpFocusNodes[index + 1]);
                                  } else {
                                    _verifyOtp(
                                        _otpControllers
                                            .map((c) => c.text)
                                            .join(),
                                        setState);
                                  }
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 20),
                  isVerifying
                      ? CircularProgressIndicator()
                      : Text(
                          otpErrorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("Don't receive OTP? Click to "),
                        GestureDetector(
                          onTap: () async {
                            if (!isResending) {
                              setState(() {
                                isResending = true;
                              });

                              await _resendOtp(); // Call function to resend OTP

                              setState(() {
                                showResendLoader = true; // Show loader
                              });

                              await Future.delayed(
                                  Duration(seconds: 4)); // Wait for 4 seconds

                              setState(() {
                                showResendLoader =
                                    false; // Remove loader, show text again
                                isResending = false;
                              });

                              _showSnackbar("OTP Resent! Check your email.");
                            }
                          },
                          child: showResendLoader
                              ? Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors
                                          .blue, // Loader color set to blue
                                    ),
                                  ),
                                )
                              : Text(
                                  "Resend",
                                  style: TextStyle(
                                    color: Colors.blue, // Keep text color blue
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _resendOtp() async {
    final String resendOtpApiUrl = "http://192.168.96.182:4000/send-otp";

    try {
      final response = await http.post(
        Uri.parse(resendOtpApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": _emailController.text.trim()}),
      );

      if (response.statusCode == 200) {
        _showSnackbar("OTP Resent! Check your email.");
      } else {
        _showSnackbar("Failed to resend OTP. Try again.");
      }
    } catch (e) {
      _showSnackbar("Error connecting to server!");
    }
  }

// Updated OTP verification function
  Future<void> _verifyOtp(String otp, StateSetter setState) async {
    setState(() {
      isVerifying = true;
      otpErrorMessage = "";
    });

    final String verifyOtpApiUrl = "http://192.168.96.182:4000/verify-otp";

    try {
      final response = await http.post(
        Uri.parse(verifyOtpApiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": _emailController.text.trim(), "otp": otp}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        _sendDataToBackend();
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        setState(() {
          otpErrorMessage =
              responseData["message"] ?? "Invalid OTP! Try again.";
          _clearOtpFields(setState);
        });

        // ✅ Ensure focus request is safe to avoid crashes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_otpFocusNodes.isNotEmpty && _otpFocusNodes[0].context != null) {
            FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
          }
        });
      } else {
        setState(() {
          otpErrorMessage = "Failed to verify OTP. Try again.";
          _clearOtpFields(setState);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_otpFocusNodes.isNotEmpty && _otpFocusNodes[0].context != null) {
            FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
          }
        });
      }
    } catch (e) {
      print("❌ Network Error: $e");
      setState(() {
        otpErrorMessage =
            "Error connecting to server! Please check your internet.";
        _clearOtpFields(setState);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_otpFocusNodes.isNotEmpty && _otpFocusNodes[0].context != null) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
        }
      });
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  void _clearOtpFields(StateSetter setState) {
    setState(() {
      for (var controller in _otpControllers) {
        controller.clear();
      }
    });
  }

  Future<void> _sendDataToBackend() async {
    final String backendUrl = "http://192.168.96.182:4000/signup";

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "mobileNumber": _mobileNumberController.text.trim(),
          "password": _passwordController.text.trim()
        }),
      );

      print("🔹 Request Sent to Backend: $backendUrl");
      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackbar("✅ Signup Successful!");

        // ✅ Navigate to the login screen after successful signup
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      } else if (response.statusCode == 400) {
        // ❌ Handle duplicate email/mobile number error
        _showSnackbar(responseData["message"] ?? "Signup failed! Try again.");
      } else {
        _showSnackbar("Signup failed! Try again.");
      }
    } catch (e) {
      print("❌ Network Error: $e");
      _showSnackbar("Error connecting to server! Please try again.");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
        backgroundColor: AppColor.App_Bg_Primary,
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
                            padding: EdgeInsets.symmetric(
                                vertical: 15 * scaleFactor),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18 * scaleFactor),
                            )),
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
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Color(0xFFACE7C0).withOpacity(0.3)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18 * scaleFactor),
                            ),
                          ),
                          elevation: WidgetStateProperty.all(0), // No shadow

                          // ✅ Fully removes hover, focus, splash, and highlight effects
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          splashFactory: NoSplash.splashFactory,
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
    return SizedBox(
      width: double.infinity, // Full width input field
      height: 60 * scaleFactor, // Consistent height with other fields
      child: TextField(
        controller: _mobileNumberController,
        keyboardType: TextInputType.phone,
        cursorColor: Colors.black,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          hintText: "Enter your 10 digit mobile number",
          hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
          filled: true,
          fillColor:
              Color(0xFFACE7C0).withOpacity(0.2), // Light green background
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
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12), // Adjust padding
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone,
                    color: Colors.black54,
                    size: 20 * scaleFactor), // Phone icon
                SizedBox(width: 5 * scaleFactor), // Spacing
                Text(
                  "+91",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8 * scaleFactor), // Space before separator
                Container(
                  height: 24 * scaleFactor,
                  width: 1.5,
                  color: Colors.black38, // Thin separator
                ),
                SizedBox(width: 8 * scaleFactor), // Space after separator
              ],
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
            maxWidth: 110 * scaleFactor, // Ensures proper spacing
          ),
        ),
        style: TextStyle(fontSize: 16 * scaleFactor),
      ),
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

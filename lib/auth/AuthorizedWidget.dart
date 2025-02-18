import 'signup.dart';

Future<void> _signUp() async {
  if (_usernameController.text.isEmpty) {
    _showSnackbar("Please enter your username!");
    return;
  }

  if (_emailController.text.isEmpty ||
      !RegExp(r'^[a-z0-9._%+-]+@gmail\.com$').hasMatch(_emailController.text)) {
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
                                  FocusScope.of(context)
                                      .requestFocus(_otpFocusNodes[index + 1]);
                                } else {
                                  _verifyOtp(
                                      _otpControllers.map((c) => c.text).join(),
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
                                    color:
                                        Colors.blue, // Loader color set to blue
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

    print("🔹 Request Sent: $verifyOtpApiUrl");
    print("🔹 Response Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      Navigator.pop(context);
      _sendDataToBackend();
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      setState(() {
        otpErrorMessage = responseData["message"] ?? "Invalid OTP! Try again.";
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
  final String apiUrl = "http://192.168.96.182:4000/signup";
  final Map<String, dynamic> payload = {
    "username": _usernameController.text.trim(),
    "email": _emailController.text.trim(),
    "password": _passwordController.text,
    "mobileNumber": _mobileNumberController.text.trim()
  };
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      _showSnackbar("Signup successful!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _showSnackbar("Signup failed! Try again.");
    }
  } catch (e) {
    _showSnackbar("Error connecting to server!");
  }
}

void _showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
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

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Sarvam/splash%20screens/splash_screen_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Sarvam/consts/App_Colors.dart';

class OnbordingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnbordingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreenMain()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double fixedImageWidth = 72.0; // Fixed image width
    final double fixedImageHeight = 72.0; // Fixed image height
    final double fixedFontSize = 28.0; // Fixed font size for text

    return Scaffold(
      backgroundColor: AppColor.App_Bg_Primary,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Fixed size image
              Container(
                width: fixedImageWidth,
                height: fixedImageHeight,
                child: Image.asset(
                  "assets/Onbording/onbording.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 16.0), // Fixed spacing between image and text
              // Fixed text styling
              Text(
                "Sarvam",
                style: GoogleFonts.croissantOne(
                  fontSize: fixedFontSize,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF00AEAF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

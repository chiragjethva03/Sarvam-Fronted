import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Scale factors for consistent sizing
    final baseWidth = 360; // Assumed design width (baseline for scaling)
    final scaleFactor = screenWidth / baseWidth;

    return Scaffold(
      backgroundColor: Color(0xFFF6FFFB), // Light greenish background
      body: Stack(
        children: [
          // Top left circle
          Positioned(
            top: -50 * scaleFactor, // Scale positioning
            left: -50 * scaleFactor,
            child: Container(
              width: 180 * scaleFactor, // Scale size
              height: 180 * scaleFactor,
              decoration: BoxDecoration(
                color: Color(0xFFACE7C0).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Center right circle
          Positioned(
            top: 180 * scaleFactor, // Scale positioning
            left: screenWidth / 2 - (75 * scaleFactor) + (40 * scaleFactor),
            child: Container(
              width: 180 * scaleFactor, // Scale size
              height: 180 * scaleFactor,
              decoration: BoxDecoration(
                color: Color(0xFFACE7C0).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
            children: [
              // Spacing from top
              SizedBox(height: 200 * scaleFactor),
              // Text Section with left margin
              Container(
                margin:
                    EdgeInsets.only(left: screenWidth * 0.2), // Add left margin
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Ensure text stays left-aligned
                  children: [
                    Text(
                      "LET'S",
                      style: GoogleFonts.inter(
                        fontSize: 23 * scaleFactor, // Scale font size
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "EXPLORE",
                      style: GoogleFonts.croissantOne(
                        fontSize: 33 * scaleFactor, // Scale font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "THE WORLD",
                      style: GoogleFonts.inter(
                        fontSize: 23 * scaleFactor, // Scale font size
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Image Section
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 70 * scaleFactor),
                  child: Image.asset(
                    'assets/SplashScreen/placeholder.png',
                    width: 300 * scaleFactor, // Scale width
                    height: 300 * scaleFactor, // Scale height
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

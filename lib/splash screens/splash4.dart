import 'package:flutter/material.dart';
import 'package:Sarvam/auth/signup.dart'; // Correct home screen path
import 'package:google_fonts/google_fonts.dart';

class SplashScreen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Base width for scaling
    final baseWidth = 360.0; // Design baseline width
    final scaleFactor = screenWidth / baseWidth;

    return Scaffold(
      backgroundColor: Color(0xFFF6FFFB),
      body: Stack(
        children: [
          // Oval shape decoration
          Positioned(
            top: -30 * scaleFactor,
            left: -50 * scaleFactor,
            child: Container(
              width: 200 * scaleFactor,
              height: 200 * scaleFactor,
              decoration: BoxDecoration(
                color: Color(0xFFACE7C0).withOpacity(0.3), // 30% opacity
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60 * scaleFactor),
                Column(
                  children: [
                    Text(
                      "Explore India with Confidence",
                      style: GoogleFonts.inter(
                        fontSize: 22 * scaleFactor,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Your Destination, Our Guidance.",
                      style: GoogleFonts.inriaSerif(
                        fontSize: 19 * scaleFactor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                SizedBox(height: 10 * scaleFactor),
                Image.asset(
                  "assets/SplashScreen/splash4.png",
                  width: 350 * scaleFactor,
                  height: 350 * scaleFactor,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 5 * scaleFactor),
                Text(
                  "Ready to Explore?",
                  style: TextStyle(
                    fontSize: 24 * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0 * scaleFactor,
                      vertical: 8.0 * scaleFactor),
                  child: Text(
                    "Start your adventure and explore India with all services in one place.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18 * scaleFactor,
                      color: const Color.fromARGB(255, 128, 128, 128),
                    ),
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFACE7C0).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10 * scaleFactor),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFACE7C0).withOpacity(0.3),
                        padding:
                            EdgeInsets.symmetric(vertical: 12 * scaleFactor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10 * scaleFactor),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Let’s Go",
                        style: TextStyle(
                          fontSize: 20 * scaleFactor,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

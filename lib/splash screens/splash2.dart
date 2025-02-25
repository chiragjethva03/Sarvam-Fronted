import 'package:flutter/material.dart';
import 'package:Sarvam/consts/App_Colors.dart';

class SplashScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Base width for scaling
    final baseWidth = 360.0; // Design baseline
    final scaleFactor = screenWidth / baseWidth;

    return Scaffold(
      backgroundColor: AppColor.App_Bg_Primary, // Light greenish background
      body: Stack(
        children: [
          // Top circular decorations
          Positioned(
            top: -50 * scaleFactor,
            left: -50 * scaleFactor,
            child: Container(
              width: 180 * scaleFactor,
              height: 180 * scaleFactor,
              decoration: BoxDecoration(
                color: Color(0xFFACE7C0).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100 * scaleFactor,
            right: -50 * scaleFactor,
            child: Container(
              width: 180 * scaleFactor,
              height: 180 * scaleFactor,
              decoration: BoxDecoration(
                color: Color(0xFFACE7C0).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // **Content (Text, Images, and Icons)**
          Container(
            margin: EdgeInsets.only(top: 160 * scaleFactor),
            child: Column(
              children: [
                // Text Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0 * scaleFactor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown, // Ensures text scales properly
                        child: Text(
                          "Discover your next Adventure -",
                          style: TextStyle(
                            fontSize:
                                24 * MediaQuery.of(context).textScaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Book Flights, Train, Bus and",
                          style: TextStyle(
                            fontSize:
                                24 * MediaQuery.of(context).textScaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Explore Local Transportation",
                          style: TextStyle(
                            fontSize:
                                24 * MediaQuery.of(context).textScaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Transportation Custom Icons
                SizedBox(height: 45 * scaleFactor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconPlaceholder(
                        imagePath: 'assets/SplashScreen/plane.png',
                        scaleFactor: scaleFactor),
                    IconPlaceholder(
                        imagePath: 'assets/SplashScreen/train.png',
                        scaleFactor: scaleFactor),
                    IconPlaceholder(
                        imagePath: 'assets/SplashScreen/bus.png',
                        scaleFactor: scaleFactor),
                    IconPlaceholder(
                        imagePath: 'assets/SplashScreen/taxi.png',
                        scaleFactor: scaleFactor),
                  ],
                ),

                // Image above the oval
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10 * scaleFactor),
                      child: Image.asset(
                        'assets/SplashScreen/splash2.png',
                        fit: BoxFit.contain,
                        width: screenWidth, // Adjust to fill width
                        height: screenHeight * 0.4, // Proportional height
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IconPlaceholder extends StatelessWidget {
  final String imagePath;
  final double scaleFactor;

  IconPlaceholder({required this.imagePath, required this.scaleFactor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0 * scaleFactor),
      child: CircleAvatar(
        radius: 30 * scaleFactor,
        backgroundColor: Color(0xFFACE7C0).withOpacity(0.3),
        child: ClipOval(
          child: Image.asset(
            imagePath,
            width: 50 * scaleFactor,
            height: 50 * scaleFactor,
            fit: BoxFit.cover, // Ensures the image fits well
          ),
        ),
      ),
    );
  }
}

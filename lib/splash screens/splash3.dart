import 'package:flutter/material.dart';
import 'package:Sarvam/consts/App_Colors.dart';

class SplashScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppColor.App_Bg_Primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Top curved background
            Positioned(
              top: -screenHeight * 0.05,
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: Color(0xFFACE7C0).withOpacity(0.40),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(screenHeight * 0.12),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.04),

                  // Title and Subtitle
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      children: [
                        Text(
                          "Plan your stay with ease.",
                          style: TextStyle(
                            fontSize: 30 * textScale,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        Text(
                          "Find top-rated hotels and restaurants around your destination with just a few steps.",
                          style: TextStyle(
                            fontSize: 18 * textScale,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.07),

                  // Option Cards with Adjusted Image Size & Reduced Spacing
                  OptionCard(
                    image: "assets/SplashScreen/hotels.png",
                    text: "Find the perfect stay",
                    color: Color(0xFFACE7C0).withOpacity(0.23),
                    imageFirst: true,
                  ),
                  OptionCard(
                    image: "assets/SplashScreen/table.png",
                    text: "Reserve a table",
                    color: Color(0xFFEFF2BF).withOpacity(0.41),
                    imageFirst: false,
                  ),
                  OptionCard(
                    image: "assets/SplashScreen/date.png",
                    text: "Manage your bookings",
                    color: Color(0xFFCDCDCD).withOpacity(0.23),
                    imageFirst: true,
                  ),

                  Spacer(),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Adjusted OptionCard with Larger Images & Reduced Spacing
class OptionCard extends StatelessWidget {
  final String image;
  final String text;
  final Color? color;
  final bool imageFirst;

  OptionCard({
    required this.image,
    required this.text,
    this.color,
    required this.imageFirst,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.03, // Slightly reduced padding
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.green.shade100,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
        children: imageFirst
            ? [
                // ✅ Increased Image Size
                Image.asset(
                  image,
                  width: screenWidth * 0.20, // 20% of screen width
                  height: screenWidth * 0.20, // Keep square ratio
                ),

                // ✅ Reduced Spacing Between Image & Text
                SizedBox(width: screenWidth * 0.03),

                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20 * textScale, // Slightly bigger text
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20 * textScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // ✅ Reduced Spacing Between Text & Image
                SizedBox(width: screenWidth * 0.03),

                Image.asset(
                  image,
                  width: screenWidth * 0.20,
                  height: screenWidth * 0.20,
                ),
              ],
      ),
    );
  }
}

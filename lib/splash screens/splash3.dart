import 'package:flutter/material.dart';

class SplashScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Base width for scaling
    final baseWidth = 360.0; // Design baseline
    final scaleFactor = screenWidth / baseWidth;

    return Scaffold(
      backgroundColor: Color(0xFFF6FFFB),
      body: SafeArea(
        child: Stack(
          children: [
            // Top curved background
            Positioned(
              top: -50 * scaleFactor,
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                height: 310 * scaleFactor,
                decoration: BoxDecoration(
                  color: Color(0xFFACE7C0).withOpacity(0.40),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(110 * scaleFactor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60 * scaleFactor),
                  Container(
                    padding: EdgeInsets.all(20 * scaleFactor),
                    child: Column(
                      children: [
                        Text(
                          "Plan your stay with ease.",
                          style: TextStyle(
                            fontSize: 30 * scaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10 * scaleFactor),
                        Text(
                          "Find top rated hotels and restaurant around your destination with just few steps",
                          style: TextStyle(
                            fontSize: 23 * scaleFactor,
                            color: const Color.fromARGB(137, 72, 72, 72),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30 * scaleFactor),
                  OptionCard(
                    image: "assets/SplashScreen/hotels.png",
                    text: "Find the perfect stay",
                    color: Color(0xFFACE7C0).withOpacity(0.23),
                    scaleFactor: scaleFactor,
                    imageFirst: true,
                  ),
                  OptionCard(
                    image: "assets/SplashScreen/table.png",
                    text: "Reserve a table",
                    color: Color(0xFFEFF2BF).withOpacity(0.41),
                    scaleFactor: scaleFactor,
                    imageFirst: false,
                  ),
                  OptionCard(
                    image: "assets/SplashScreen/date.png",
                    text: "Manage your bookings",
                    color: Color(0xFFCDCDCD).withOpacity(0.23),
                    scaleFactor: scaleFactor,
                    isGrey: true,
                    imageFirst: true,
                  ),
                  Spacer(),
                  SizedBox(height: 30 * scaleFactor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String image;
  final String text;
  final Color? color;
  final bool isGrey;
  final bool imageFirst;
  final double scaleFactor;

  OptionCard({
    required this.image,
    required this.text,
    this.color,
    this.isGrey = false,
    this.imageFirst = true,
    required this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15 * scaleFactor),
      padding: EdgeInsets.symmetric(
        vertical: 15 * scaleFactor,
        horizontal: 20 * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: color ?? (isGrey ? Colors.grey.shade300 : Colors.green.shade100),
        borderRadius: BorderRadius.circular(15 * scaleFactor),
      ),
      child: Row(
        children: imageFirst
            ? [
                Image.asset(
                  image,
                  width: 100 * scaleFactor,
                  height: 90 * scaleFactor,
                ),
                SizedBox(width: 15 * scaleFactor),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 19 * scaleFactor,
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
                      fontSize: 19 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 15 * scaleFactor),
                Image.asset(
                  image,
                  width: 100 * scaleFactor,
                  height: 90 * scaleFactor,
                ),
              ],
      ),
    );
  }
}

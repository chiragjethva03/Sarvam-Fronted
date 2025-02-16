import 'package:flutter/material.dart';
import 'splash1.dart';
import 'splash2.dart';
import 'splash3.dart';
import 'splash4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashScreenMain extends StatefulWidget {
  @override
  _SplashScreenMainState createState() => _SplashScreenMainState();
}

class _SplashScreenMainState extends State<SplashScreenMain> {
  PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF6FFFB), // Ensuring the background color is consistent
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      _buildClickableScreen(SplashScreen1()),
                      _buildClickableScreen(SplashScreen2()),
                      _buildClickableScreen(SplashScreen3()),
                      _buildClickableScreen(SplashScreen4()),
                    ],
                  ),
                ),
                // Empty container for spacing above dots
                Container(height: 40),
              ],
            ),
            // Dot indicator
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 40.0), // Moves the dots a bit above the bottom
                child: _buildDotsIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableScreen(Widget screen) {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        // Detecting where the user tapped (left or right)
        if (details.localPosition.dx > MediaQuery.of(context).size.width / 2) {
          // User tapped on the right side, navigate to next page
          if (_currentPage < 3) {
            _controller.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        } else {
          // User tapped on the left side, navigate to previous page
          if (_currentPage > 0) {
            _controller.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: screen,
    );
  }

  Widget _buildDotsIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: _currentPage,
      count: 4,
      effect: ExpandingDotsEffect(
        activeDotColor: const Color.fromARGB(255, 90, 87, 87),
        dotHeight: 10,
        dotWidth: 10,
        spacing: 8,
        radius: 10,
        expansionFactor: 3,
      ),
    );
  }
}

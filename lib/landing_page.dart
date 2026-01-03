import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/contact_us.dart';
import 'screens/signup_page.dart';
import 'dart:async';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Reports Carousel State
  final ScrollController _reportsScrollController = ScrollController();
  Timer? _reportsTimer;
  bool _isScrollingForward = true;

  final List<Map<String, String>> reportCards = [
    {'image': 'images/photo1.png', 'label': 'Problem Name, Location'},
    {'image': 'images/photo2.png', 'label': 'Problem Name, Location'},
    {'image': 'images/photo3.png', 'label': 'Problem Name, Location'},
    {'image': 'images/photo4.png', 'label': 'Problem Name, Location'},
    {'image': 'images/photo5.png', 'label': 'Problem Name, Location'},
  ];

  @override
  void initState() {
    super.initState();
    _startReportsAutoScroll();
  }

  void _startReportsAutoScroll() {
    _reportsTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_reportsScrollController.hasClients) {
        double maxScroll = _reportsScrollController.position.maxScrollExtent;
        double currentScroll = _reportsScrollController.position.pixels;

        if (_isScrollingForward) {
          if (currentScroll >= maxScroll) {
            _isScrollingForward = false;
          } else {
            _reportsScrollController.jumpTo(currentScroll + 1);
          }
        } else {
          if (currentScroll <= 0) {
            _isScrollingForward = true;
          } else {
            _reportsScrollController.jumpTo(currentScroll - 1);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _reportsTimer?.cancel();
    _reportsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Transparent AppBar
            _buildHeroWithAppBar(context),

            // Reports Section
            _buildReportsSection(context),

            // Call to Action Section
            _buildCallToActionSection(context),

            // Statistics Section
            _buildStatisticsSection(context),

            // Footer Section
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // Hero Section with Transparent AppBar Overlay
  Widget _buildHeroWithAppBar(BuildContext context) {
    return Stack(
      children: [
        // Hero Background Image - Full Screen Height
        Container(
          //   color: Colors.black.withOpacity(0.4),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/photo1.png'),
              fit: BoxFit.cover,
              // alignment: Alignment.topLeft,
            ),
          ),

          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Nagarik Action',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 8,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your voice for a better community. Report problems and be the change.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 6,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Transparent AppBar Overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildTransparentAppBar(context),
        ),
      ],
    );
  }

  // Transparent AppBar with Enhanced Visibility
  Widget _buildTransparentAppBar(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.3), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          // Logo
          _buildLogo(),
          const Spacer(),

          // Navigation Buttons - Plain Text with Hover
          _buildNavButton('Reports', () {}),
          const SizedBox(width: 25),
          _buildNavButton('Contact Us', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactPage()),
            );
          }),
          const SizedBox(width: 25),
          _buildNavButton('Sign Up', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NagarikSignUpPage(
                  firebaseUser: FirebaseAuth.instance.currentUser!,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        'assets/images/logo1.png',
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildNavButton(String text, VoidCallback onPressed) {
    return SimpleHoverText(
      child: GestureDetector(onTap: onPressed, child: Text(text)),
    );
  }

  // Reports Section with Auto-Scrolling
  Widget _buildReportsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'See the reports made by your community',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reports',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 35),

          // Horizontal Scrolling Report Cards
          SizedBox(
            height: 240,
            child: ListView.builder(
              controller: _reportsScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: reportCards.length * 100, // Infinite loop
              itemBuilder: (context, index) {
                final cardIndex = index % reportCards.length;
                return _buildReportCard(
                  reportCards[cardIndex]['image']!,
                  reportCards[cardIndex]['label']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String imagePath, String label) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Want to become a Change?',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Here is Nagarik action, the platform where you can report the problem in community so that government can take actions.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            HoverScaleButton(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 34,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Report Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FIXED OVERFLOW HERE (ONLY CHANGE)
  Widget _buildStatisticsSection(BuildContext context) {
    return Container(
      height: 256,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/photo3.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Nagarik Action by the Numbers.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Kathmandu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              SizedBox(height: 12),
              Text(
                'Pokhara',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              SizedBox(height: 12),
              Text(
                'Bhaktapur',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              SizedBox(height: 12),
              Text(
                'Lalitpur',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 35),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nagarik Action',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 All Rights Reserved',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          const Text(
            'hello@xyz.com',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 5),
          const Text(
            '(044) 333-4567',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSocialIcon(Icons.facebook),
              const SizedBox(width: 15),
              _buildSocialIcon(Icons.camera_alt),
              const SizedBox(width: 15),
              _buildSocialIcon(Icons.video_library),
              const SizedBox(width: 15),
              _buildSocialIcon(Icons.alternate_email),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return HoverScaleButton(
      child: InkWell(
        onTap: () {},
        child: Icon(icon, color: Colors.white70, size: 24),
      ),
    );
  }
}

// Hover Effect Widgets
class SimpleHoverText extends StatefulWidget {
  final Widget child;
  const SimpleHoverText({super.key, required this.child});

  @override
  State<SimpleHoverText> createState() => _SimpleHoverTextState();
}

class _SimpleHoverTextState extends State<SimpleHoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: DefaultTextStyle(
        style: TextStyle(
          color: _isHovered ? const Color(0xFF00E5FF) : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          shadows: const [
            Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black54),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final Widget child;
  const HoverButton({super.key, required this.child});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        child: Opacity(opacity: _isHovered ? 0.85 : 1.0, child: widget.child),
      ),
    );
  }
}

class HoverScaleButton extends StatefulWidget {
  final Widget child;
  const HoverScaleButton({super.key, required this.child});

  @override
  State<HoverScaleButton> createState() => _HoverScaleButtonState();
}

class _HoverScaleButtonState extends State<HoverScaleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: widget.child,
      ),
    );
  }
}

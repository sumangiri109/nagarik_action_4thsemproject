import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  String selectedLanguage = 'English';
  WebViewController? _mapController;
  
  // ============================================
  // EASY CUSTOMIZATION SECTION - CHANGE THESE
  // ============================================
  
  // Image paths - Just change these file names
  final String heroBackgroundImage = 'assets/images/photo4.png';
  final String logoImage = 'assets/images/logo1.png';
  
  // Google Maps coordinates - Change to your location
  final double mapLatitude = 40.758896;
  final double mapLongitude = -73.985130;
  final String mapLocationName = 'Times Square, New York';
  
  // Orange theme color - Change hex values to customize
  final Color primaryOrange = const Color(0xFFFF7043);
  final Color lightOrange = const Color(0xFFFFAB91);
  final Color darkOrange = const Color(0xFFFF5722);
  
  // ============================================
  // END CUSTOMIZATION SECTION
  // ============================================
  
  // Language options with flags
  final Map<String, String> languages = {
    'English': '🇺🇸',
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'German': '🇩🇪',
  };

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeMap();
    }
  }

  void _initializeMap() {
    try {
      _mapController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..loadRequest(
          Uri.parse(
            'https://maps.google.com/maps?q=$mapLatitude,$mapLongitude&t=&z=15&ie=UTF8&iwloc=&output=embed',
          ),
        );
    } catch (e) {
      print('Error initializing map: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message sent successfully!'),
          backgroundColor: primaryOrange,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  Future<void> _openInGoogleMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$mapLatitude,$mapLongitude'
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroWithForm(isMobile),
            _buildMapSection(isMobile),
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroWithForm(bool isMobile) {
    return Stack(
      children: [
        // Hero Background
        Container(
          width: double.infinity,
          height: isMobile ? 562.5 : 487.5,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(heroBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        // Logo and Language Selector (NO shadow on logo, fixed navigation)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 45,
              vertical: 22.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo - NO SHADOW, clickable with pointer cursor
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate back to landing page
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      logoImage,
                      height: isMobile ? 52.5 : 67.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                
                // Language Selector - Fixed (single box, full names, flags)
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      dropdownColor: Colors.black.withOpacity(0.9),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 13.5),
                      isDense: true,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      items: languages.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(entry.value, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 6),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Content with Form
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: isMobile ? 105 : 120,
            bottom: 45,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 750),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 30),
              child: Column(
                children: [
                  // Title
                  Text(
                    'CONTACT US',
                    style: TextStyle(
                      fontSize: isMobile ? 31.5 : 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 3),
                          blurRadius: 11.25,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 15),
                  
                  // Subtitle
                  Container(
                    constraints: const BoxConstraints(maxWidth: 487.5),
                    child: Text(
                      'Have a question or just want to say hi? Don\'t hesitate, we\'d love to hear from you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14.25,
                        color: Colors.white,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 1.5),
                            blurRadius: 7.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 37.5 : 52.5),
                  
                  // Contact Form
                  Container(
                    constraints: const BoxConstraints(maxWidth: 675),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.85),
                          Colors.white.withOpacity(0.95),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.3, 0.6],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(isMobile ? 22.5 : 41.25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name and Email row
                          if (isMobile)
                            Column(
                              children: [
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Name*',
                                  hint: 'Your full name',
                                  icon: Icons.person_outline,
                                ),
                                const SizedBox(height: 18),
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email*',
                                  hint: 'Your email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _nameController,
                                    label: 'Name*',
                                    hint: 'Your full name',
                                    icon: Icons.person_outline,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _emailController,
                                    label: 'Email*',
                                    hint: 'Your email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 18),
                          
                          // Phone and Subject row
                          if (isMobile)
                            Column(
                              children: [
                                _buildTextField(
                                  controller: _phoneController,
                                  label: 'Phone*',
                                  hint: 'Your phone number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 18),
                                _buildTextField(
                                  controller: _subjectController,
                                  label: 'Subject*',
                                  hint: 'Subject',
                                  icon: Icons.subject_outlined,
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _phoneController,
                                    label: 'Phone*',
                                    hint: 'Your phone number',
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _subjectController,
                                    label: 'Subject*',
                                    hint: 'Subject',
                                    icon: Icons.subject_outlined,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 18),
                          
                          // Message
                          _buildTextField(
                            controller: _messageController,
                            label: 'Message*',
                            hint: 'Write your message here...',
                            icon: Icons.message_outlined,
                            maxLines: 5,
                          ),
                          SizedBox(height: isMobile ? 24 : 30),
                          
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.5),
                                ),
                                elevation: 3.75,
                                shadowColor: primaryOrange.withOpacity(0.4),
                              ),
                              child: const Text(
                                'Send Message',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 7.5),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.25,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.225,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 11.25),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 11.25,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 9),
              child: Icon(icon, color: primaryOrange, size: 16.5),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: primaryOrange, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.red, width: 1.125),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 13.5,
              vertical: maxLines > 1 ? 13.5 : 12,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            if (label.contains('Email') && !value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMapSection(bool isMobile) {
    return Container(
      width: double.infinity,
      height: isMobile ? 262.5 : 337.5,
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 45,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 7.5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Real Interactive Google Map
          if (_mapController != null && !kIsWeb)
            WebViewWidget(controller: _mapController!)
          else
            // Fallback for web or if map fails to load
            GestureDetector(
              onTap: _openInGoogleMaps,
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 60,
                        color: primaryOrange.withOpacity(0.6),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Interactive Map',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap to open in Google Maps',
                        style: TextStyle(
                          fontSize: 11.25,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Location label overlay
          Positioned(
            top: 15,
            left: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7.5,
                    offset: const Offset(0, 2.25),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: primaryOrange, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    mapLocationName,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 1050),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 18 : 45,
              vertical: isMobile ? 37.5 : 52.5,
            ),
            child: isMobile
                ? _buildFooterMobile()
                : _buildFooterDesktop(),
          ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18.75),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(Icons.facebook, 'Facebook'),
                    const SizedBox(width: 12),
                    _buildSocialIcon(Icons.videocam, 'YouTube'),
                    const SizedBox(width: 12),
                    _buildSocialIcon(Icons.phone, 'Phone'),
                    const SizedBox(width: 12),
                    _buildSocialIcon(Icons.email, 'Email'),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  '© 2024 Your Company. All rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 0.375,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFooterSection(
          'Company',
          ['About Us', 'Our Team', 'Careers', 'News'],
        ),
        const SizedBox(height: 26.25),
        _buildFooterSection(
          'Services',
          ['Products', 'Solutions', 'Support', 'Pricing'],
        ),
        const SizedBox(height: 26.25),
        _buildFooterSection(
          'Contact',
          ['Contact Us', 'Help Center', 'Privacy Policy', 'Terms of Service'],
        ),
      ],
    );
  }

  Widget _buildFooterDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR COMPANY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                  letterSpacing: 1.125,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Building amazing experiences for our customers worldwide. Let\'s create something great together.',
                style: TextStyle(
                  fontSize: 11.25,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 45),
        Expanded(
          child: _buildFooterSection(
            'Company',
            ['About Us', 'Our Team', 'Careers', 'News'],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: _buildFooterSection(
            'Services',
            ['Products', 'Solutions', 'Support', 'Pricing'],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: _buildFooterSection(
            'Contact',
            ['Contact Us', 'Help Center', 'Privacy', 'Terms'],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.75,
          ),
        ),
        const SizedBox(height: 15),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: InkWell(
            onTap: () {},
            child: Text(
              link,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return Tooltip(
      message: label,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: primaryOrange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(7.5),
          border: Border.all(color: primaryOrange.withOpacity(0.3)),
        ),
        child: Icon(icon, color: primaryOrange, size: 16.5),
      ),
    );
  }
}
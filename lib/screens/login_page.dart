import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/signup_page.dart';
import '../services/auth_service.dart';

class NagarikLoginPage extends StatefulWidget {
  const NagarikLoginPage({super.key});

  @override
  State<NagarikLoginPage> createState() => _NagarikLoginPageState();
}

class _NagarikLoginPageState extends State<NagarikLoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Google Sign-in handler
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with Google
      final user = await _authService.signInWithGoogle();

      if (user == null) {
        // User cancelled sign-in
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check if user document exists
      final userExists = await _authService.checkUserExists(user.uid);

      if (userExists) {
        // User already has profile - get user data and navigate to home
        final userData = await _authService.getUserData(user.uid);
        
        if (mounted) {
          // TODO: Navigate to home screen based on user role
          // For now, just show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome back, ${userData?.name}!')),
          );
          
          // Navigate to appropriate home screen based on role
          // if (userData?.role == UserRole.citizen) {
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CitizenHomeScreen()));
          // } else if (userData?.role == UserRole.government) {
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GovernmentHomeScreen()));
          // }
        }
      } else {
        // New user - navigate to signup page
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NagarikSignUpPage(firebaseUser: user),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const peach = Color(0xFFF8C9B4);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/photo3.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return Row(
                children: [
                  if (!isMobile)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nagarik Action — your voice for a better community.\nReport problems and be the change.',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              width: 450,
                              height: 400,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: peach.withOpacity(0.65),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.55),
                                  width: 1.3,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lock_outline,
                                        size: 18,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Log in',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Welcome message
                                  Text(
                                    'Welcome to Nagarik Action',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sign in with your Google account to continue',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  // Google Sign-in Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      onPressed: _isLoading ? null : _signInWithGoogle,
                                      icon: _isLoading
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.black87,
                                              ),
                                            )
                                          : Icon(
                                              Icons.g_mobiledata,
                                              size: 28,
                                              color: Color(0xFFDB4437),
                                            ),
                                      label: Text(
                                        _isLoading ? 'Signing in...' : 'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Terms and Privacy
                                  Center(
                                    child: Text(
                                      'By continuing, you agree to our\nTerms of use and Privacy Policy.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  
                                  const Spacer(),
                                  
                                  // Sign up link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'New to Nagarik Action? ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87),
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: _isLoading ? null : () async {
                                            // Sign in with Google first, then go to signup
                                            final user = await _authService.signInWithGoogle();
                                            if (user != null && mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => NagarikSignUpPage(firebaseUser: user),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            'Sign up',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'signup_page.dart'; // import your signup page file

class NagarikLoginPage extends StatefulWidget {
  const NagarikLoginPage({super.key});

  @override
  State<NagarikLoginPage> createState() => _NagarikLoginPageState();
}

class _NagarikLoginPageState extends State<NagarikLoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _remember = true;

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
                              height: 500, // a bit taller to fit social buttons
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
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Email address or user name',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  _inputField(
                                    controller: _emailCtrl,
                                    hint: 'Enter email or username',
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Password',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  _inputField(
                                    controller: _passwordCtrl,
                                    hint: 'Enter password',
                                    obscure: _obscure,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() => _obscure = !_obscure);
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _remember,
                                        visualDensity: VisualDensity.compact,
                                        activeColor: Colors.black87,
                                        onChanged: (v) {
                                          setState(
                                            () => _remember = v ?? false,
                                          );
                                        },
                                      ),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'By continuing, you agree to the Terms of use and Privacy Policy.',
                                    style: TextStyle(fontSize: 10.5),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 42,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: handle login
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFE1D7D7),
                                        foregroundColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Log in',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        // TODO: forgot password
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text(
                                        'Forget your password',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Colors.black87,
                                          decoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Divider with "Or continue with"
                                  Row(
                                    children: const [
                                      Expanded(
                                          child: Divider(
                                              color: Colors.black54)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Or continue with',
                                          style: TextStyle(
                                              fontSize: 11.5,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              color: Colors.black54)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Social buttons row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _socialIcon(
                                        icon: Icons.facebook,
                                        color: const Color(0xFF1877F2),
                                      ),
                                      const SizedBox(width: 16),
                                      _socialIcon(
                                        icon: Icons.apple,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 16),
                                      _socialIcon(
                                        icon: Icons.g_mobiledata,
                                        color: const Color(0xFFDB4437),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Don\'t have an account? ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87),
                                      ),
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const NagarikSignUpPage(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Sign up',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                              decoration:
                                                  TextDecoration.underline,
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.9),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _socialIcon({required IconData icon, required Color color}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.95),
      ),
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }
}

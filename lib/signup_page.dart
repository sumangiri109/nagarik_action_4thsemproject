import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nagarik_action_4thsemproject/login_page.dart';

class NagarikSignUpPage extends StatefulWidget {
  const NagarikSignUpPage({super.key});

  @override
  State<NagarikSignUpPage> createState() => _NagarikSignUpPageState();
}

class _NagarikSignUpPageState extends State<NagarikSignUpPage> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _agreeTerms = true;
  bool _agreeMarketing = false;

  double peachOpacity = 0.65;

  final List<_Country> _countries = const [
    _Country('United States', '🇺🇸', '+1'),
    _Country('Nepal', '🇳🇵', '+977'),
    _Country('India', '🇮🇳', '+91'),
    _Country('United Kingdom', '🇬🇧', '+44'),
    _Country('Australia', '🇦🇺', '+61'),
  ];
  late _Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries[0];
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
                              width: 680,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: peach.withOpacity(peachOpacity),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.55),
                                  width: 1.3,
                                ),
                              ),
                              child: DefaultTextStyle(
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sign up now',
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _suLabeledField(
                                            label: 'First name',
                                            controller: _firstNameCtrl,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _suLabeledField(
                                            label: 'Last name',
                                            controller: _lastNameCtrl,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _suLabeledField(
                                      label: 'Email address',
                                      controller: _emailCtrl,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Phone number',
                                      style: TextStyle(fontSize: 12.5),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        _countryPicker(),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _suField(
                                            controller: _phoneCtrl,
                                            hint: '',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Password',
                                      style: TextStyle(fontSize: 12.5),
                                    ),
                                    const SizedBox(height: 4),
                                    _suField(
                                      controller: _passwordCtrl,
                                      hint: '',
                                      obscure: _obscure,
                                      suffix: IconButton(
                                        icon: Icon(
                                          _obscure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(
                                              () => _obscure = !_obscure);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Use 8 or more characters with a mix of letters, numbers & symbols',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.black87),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: _agreeTerms,
                                          visualDensity:
                                              VisualDensity.compact,
                                          activeColor: Colors.black87,
                                          onChanged: (v) {
                                            setState(() => _agreeTerms =
                                                v ?? false);
                                          },
                                        ),
                                        const Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              style: TextStyle(
                                                  fontSize: 11.5),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        'By creating an account, I agree to our '),
                                                TextSpan(
                                                  text: 'Terms of use',
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                ),
                                                TextSpan(text: ' and '),
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: TextStyle(
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          value: _agreeMarketing,
                                          visualDensity:
                                              VisualDensity.compact,
                                          activeColor: Colors.black87,
                                          onChanged: (v) {
                                            setState(() =>
                                                _agreeMarketing = v ?? false);
                                          },
                                        ),
                                        const Expanded(
                                          child: Text(
                                            'By creating an account, I am also consenting to receive SMS messages and emails, including product updates, events, and marketing promotions.',
                                            style: TextStyle(
                                                fontSize: 11.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 44,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // TODO sign up
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFE1D7D7),
                                              foregroundColor:
                                                  Colors.black87,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              elevation: 0,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 26),
                                            ),
                                            child: const Text(
                                              'Sign up',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const NagarikLoginPage(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Already have an account? Log in',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: Colors.black87,
                                              decoration:
                                                  TextDecoration.underline,
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _suLabeledField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5)),
        const SizedBox(height: 4),
        _suField(controller: controller, hint: ''),
      ],
    );
  }

  Widget _suField({
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
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _countryPicker() {
    return InkWell(
      onTap: () async {
        final selected = await showDialog<_Country>(
          context: context,
          builder: (context) => Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final c = _countries[index];
                return ListTile(
                  dense: true,
                  leading: Text(c.flag,
                      style: const TextStyle(fontSize: 22)),
                  title: Text(c.code,
                      style: const TextStyle(fontSize: 14)),
                  onTap: () => Navigator.of(context).pop(c),
                );
              },
            ),
          ),
        );
        if (selected != null) {
          setState(() => _selectedCountry = selected);
        }
      },
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withOpacity(0.9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedCountry.flag,
                style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 4),
            Text(
              _selectedCountry.code,
              style: const TextStyle(fontSize: 13),
            ),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}

class _Country {
  final String name;
  final String flag;
  final String code;
  const _Country(this.name, this.flag, this.code);
}
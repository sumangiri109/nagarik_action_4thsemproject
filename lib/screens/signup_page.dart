import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../models/enums.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import 'citizen/citizen_home_screen.dart';
import 'government/government_home_screen.dart';
import 'pending_verification_screen.dart';

class NagarikSignUpPage extends StatefulWidget {
  final User firebaseUser;

  const NagarikSignUpPage({super.key, required this.firebaseUser});

  @override
  State<NagarikSignUpPage> createState() => _NagarikSignUpPageState();
}

class _NagarikSignUpPageState extends State<NagarikSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _specificLocationCtrl = TextEditingController();

  // Government-specific
  final _officeNameCtrl = TextEditingController();
  final _positionCtrl = TextEditingController();
  final _departmentCtrl = TextEditingController();
  final _officeEmailCtrl = TextEditingController();
  final _officePhoneCtrl = TextEditingController();

  bool _isLoading = false;
  bool _agreeTerms = true;

  // Role selection
  UserRole _selectedRole = UserRole.citizen;

  // Location data
  String? _selectedDistrict;
  String? _selectedMunicipality;
  int? _selectedWard;
  List<String> _municipalities = [];
  List<int> _wards = [];

  // Government certificate (Web - using file_picker)
  PlatformFile? _certificateFile;
  String? _certificateFileName;

  double peachOpacity = 0.65;

  @override
  void initState() {
    super.initState();
    // Pre-fill name from Google account
    _nameCtrl.text = widget.firebaseUser.displayName ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _specificLocationCtrl.dispose();
    _officeNameCtrl.dispose();
    _positionCtrl.dispose();
    _departmentCtrl.dispose();
    _officeEmailCtrl.dispose();
    _officePhoneCtrl.dispose();
    super.dispose();
  }

  void _onDistrictChanged(String? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedMunicipality = null;
      _selectedWard = null;

      final municipalityMap = AppConstants.getMunicipalitiesByDistrict();
      _municipalities = municipalityMap[district] ?? [];
      _wards = [];
    });
  }

  void _onMunicipalityChanged(String? municipality) {
    setState(() {
      _selectedMunicipality = municipality;
      _selectedWard = null;

      if (municipality != null) {
        final wardCount = AppConstants.getWardCount(municipality);
        _wards = List.generate(wardCount, (index) => index + 1);
      } else {
        _wards = [];
      }
    });
  }

  Future<void> _pickCertificate() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _certificateFile = result.files.first;
          _certificateFileName = result.files.first.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to Terms of use and Privacy Policy'),
        ),
      );
      return;
    }

    if (_selectedRole == UserRole.government && _certificateFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload government certificate')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? certificateUrl;

      // Upload certificate if government user (Web version)
      if (_selectedRole == UserRole.government && _certificateFile != null) {
        if (_certificateFile!.bytes == null) {
          throw Exception('No file data');
        }

        certificateUrl = await _storageService.uploadFileFromBytes(
          fileBytes: _certificateFile!.bytes!,
          folderPath: 'users/${widget.firebaseUser.uid}/documents',
          fileName: 'certificate.${_certificateFile!.extension ?? 'pdf'}',
        );
      }

      await _authService.completeSignup(
        uid: widget.firebaseUser.uid,
        email: widget.firebaseUser.email!,
        name: _nameCtrl.text.trim(),
        role: _selectedRole,
        district: _selectedDistrict!,
        municipality: _selectedMunicipality!,
        ward: _selectedWard!,
        specificLocation: _specificLocationCtrl.text.trim().isNotEmpty
            ? _specificLocationCtrl.text.trim()
            : null,
        phoneNumber: _phoneCtrl.text.trim(),
        profileImageUrl: widget.firebaseUser.photoURL,
        officeName: _selectedRole == UserRole.government
            ? _officeNameCtrl.text.trim()
            : null,
        position: _selectedRole == UserRole.government
            ? _positionCtrl.text.trim()
            : null,
        department: _departmentCtrl.text.trim().isNotEmpty
            ? _departmentCtrl.text.trim()
            : null,
        officeEmail: _officeEmailCtrl.text.trim().isNotEmpty
            ? _officeEmailCtrl.text.trim()
            : null,
        officePhone: _officePhoneCtrl.text.trim().isNotEmpty
            ? _officePhoneCtrl.text.trim()
            : null,
        certificateUrl: certificateUrl,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedRole == UserRole.government
                  ? AppConstants.verificationPending
                  : AppConstants.signupSuccess,
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Wait for snackbar to show
        await Future.delayed(Duration(milliseconds: 500));

        // Navigate to appropriate screen based on role
        if (_selectedRole == UserRole.citizen) {
          // Citizen users go directly to home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CitizenHomeScreen()),
          );
        } else if (_selectedRole == UserRole.government) {
          // Government users go to pending verification screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const PendingVerificationScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
    final isGovernment = _selectedRole == UserRole.government;

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
                          horizontal: 40,
                          vertical: 20,
                        ),
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
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.9,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: peach.withOpacity(peachOpacity),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.55),
                                  width: 1.3,
                                ),
                              ),
                              child: _isLoading
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.black87,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Creating your account...',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: Form(
                                        key: _formKey,
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
                                                'Complete Your Profile',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              const SizedBox(height: 16),

                                              // Role Selection
                                              Text(
                                                'I am a:',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: _roleOption(
                                                      title: 'Citizen',
                                                      role: UserRole.citizen,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: _roleOption(
                                                      title:
                                                          'Government Official',
                                                      role: UserRole.government,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),

                                              // Basic Info
                                              _suLabeledField(
                                                label: 'Full Name *',
                                                controller: _nameCtrl,
                                                validator:
                                                    Validators.validateName,
                                              ),
                                              const SizedBox(height: 10),
                                              _suLabeledField(
                                                label: 'Phone Number *',
                                                controller: _phoneCtrl,
                                                validator:
                                                    Validators.validatePhone,
                                                hint: '+977-9841234567',
                                              ),
                                              const SizedBox(height: 16),

                                              // Location Section
                                              Text(
                                                '📍 Your Location',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 10),

                                              _suDropdown<String>(
                                                label: 'District *',
                                                value: _selectedDistrict,
                                                items: AppConstants.districts,
                                                onChanged: _onDistrictChanged,
                                                validator: (v) =>
                                                    Validators.validateDropdown(
                                                      v,
                                                      'district',
                                                    ),
                                              ),
                                              const SizedBox(height: 10),

                                              _suDropdown<String>(
                                                label: 'Municipality *',
                                                value: _selectedMunicipality,
                                                items: _municipalities,
                                                onChanged:
                                                    _onMunicipalityChanged,
                                                validator: (v) =>
                                                    Validators.validateDropdown(
                                                      v,
                                                      'municipality',
                                                    ),
                                              ),
                                              const SizedBox(height: 10),

                                              _suDropdown<int>(
                                                label: 'Ward Number *',
                                                value: _selectedWard,
                                                items: _wards,
                                                onChanged: (v) => setState(
                                                  () => _selectedWard = v,
                                                ),
                                                validator: (v) =>
                                                    Validators.validateWardNumber(
                                                      v,
                                                    ),
                                                displayText: (ward) =>
                                                    'Ward $ward',
                                              ),
                                              const SizedBox(height: 10),

                                              _suLabeledField(
                                                label:
                                                    'Specific Location (Optional)',
                                                controller:
                                                    _specificLocationCtrl,
                                                hint: 'e.g., Near Main Chowk',
                                                maxLines: 2,
                                              ),

                                              // Government-specific fields
                                              if (isGovernment) ...[
                                                const SizedBox(height: 16),
                                                Text(
                                                  '🏢 Official Details',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),

                                                _suLabeledField(
                                                  label: 'Office Name *',
                                                  controller: _officeNameCtrl,
                                                  validator: (v) =>
                                                      Validators.validateRequired(
                                                        v,
                                                        'Office name',
                                                      ),
                                                ),
                                                const SizedBox(height: 10),

                                                _suDropdown<String>(
                                                  label: 'Position *',
                                                  value:
                                                      _positionCtrl.text.isEmpty
                                                      ? null
                                                      : _positionCtrl.text,
                                                  items: AppConstants
                                                      .governmentPositions,
                                                  onChanged: (v) => setState(
                                                    () => _positionCtrl.text =
                                                        v ?? '',
                                                  ),
                                                  validator: (v) =>
                                                      Validators.validateDropdown(
                                                        v,
                                                        'position',
                                                      ),
                                                ),
                                                const SizedBox(height: 10),

                                                _suDropdown<String>(
                                                  label:
                                                      'Department (Optional)',
                                                  value:
                                                      _departmentCtrl
                                                          .text
                                                          .isEmpty
                                                      ? null
                                                      : _departmentCtrl.text,
                                                  items: AppConstants
                                                      .governmentDepartments,
                                                  onChanged: (v) => setState(
                                                    () => _departmentCtrl.text =
                                                        v ?? '',
                                                  ),
                                                ),
                                                const SizedBox(height: 10),

                                                _suLabeledField(
                                                  label:
                                                      'Office Email (Optional)',
                                                  controller: _officeEmailCtrl,
                                                ),
                                                const SizedBox(height: 10),

                                                _suLabeledField(
                                                  label:
                                                      'Office Phone (Optional)',
                                                  controller: _officePhoneCtrl,
                                                ),
                                                const SizedBox(height: 16),

                                                // Certificate Upload
                                                Text(
                                                  '📄 Government Certificate *',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                InkWell(
                                                  onTap: _pickCertificate,
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.black38,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            14,
                                                          ),
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.upload_file,
                                                          color: Colors.black54,
                                                        ),
                                                        SizedBox(width: 12),
                                                        Expanded(
                                                          child: Text(
                                                            _certificateFileName ??
                                                                'Choose Certificate File (PDF, JPG, PNG)',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                        if (_certificateFileName !=
                                                            null)
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              size: 18,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _certificateFile =
                                                                    null;
                                                                _certificateFileName =
                                                                    null;
                                                              });
                                                            },
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.orange.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.info_outline,
                                                        size: 16,
                                                        color: Colors
                                                            .orange
                                                            .shade700,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          AppConstants
                                                              .verificationPending,
                                                          style: TextStyle(
                                                            fontSize: 10.5,
                                                            color: Colors
                                                                .orange
                                                                .shade900,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],

                                              const SizedBox(height: 16),

                                              // Terms checkbox
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
                                                      setState(
                                                        () => _agreeTerms =
                                                            v ?? false,
                                                      );
                                                    },
                                                  ),
                                                  const Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'By creating an account, I agree to our ',
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'Terms of use',
                                                            style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: ' and ',
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'Privacy Policy',
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
                                              const SizedBox(height: 16),

                                              // Submit Button
                                              SizedBox(
                                                width: double.infinity,
                                                height: 44,
                                                child: ElevatedButton(
                                                  onPressed: _submit,
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFE1D7D7),
                                                    foregroundColor:
                                                        Colors.black87,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            24,
                                                          ),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  child: Text(
                                                    isGovernment
                                                        ? 'Submit for Verification'
                                                        : 'Complete Profile',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
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

  Widget _roleOption({required String title, required UserRole role}) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.black26,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 18,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _suLabeledField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5)),
        const SizedBox(height: 4),
        _suField(
          controller: controller,
          hint: hint ?? '',
          validator: validator,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _suField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffix,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.9),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 13),
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _suDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
    String Function(T)? displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withOpacity(0.9),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  displayText != null ? displayText(item) : item.toString(),
                  style: TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}

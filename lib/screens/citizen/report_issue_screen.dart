// lib/screens/citizen/report_issue_screen.dart

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nagarik_action_4thsemproject/models/user_models.dart';
import '../../models/issue_model.dart';
import '../../models/location_model.dart';
import '../../models/enums.dart';
import '../../services/user_service.dart';
import 'package:nagarik_action_4thsemproject/services/issue_services.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({Key? key}) : super(key: key);

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final IssueService _issueService = IssueService();
  final StorageService _storageService = StorageService();

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _specificLocationController = TextEditingController();

  // Current user
  UserModel? currentUser;
  bool isLoading = true;
  bool isSubmitting = false;

  // Form data
  String _locationOption = "My Own Area"; // "My Own Area" or "Different Area"
  IssueCategory? _selectedCategory;
  IssuePriority _selectedPriority = IssuePriority.medium;

  // Different area fields
  String? _selectedDistrict;
  String? _selectedMunicipality;
  int? _selectedWard;

  // Images
  List<PlatformFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _userService.getUserById(user.uid);
      setState(() {
        currentUser = userData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF3E0),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B6B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ).createShader(bounds),
          child: const Text(
            'Report Issue',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationSection(),
              const SizedBox(height: 20),
              _buildTitleField(),
              const SizedBox(height: 20),
              _buildCategoryField(),
              const SizedBox(height: 20),
              _buildPriorityField(),
              const SizedBox(height: 20),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              _buildSpecificLocationField(),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📍 Where is this problem?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 15),

          // My Own Area
          RadioListTile<String>(
            title: const Text('My Own Area'),
            subtitle: currentUser != null
                ? Text(
                    '${currentUser!.location.district}, ${currentUser!.location.municipality}, Ward ${currentUser!.location.ward}',
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  )
                : null,
            value: "My Own Area",
            groupValue: _locationOption,
            activeColor: const Color(0xFFFF6B6B),
            onChanged: (value) {
              setState(() {
                _locationOption = value!;
              });
            },
          ),

          // Different Area
          RadioListTile<String>(
            title: const Text('Different Area'),
            subtitle: const Text(
              'Report issue in another location',
              style: TextStyle(fontSize: 12),
            ),
            value: "Different Area",
            groupValue: _locationOption,
            activeColor: const Color(0xFFFF6B6B),
            onChanged: (value) {
              setState(() {
                _locationOption = value!;
              });
            },
          ),

          // Show dropdowns if Different Area selected
          if (_locationOption == "Different Area") ...[
            const SizedBox(height: 15),
            _buildDistrictDropdown(),
            const SizedBox(height: 12),
            if (_selectedDistrict != null) _buildMunicipalityDropdown(),
            const SizedBox(height: 12),
            if (_selectedMunicipality != null) _buildWardDropdown(),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '📸 Photos are required when reporting outside your area',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'District',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      value: _selectedDistrict,
      items: AppConstants.districts.map((district) {
        return DropdownMenuItem(value: district, child: Text(district));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedDistrict = value;
          _selectedMunicipality = null;
          _selectedWard = null;
        });
      },
      validator: (value) => value == null ? 'Please select district' : null,
    );
  }

  Widget _buildMunicipalityDropdown() {
    final municipalities =
        AppConstants.getMunicipalitiesByDistrict()[_selectedDistrict!] ?? [];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Municipality',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      value: _selectedMunicipality,
      items: municipalities.map((mun) {
        return DropdownMenuItem(value: mun, child: Text(mun));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedMunicipality = value;
          _selectedWard = null;
        });
      },
      validator: (value) => value == null ? 'Please select municipality' : null,
    );
  }

  Widget _buildWardDropdown() {
    final wardCount = AppConstants.getWardCount(_selectedMunicipality!);
    final wards = List.generate(wardCount, (index) => index + 1);

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Ward',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      value: _selectedWard,
      items: wards.map((ward) {
        return DropdownMenuItem(value: ward, child: Text('Ward $ward'));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedWard = value;
        });
      },
      validator: (value) => value == null ? 'Please select ward' : null,
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Issue Title *',
        hintText: 'e.g., Road damaged near school',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<IssueCategory>(
      decoration: InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      value: _selectedCategory,
      items: IssueCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category.displayName),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildPriorityField() {
    return DropdownButtonFormField<IssuePriority>(
      decoration: InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      value: _selectedPriority,
      items: IssuePriority.values.map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Text(priority.displayName),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPriority = value!;
        });
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Description *',
        hintText: 'Describe the issue in detail...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  Widget _buildSpecificLocationField() {
    return TextFormField(
      controller: _specificLocationController,
      decoration: InputDecoration(
        labelText: 'Specific Location (Optional)',
        hintText: 'e.g., Near Main Chowk, Behind School',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📸 Photos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 10),
          if (_selectedImages.isEmpty)
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Photos (Max 5)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          else
            Column(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _selectedImages.map((file) {
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.image, size: 40),
                        ),
                        Positioned(
                          top: -5,
                          right: -5,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedImages.remove(file);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                if (_selectedImages.length < 5)
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add),
                    label: const Text('Add More Photos'),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        final remaining = 5 - _selectedImages.length;
        _selectedImages.addAll(result.files.take(remaining));
      });
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submitIssue,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFFF6B6B),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Submit Report',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _submitIssue() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if different area requires photos
    final isDifferentDistrict =
        _locationOption == "Different Area" &&
        _selectedDistrict != currentUser?.location.district;

    if (isDifferentDistrict && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '📸 Photos are required when reporting outside your district',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Get issue location
      Location issueLocation;
      if (_locationOption == "My Own Area") {
        issueLocation = currentUser!.location;
      } else {
        issueLocation = Location(
          district: _selectedDistrict!,
          municipality: _selectedMunicipality!,
          ward: _selectedWard!,
          specificLocation: _specificLocationController.text.trim().isEmpty
              ? null
              : _specificLocationController.text.trim(),
        );
      }

      // Upload images
      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        for (var file in _selectedImages) {
          final url = await _storageService.uploadIssueImage(
            file,
            currentUser!.uid,
          );
          if (url != null) imageUrls.add(url);
        }
      }

      // Create issue
      final issue = IssueModel(
        issueId: '', // Will be set by service
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        reportedBy: currentUser!.uid,
        reporterName: currentUser!.name,
        reporterEmail: currentUser!.email,
        issueLocation: issueLocation,
        reporterRegisteredLocation: currentUser!.location,
        isReportedFromDifferentDistrict: isDifferentDistrict,
        status: IssueStatus.not_started,
        priority: _selectedPriority,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrls: imageUrls,
        specificLocation: _specificLocationController.text.trim().isEmpty
            ? null
            : _specificLocationController.text.trim(),
      );

      final issueId = await _issueService.createIssue(issue);

      if (issueId != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Issue reported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to create issue');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _specificLocationController.dispose();
    super.dispose();
  }
}

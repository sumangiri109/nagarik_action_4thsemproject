// lib/utils/validators.dart

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    return null;
  }

  // Phone number validation (Nepal format)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Nepal phone number: +977-9xxxxxxxxx or 98xxxxxxxx
    final phoneRegex = RegExp(r'^(\+977)?9[78]\d{8}$');
    
    if (!phoneRegex.hasMatch(cleanNumber)) {
      return 'Please enter a valid Nepal phone number';
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Dropdown validation
  static String? validateDropdown(dynamic value, String fieldName) {
    if (value == null) {
      return 'Please select $fieldName';
    }
    return null;
  }

  // Ward number validation
  static String? validateWardNumber(int? value) {
    if (value == null) {
      return 'Ward number is required';
    }
    
    if (value < 1 || value > 33) {
      return 'Ward number must be between 1 and 33';
    }
    
    return null;
  }

  // File validation
  static String? validateFile(dynamic file, String fileType) {
    if (file == null) {
      return '$fileType is required';
    }
    return null;
  }

  // Certificate validation (file extension)
  static String? validateCertificate(String? fileName) {
    if (fileName == null || fileName.isEmpty) {
      return 'Certificate is required';
    }
    
    final validExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
    final extension = fileName.split('.').last.toLowerCase();
    
    if (!validExtensions.contains(extension)) {
      return 'Please upload PDF, JPG, or PNG file';
    }
    
    return null;
  }

  // Optional field validation (min length if provided)
  static String? validateOptional(String? value, {int minLength = 0, int? maxLength}) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    if (value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    
    if (maxLength != null && value.length > maxLength) {
      return 'Must be less than $maxLength characters';
    }
    
    return null;
  }

  // Issue title validation
  static String? validateIssueTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    
    if (value.length < 10) {
      return 'Title must be at least 10 characters';
    }
    
    if (value.length > 100) {
      return 'Title must be less than 100 characters';
    }
    
    return null;
  }

  // Issue description validation
  static String? validateIssueDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }
    
    if (value.length < 20) {
      return 'Description must be at least 20 characters';
    }
    
    if (value.length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    
    return null;
  }

  // Comment validation
  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Comment cannot be empty';
    }
    
    if (value.length < 2) {
      return 'Comment must be at least 2 characters';
    }
    
    if (value.length > 500) {
      return 'Comment must be less than 500 characters';
    }
    
    return null;
  }
}
// lib/services/storage_service.dart (WEB VERSION)

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class StorageService {
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'gs://nagarik-action.appspot.com', // Use old bucket
  );

  // ============================================================
  // UPLOAD FILE FROM BYTES
  // ============================================================
  Future<String> uploadFileFromBytes({
    required Uint8List fileBytes,
    required String folderPath,
    required String fileName,
  }) async {
    try {
      final Reference ref = _storage.ref().child('$folderPath/$fileName');

      final metadata = SettableMetadata(contentType: _getContentType(fileName));

      final UploadTask uploadTask = ref.putData(fileBytes, metadata);

      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  // ============================================================
  // PROFILE IMAGE
  // ============================================================
  Future<String?> uploadProfileImageWeb({required String userId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      if (file.bytes == null) throw Exception('No file data');

      return await uploadFileFromBytes(
        fileBytes: file.bytes!,
        folderPath: 'users/$userId',
        fileName: 'profile.${file.extension ?? 'jpg'}',
      );
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  // ============================================================
  // GOVERNMENT CERTIFICATE
  // ============================================================
  Future<String?> uploadGovernmentCertificateWeb({
    required String userId,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      if (file.bytes == null) throw Exception('No file data');

      return await uploadFileFromBytes(
        fileBytes: file.bytes!,
        folderPath: 'users/$userId/documents',
        fileName: 'certificate.${file.extension ?? 'pdf'}',
      );
    } catch (e) {
      print('Error uploading certificate: $e');
      rethrow;
    }
  }

  // ============================================================
  // ISSUE IMAGES (MULTIPLE)
  // ============================================================
  Future<List<String>> uploadIssueImagesWeb({required String issueId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) return [];

      List<String> urls = [];

      for (int i = 0; i < result.files.length; i++) {
        final file = result.files[i];
        if (file.bytes == null) continue;

        final url = await uploadFileFromBytes(
          fileBytes: file.bytes!,
          folderPath: 'issues/$issueId',
          fileName: 'image_$i.${file.extension ?? 'jpg'}',
        );
        urls.add(url);
      }

      return urls;
    } catch (e) {
      print('Error uploading issue images: $e');
      rethrow;
    }
  }

  // ============================================================
  // SINGLE ISSUE IMAGE (USED IN REPORT SCREEN)
  // ============================================================
  Future<String?> uploadIssueImage(PlatformFile file, String issueId) async {
    try {
      if (file.bytes == null) throw Exception('No file data');

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      return await uploadFileFromBytes(
        fileBytes: file.bytes!,
        folderPath: 'issues/$issueId',
        fileName: 'issue_${timestamp}_${file.name}',
      );
    } catch (e) {
      print('Error uploading single issue image: $e');
      return null;
    }
  }

  // ============================================================
  // ISSUE ATTACHMENT
  // ============================================================
  Future<String?> uploadIssueAttachmentWeb({required String issueId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return null;

      final file = result.files.first;
      if (file.bytes == null) throw Exception('No file data');

      return await uploadFileFromBytes(
        fileBytes: file.bytes!,
        folderPath: 'issues/$issueId/attachments',
        fileName: file.name,
      );
    } catch (e) {
      print('Error uploading issue attachment: $e');
      rethrow;
    }
  }

  // ============================================================
  // DELETE FILES
  // ============================================================
  Future<void> deleteFile(String fileUrl) async {
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }

  Future<void> deleteFiles(List<String> fileUrls) async {
    try {
      for (String url in fileUrls) {
        await deleteFile(url);
      }
    } catch (e) {
      print('Error deleting files: $e');
      rethrow;
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================
  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  // ============================================================
  // UPLOAD WITH PROGRESS (WEB)
  // ============================================================
  Stream<double> uploadFileWithProgressWeb({
    required Uint8List fileBytes,
    required String folderPath,
    required String fileName,
  }) {
    try {
      final Reference ref = _storage.ref().child('$folderPath/$fileName');
      final metadata = SettableMetadata(contentType: _getContentType(fileName));
      final UploadTask uploadTask = ref.putData(fileBytes, metadata);

      return uploadTask.snapshotEvents.map((TaskSnapshot snapshot) {
        return snapshot.bytesTransferred / snapshot.totalBytes;
      });
    } catch (e) {
      print('Error uploading file with progress: $e');
      return Stream.error(e);
    }
  }
}

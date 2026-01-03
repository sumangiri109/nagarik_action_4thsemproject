// lib/services/storage_service.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ============================================================
  // UPLOAD FILES
  // ============================================================

  /// Upload file and return download URL
  Future<String> uploadFile({
    required File file,
    required String folderPath,
    String? fileName,
  }) async {
    try {
      // Generate file name if not provided
      final String fileNameToUse = fileName ?? 
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';

      // Create reference
      final Reference ref = _storage.ref().child('$folderPath/$fileNameToUse');

      // Upload file
      final UploadTask uploadTask = ref.putFile(file);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }

  /// Upload profile image
  Future<String> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    return await uploadFile(
      file: file,
      folderPath: 'users/$userId',
      fileName: 'profile.jpg',
    );
  }

  /// Upload government certificate
  Future<String> uploadGovernmentCertificate({
    required File file,
    required String userId,
  }) async {
    final String extension = path.extension(file.path);
    return await uploadFile(
      file: file,
      folderPath: 'users/$userId/documents',
      fileName: 'certificate$extension',
    );
  }

  /// Upload issue images
  Future<List<String>> uploadIssueImages({
    required List<File> files,
    required String issueId,
  }) async {
    try {
      List<String> urls = [];

      for (int i = 0; i < files.length; i++) {
        final url = await uploadFile(
          file: files[i],
          folderPath: 'issues/$issueId',
          fileName: 'image_$i.jpg',
        );
        urls.add(url);
      }

      return urls;
    } catch (e) {
      print('Error uploading issue images: $e');
      rethrow;
    }
  }

  /// Upload issue attachment
  Future<String> uploadIssueAttachment({
    required File file,
    required String issueId,
  }) async {
    return await uploadFile(
      file: file,
      folderPath: 'issues/$issueId/attachments',
    );
  }

  /// Upload status update attachment
  Future<String> uploadStatusUpdateAttachment({
    required File file,
    required String issueId,
    required String updateId,
  }) async {
    return await uploadFile(
      file: file,
      folderPath: 'statusUpdates/$issueId/$updateId',
    );
  }

  // ============================================================
  // DELETE FILES
  // ============================================================

  /// Delete file by URL
  Future<void> deleteFile(String fileUrl) async {
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }

  /// Delete multiple files
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

  /// Delete entire folder
  Future<void> deleteFolder(String folderPath) async {
    try {
      final ListResult result = await _storage.ref(folderPath).listAll();

      // Delete all files in folder
      for (Reference ref in result.items) {
        await ref.delete();
      }

      // Recursively delete subfolders
      for (Reference ref in result.prefixes) {
        await deleteFolder(ref.fullPath);
      }
    } catch (e) {
      print('Error deleting folder: $e');
      rethrow;
    }
  }

  // ============================================================
  // GET FILE METADATA
  // ============================================================

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String fileUrl) async {
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      return await ref.getMetadata();
    } catch (e) {
      print('Error getting file metadata: $e');
      rethrow;
    }
  }

  /// Get file size in bytes
  Future<int?> getFileSize(String fileUrl) async {
    try {
      final metadata = await getFileMetadata(fileUrl);
      return metadata.size;
    } catch (e) {
      print('Error getting file size: $e');
      return null;
    }
  }

  // ============================================================
  // UPLOAD WITH PROGRESS
  // ============================================================

  /// Upload file with progress tracking
  Stream<double> uploadFileWithProgress({
    required File file,
    required String folderPath,
    String? fileName,
  }) {
    try {
      final String fileNameToUse = fileName ?? 
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';

      final Reference ref = _storage.ref().child('$folderPath/$fileNameToUse');
      final UploadTask uploadTask = ref.putFile(file);

      return uploadTask.snapshotEvents.map((TaskSnapshot snapshot) {
        return snapshot.bytesTransferred / snapshot.totalBytes;
      });
    } catch (e) {
      print('Error uploading file with progress: $e');
      return Stream.error(e);
    }
  }
}
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _profilePhotosDir = 'profile_photos';

  // Get the directory for storing profile photos
  static Future<Directory> _getProfilePhotosDirectory() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory(path.join(appDir.path, _profilePhotosDir));

      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      return profileDir;
    } catch (e) {
      // Fallback: use temporary directory if path_provider fails
      // This can happen if the app needs to be rebuilt after adding the plugin
      throw Exception(
        'Failed to get storage directory. Please restart the app. Error: $e',
      );
    }
  }

  // Save profile photo locally
  static Future<String> saveProfilePhoto({
    required String uid,
    required Uint8List bytes,
    required String extension,
  }) async {
    try {
      final profileDir = await _getProfilePhotosDirectory();

      // Use UID as filename to avoid conflicts (each user has one photo)
      // If extension is invalid, default to jpg
      final validExtension =
          extension.isNotEmpty &&
              RegExp(r'^[a-z0-9]+$').hasMatch(extension.toLowerCase())
          ? extension.toLowerCase()
          : 'jpg';

      final fileName = '$uid.$validExtension';
      final filePath = path.join(profileDir.path, fileName);
      final file = File(filePath);

      // Delete old photo if exists (to avoid conflicts)
      if (await file.exists()) {
        await file.delete();
      }

      // Write new photo
      await file.writeAsBytes(bytes);

      // Return the file path
      return filePath;
    } catch (e) {
      throw Exception('Failed to save photo locally: $e');
    }
  }

  // Get profile photo file path
  static Future<File?> getProfilePhotoFile(String uid) async {
    try {
      final profileDir = await _getProfilePhotosDirectory();

      // Try common image extensions
      final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

      for (final ext in extensions) {
        final filePath = path.join(profileDir.path, '$uid.$ext');
        final file = File(filePath);

        if (await file.exists()) {
          return file;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Delete profile photo
  static Future<void> deleteProfilePhoto(String uid) async {
    try {
      final file = await getProfilePhotoFile(uid);
      if (file != null && await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore errors when deleting
    }
  }

  // Check if profile photo exists
  static Future<bool> profilePhotoExists(String uid) async {
    final file = await getProfilePhotoFile(uid);
    return file != null && await file.exists();
  }

  // Onboarding completion
  static const String _onboardingKey = 'onboarding_completed';

  static Future<void> setOnboardingCompleted(bool completed) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(path.join(appDir.path, '$_onboardingKey.txt'));
      await file.writeAsString(completed.toString());
    } catch (e) {
      // Ignore errors
    }
  }

  static Future<bool> isOnboardingCompleted() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(path.join(appDir.path, '$_onboardingKey.txt'));
      log('Checking onboarding file at: ${file.path}');
      if (await file.exists()) {
        final content = await file.readAsString();
        log('Onboarding file content: $content');
        return content.trim() == 'true';
      }
      log('Onboarding file does not exist - returning false');
      return false;
    } catch (e) {
      log('Error checking onboarding: $e');
      return false;
    }
  }

  // Reset onboarding (useful for testing)
  static Future<void> resetOnboarding() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final file = File(path.join(appDir.path, '$_onboardingKey.txt'));
      log('Resetting onboarding file at: ${file.path}');
      if (await file.exists()) {
        await file.delete();
        log('Onboarding file deleted successfully');
      } else {
        log('Onboarding file does not exist - nothing to delete');
      }
    } catch (e) {
      log('Error resetting onboarding: $e');
    }
  }
}

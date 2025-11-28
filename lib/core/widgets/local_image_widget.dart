import 'dart:io';
import 'package:final_project/core/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class LocalImageWidget extends StatelessWidget {
  const LocalImageWidget({
    super.key,
    required this.photoUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  final String? photoUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null || photoUrl!.isEmpty) {
      return placeholder ?? const SizedBox.shrink();
    }

    // Check if it's a local photo (starts with 'local:')
    if (photoUrl!.startsWith('local:')) {
      final uid = photoUrl!.substring(6); // Remove 'local:' prefix
      return FutureBuilder<File?>(
        future: LocalStorageService.getProfilePhotoFile(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return placeholder ?? const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Image.file(
              snapshot.data!,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return errorWidget ?? placeholder ?? const Icon(Icons.person);
              },
            );
          }

          return errorWidget ?? placeholder ?? const Icon(Icons.person);
        },
      );
    }

    // If it's a network URL (for backward compatibility)
    return Image.network(
      photoUrl!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? const CircularProgressIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? placeholder ?? const Icon(Icons.person);
      },
    );
  }
}






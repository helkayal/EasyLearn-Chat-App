import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_secrets.dart';

class SupabaseService {
  // Keys are loaded from a gitignored secrets file so the IDE runs
  // without needing any special --dart-define parameters.
  static const String _supabaseUrl = SupabaseSecrets.supabaseUrl;
  static const String _supabaseAnonKey = SupabaseSecrets.supabaseAnonKey;
  static const String _serviceRoleKey = SupabaseSecrets.serviceRoleKey;

  static Future<void> initialize() async {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }

  /// Uploads raw [bytes] to the `GroupChatImages` bucket.
  /// Recommended over the File-based version — avoids iOS temp path issues.
  static Future<String> uploadGroupImageBytes({
    required Uint8List bytes,
    required String chatId,
  }) async {
    try {
      final adminClient = SupabaseClient(_supabaseUrl, _serviceRoleKey);
      final path = '$chatId/group.jpg';

      await adminClient.storage
          .from('GroupChatImages')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl = adminClient.storage
          .from('GroupChatImages')
          .getPublicUrl(path);
      await adminClient.dispose();

      return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads [imageFile] to the `avatars` bucket under `{userId}/profile.jpg`
  /// and returns the public URL of the uploaded image.
  static Future<String> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      // Use a dedicated client with the service role key so
      // RLS policies on storage.objects don't block the upload.
      final adminClient = SupabaseClient(_supabaseUrl, _serviceRoleKey);
      final path = '$userId/profile.jpg';

      await adminClient.storage
          .from('avatars')
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl = adminClient.storage.from('avatars').getPublicUrl(path);

      await adminClient.dispose();

      // Cache-busting timestamp so the app always fetches the latest image
      return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e, stack) {
      // ignore: avoid_print
      print('[SupabaseService] Upload error: $e\n$stack');
      rethrow;
    }
  }

  /// Uploads [imageFile] to the `GroupChatImages` bucket under `{chatId}/group.jpg`
  /// and returns the public URL.
  static Future<String> uploadGroupImage({
    required File imageFile,
    required String chatId,
  }) async {
    try {
      final adminClient = SupabaseClient(_supabaseUrl, _serviceRoleKey);
      final path = '$chatId/group.jpg';

      await adminClient.storage
          .from('GroupChatImages')
          .upload(
            path,
            imageFile,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final publicUrl = adminClient.storage
          .from('GroupChatImages')
          .getPublicUrl(path);

      await adminClient.dispose();

      return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e, stack) {
      // ignore: avoid_print
      print('[SupabaseService] uploadGroupImage error: $e\n$stack');
      rethrow;
    }
  }

  /// Deletes a previously uploaded group image from Supabase Storage.
  static Future<void> deleteGroupImage({required String chatId}) async {
    try {
      final adminClient = SupabaseClient(_supabaseUrl, _serviceRoleKey);
      await adminClient.storage.from('GroupChatImages').remove([
        '$chatId/group.jpg',
      ]);
      await adminClient.dispose();
    } catch (e) {
      // ignore: avoid_print
      print('[SupabaseService] deleteGroupImage error (non-fatal): $e');
    }
  }
}

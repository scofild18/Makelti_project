import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:Makelti/services/cloudinary_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SupabaseClient supabase;
  final ImagePicker _imagePicker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  ProfileCubit({
    required this.supabase,
  }) : super(ProfileState());

  String get baseUrl =>
      dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';

  /* ===================== LOAD PROFILE ===================== */

  Future<void> loadUserProfile() async {
    print('\n🔵 ========== LOAD USER PROFILE START ==========');
    
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('❌ User not authenticated');
      emit(state.copyWith(errorMessage: 'User not authenticated'));
      return;
    }

    print('👤 User ID: $userId');
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }

      print('🔑 Session token: ${session.accessToken.substring(0, 20)}...');
      print('🌐 Calling: $baseUrl/api/v1/users/$userId');

      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/users/$userId'),
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Profile loaded successfully');
        print('   - Profile Picture PublicId: ${data['profile_picture']}');
        
        emit(state.copyWith(
          userId: userId,
          name: data['full_name'] ?? '',
          email: data['email'] ?? supabase.auth.currentUser?.email ?? '',
          phone: data['phone'] ?? '',
          profilePicturePublicId: data['profile_picture'],
          profilePictureVersion: DateTime.now().millisecondsSinceEpoch.toString(),  // ✅ Force reload
          isLoading: false,
        ));
        
        print('🟢 State updated with profile data');
      } else if (response.statusCode == 404) {
        print('⚠️ User not found in backend (404)');
        emit(state.copyWith(
          userId: userId,
          name: '',
          email: supabase.auth.currentUser?.email ?? '',
          phone: '',
          isLoading: false,
        ));
      } else {
        throw Exception('Failed to load profile (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Load profile error: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading profile: $e',
      ));
    }
    
    print('🔵 ========== LOAD USER PROFILE END ==========\n');
  }

  /* ===================== IMAGE UPLOAD ===================== */

  Future<void> updateProfilePicture() async {
    print('\n📸 User selected: Gallery');
    await _pickAndUploadImage(ImageSource.gallery);
  }

  Future<void> takeProfilePicture() async {
    print('\n📸 User selected: Camera');
    await _pickAndUploadImage(ImageSource.camera);
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    print('\n🟣 ========== IMAGE UPLOAD START ==========');
    
    try {
      print('📱 Opening image picker (source: $source)...');
      
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image == null) {
        print('⚠️ User cancelled image picker');
        print('🟣 ========== IMAGE UPLOAD CANCELLED ==========\n');
        return;
      }

      print('✅ Image selected: ${image.path}');
      print('📏 Image size: ${await image.length()} bytes');

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final session = supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }

      print('👤 Uploading for user: $userId');
      emit(state.copyWith(isUploadingImage: true, errorMessage: null));

      final imageFile = File(image.path);
      
      print('☁️ Starting SIGNED upload via backend...');
      
      // ✅ Upload via backend (signed)
      final uploadResult = await _cloudinaryService.uploadProfilePicture(
        imageFile,
        session.accessToken,  // Pass JWT token
      );

      print('✅ Signed upload SUCCESS!');
      print('🆔 Returned publicId: "${uploadResult['publicId']}"');
      print('🔢 Version: ${uploadResult['version']}');

      // Update state with public_id AND version
      emit(state.copyWith(
        profilePicturePublicId: uploadResult['publicId'],
        profilePictureVersion: uploadResult['version'],  // ✅ Store version for cache busting
        isUploadingImage: false,
      ));

      print('🟢 State updated with new publicId and version');
      print('💾 Now saving to backend...');
      
      // Save to backend
      await _saveProfile(validate: false);
      
    } catch (e, stackTrace) {
      print('❌ Upload error: $e');
      print('📚 Stack trace: $stackTrace');
      emit(state.copyWith(
        isUploadingImage: false,
        errorMessage: 'Failed to upload image: $e',
      ));
    }
    
    print('🟣 ========== IMAGE UPLOAD END ==========\n');
  }

  /* ===================== FIELD UPDATES ===================== */

  void updateName(String name) {
    print('✏️ Name updated to: "$name"');
    emit(state.copyWith(name: name, errorMessage: null));
  }

  void updateEmail(String email) {
    print('✏️ Email updated to: "$email"');
    emit(state.copyWith(email: email, errorMessage: null));
  }

  void updatePhone(String phone) {
    print('✏️ Phone updated to: "$phone"');
    emit(state.copyWith(phone: phone, errorMessage: null));
  }

  /* ===================== SAVE PROFILE ===================== */

  bool _validateFields() {
    print('\n🔍 Validating fields...');
    
    if (state.name == null || state.name!.trim().isEmpty) {
      print('❌ Validation failed: Name is empty');
      emit(state.copyWith(errorMessage: 'Name cannot be empty'));
      return false;
    }
    
    if (state.phone == null || state.phone!.trim().isEmpty) {
      print('❌ Validation failed: Phone is empty');
      emit(state.copyWith(errorMessage: 'Phone cannot be empty'));
      return false;
    }
    
    print('✅ Validation passed');
    return true;
  }

  Future<void> saveProfile() async {
    print('\n💾 User clicked Save button');
    await _saveProfile(validate: true);
  }

  Future<void> _saveProfile({required bool validate}) async {
    print('\n🟡 ========== SAVE PROFILE START ==========');
    print('🔧 Validate: $validate');
    
    if (validate && !_validateFields()) {
      print('🟡 ========== SAVE PROFILE ABORTED (validation failed) ==========\n');
      return;
    }

    final userId = state.userId ?? supabase.auth.currentUser?.id;
    if (userId == null) {
      print('❌ User not authenticated');
      emit(state.copyWith(errorMessage: 'User not authenticated'));
      return;
    }

    print('👤 Saving for user: $userId');
    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      final session = supabase.auth.currentSession;
      if (session == null) {
        throw Exception('No active session');
      }

      final updateData = {
        'full_name': state.name,
        'phone': state.phone,
        'profile_picture': state.profilePicturePublicId,
      };

      print('📦 Data to send:');
      print('   - full_name: "${updateData['full_name']}"');
      print('   - phone: "${updateData['phone']}"');
      print('   - profile_picture: "${updateData['profile_picture']}"');
      print('🌐 Calling: PUT $baseUrl/api/v1/users/$userId');

      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/users/$userId'),
        headers: {
          'Authorization': 'Bearer ${session.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode(updateData),
      );

      print('📥 Backend response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Backend save SUCCESS!');
        print('   - profile_picture: ${data['profile_picture']}');
        
        emit(state.copyWith(
          name: data['full_name'],
          phone: data['phone'],
          profilePicturePublicId: data['profile_picture'],
          isSaving: false,
          successMessage: 'Profil mis à jour avec succès',
        ));
        
        print('🟢 State updated with saved data');
        print('✨ Success message set');
      } else {
        print('❌ Backend returned error status: ${response.statusCode}');
        print('📄 Error body: ${response.body}');
        throw Exception('Failed to save profile (${response.statusCode}): ${response.body}');
      }
    } catch (e, stackTrace) {
      print('❌ Save error: $e');
      print('📚 Stack trace: $stackTrace');
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Error saving profile: $e',
      ));
    }
    
    print('🟡 ========== SAVE PROFILE END ==========\n');
  }

  /* ===================== MESSAGES ===================== */

  void clearMessages() {
    print('🧹 Clearing success/error messages');
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }
}
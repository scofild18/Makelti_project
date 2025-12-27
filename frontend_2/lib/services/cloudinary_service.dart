import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  String get baseUrl => dotenv.env['BACKEND_URL'] ?? 'http://localhost:8000';

  /// Upload profile picture via backend (SIGNED upload)
  /// This is more secure as the API secret stays on the backend
  Future<Map<String, String>> uploadProfilePicture(
    File imageFile,
    String token,
  ) async {
    print('\n☁️ ========== SIGNED UPLOAD START ==========');
    
    try {
      final fileName = imageFile.path.split('/').last;
      final fileSize = await imageFile.length();
      
      print('📁 File name: $fileName');
      print('📏 File size: $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');
      
      // Create multipart request
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      print('🌐 Uploading via backend: $baseUrl/api/v1/cloudinary/upload/profile-picture');
      print('🔑 Using JWT authentication');

      // Upload through YOUR backend (signed)
      final response = await _dio.post(
        '$baseUrl/api/v1/cloudinary/upload/profile-picture',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (sent, total) {
          final progress = (sent / total * 100).toStringAsFixed(1);
          print('📤 Upload progress: $progress% ($sent/$total bytes)');
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        print('✅ Upload successful!');
        print('   🆔 Public ID: ${data['public_id']}');
        print('   🔗 Secure URL: ${data['secure_url']}');
        print('   📐 Dimensions: ${data['width']}x${data['height']}');
        print('   📦 Format: ${data['format']}');
        print('   🔢 Version: ${data['version']}');
        print('☁️ ========== SIGNED UPLOAD SUCCESS ==========\n');
        
        return {
          'publicId': data['public_id'] as String,
          'version': data['version'].toString(),
          'secureUrl': data['secure_url'] as String,
        };
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
      
    } on DioException catch (e) {
      print('❌ DioException occurred!');
      print('   Type: ${e.type}');
      print('   Message: ${e.message}');
      print('   Response: ${e.response?.data}');
      print('   Status Code: ${e.response?.statusCode}');
      print('☁️ ========== SIGNED UPLOAD FAILED ==========\n');
      
      final errorMessage = e.response?.data?['detail'] ?? e.message ?? 'Upload failed';
      throw Exception(errorMessage);
      
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print('📚 Stack trace: $stackTrace');
      print('☁️ ========== SIGNED UPLOAD FAILED ==========\n');
      throw Exception('Unexpected error during upload: $e');
    }
  }

  /// Generate optimized delivery URL
  String getOptimizedUrl(String publicId, {String? version}) {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    if (cloudName == null || cloudName.isEmpty) {
      throw Exception('CLOUDINARY_CLOUD_NAME is missing in .env');
    }
    
    // Add version to URL to prevent caching issues
    final versionParam = version != null ? 'v$version/' : '';
    
    final url = 'https://res.cloudinary.com/$cloudName/image/upload/'
        'c_fill,g_face,h_400,w_400,q_auto,f_auto/$versionParam$publicId';
    
    print('🔗 Generated optimized URL: $url');
    return url;
  }

  /// Generate original (untransformed) image URL
  String getOriginalUrl(String publicId, {String? version}) {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    if (cloudName == null || cloudName.isEmpty) {
      throw Exception('CLOUDINARY_CLOUD_NAME is missing in .env');
    }
    
    final versionParam = version != null ? 'v$version/' : '';
    final url = 'https://res.cloudinary.com/$cloudName/image/upload/$versionParam$publicId';
    
    print('🔗 Generated original URL: $url');
    return url;
  }
}
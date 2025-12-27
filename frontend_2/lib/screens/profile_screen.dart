// lib/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:Makelti/logic/cubit/profile/profile_cubit.dart';
import 'package:Makelti/logic/cubit/profile/profile_state.dart';
import 'package:Makelti/services/cloudinary_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  void initState() {
    super.initState();

    // Load user profile when screen opens
    context.read<ProfileCubit>().loadUserProfile();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileState state) {
    if (_nameController.text != (state.name ?? '')) {
      _nameController.text = state.name ?? '';
    }
    if (_emailController.text != (state.email ?? '')) {
      _emailController.text = state.email ?? '';
    }
    if (_phoneController.text != (state.phone ?? '')) {
      _phoneController.text = state.phone ?? '';
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFFFF6B35),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ProfileCubit>().updateProfilePicture();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFFFF6B35),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ProfileCubit>().takeProfilePicture();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () => Navigator.pop(bottomSheetContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (!mounted) return;

        // Sync controllers when data loads or saves
        if (!state.isLoading && !state.isSaving && !state.isUploadingImage) {
          _syncControllers(state);
        }

        // Show success message and clear immediately
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Critical: Clear message immediately to prevent re-showing
          context.read<ProfileCubit>().clearMessages();
        }

        // Show error message and clear immediately
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Critical: Clear message immediately to prevent re-showing
          context.read<ProfileCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        // Show loading spinner while fetching profile
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
               
                  if (context.canPop()) {
                    context.pop();  // If came from settings (push)
                  } else {
                    context.go('/settings');  // If came from home (go) - fallback to settings
                  }
                },
              ),
              title: const Text(
                'Personal Information',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B35),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Personal Information',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Picture Section
                Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFE8E0),
                      ),
                      child: _buildProfileImage(state),
                    ),
                    // Camera button
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: state.isUploadingImage
                            ? null
                            : () => _showImageSourceOptions(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: state.isUploadingImage
                                ? Colors.grey
                                : const Color(0xFFFF6B35),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Full Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  enabled: !state.isSaving,
                ),

                const SizedBox(height: 20),

                // Email Field (Read-only)
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  helpText: 'Email cannot be changed',
                ),

                const SizedBox(height: 20),

                // Phone Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  enabled: !state.isSaving,
                ),

                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isSaving
                        ? null
                        : () {
                            final cubit = context.read<ProfileCubit>();
                            cubit.updateName(_nameController.text.trim());
                            cubit.updatePhone(_phoneController.text.trim());
                            cubit.saveProfile();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                      disabledBackgroundColor: Colors.grey[400],
                      elevation: 2,
                    ),
                    child: state.isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Enregistrer',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build profile image with proper loading and error handling
  Widget _buildProfileImage(ProfileState state) {
    // Show loading spinner while uploading
    if (state.isUploadingImage) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFFF6B35),
              strokeWidth: 3,
            ),
            SizedBox(height: 8),
            Text(
              'Uploading...',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFFF6B35),
              ),
            ),
          ],
        ),
      );
    }

    // Show image if publicId exists
    if (state.profilePicturePublicId != null &&
        state.profilePicturePublicId!.isNotEmpty) {
      final imageUrl = _cloudinaryService.getOptimizedUrl(
        state.profilePicturePublicId!,
        version: state.profilePictureVersion,
      );

      print('🖼️ Displaying image from URL: $imageUrl');

      return ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              print('✅ Image loaded successfully');
              return child;
            }
            
            final progress = loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null;

            print('⏳ Loading image: ${(progress ?? 0) * 100}%');

            return Center(
              child: CircularProgressIndicator(
                value: progress,
                color: const Color(0xFFFF6B35),
                strokeWidth: 3,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error loading image: $error');
            print('🔗 Failed URL: $imageUrl');
            return const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFFFF6B35),
            );
          },
        ),
      );
    }

    // Default icon when no image
    return const Icon(
      Icons.person,
      size: 60,
      color: Color(0xFFFF6B35),
    );
  }

  /// Build text field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    bool enabled = true,
    String? helpText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          style: TextStyle(
            color: readOnly ? Colors.grey[600] : Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: readOnly
                  ? Colors.grey
                  : enabled
                      ? const Color(0xFFE97844)
                      : Colors.grey,
            ),
            filled: true,
            fillColor: readOnly
                ? Colors.grey[100]
                : enabled
                    ? Colors.white
                    : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE97844),
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            helperText: helpText,
            helperStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
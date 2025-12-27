class ProfileState {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? profilePicturePublicId;
  final String? profilePictureVersion;  
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingImage;
  final String? errorMessage;
  final String? successMessage;

  ProfileState({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.profilePicturePublicId,
    this.profilePictureVersion,  
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingImage = false,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? profilePicturePublicId,
    String? profilePictureVersion,  // ✅ Add this
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingImage,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePicturePublicId: profilePicturePublicId ?? this.profilePicturePublicId,
      profilePictureVersion: profilePictureVersion ?? this.profilePictureVersion,  // ✅ Add this
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
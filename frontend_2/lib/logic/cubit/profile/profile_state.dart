class ProfileState {
  final String name;
  final String email;
  final String phone;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  ProfileState({
    this.name = 'Jean Dupont',
    this.email = 'jean.dupont@example.com',
    this.phone = '+33 6 12 34 56 78',
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}


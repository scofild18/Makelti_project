import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  void updateName(String name) {
    emit(state.copyWith(name: name, errorMessage: null));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email, errorMessage: null));
  }

  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone, errorMessage: null));
  }

  bool _validateFields() {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Name cannot be empty'));
      return false;
    }
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Email cannot be empty'));
      return false;
    }
    if (!state.email.contains('@')) {
      emit(state.copyWith(errorMessage: 'Please enter a valid email'));
      return false;
    }
    if (state.phone.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Phone cannot be empty'));
      return false;
    }
    return true;
  }

  Future<void> saveProfile() async {
    if (!_validateFields()) {
      return;
    }

    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      // Simulate API call - Replace with actual Supabase/Backend call
      await Future.delayed(const Duration(seconds: 1));

      emit(state.copyWith(
        isSaving: false,
        successMessage: 'Profil mis à jour avec succès',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Error saving profile: $e',
        successMessage: null,
      ));
    }
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}


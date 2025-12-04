import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void toggleNotifications(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
    // Here you could save to Supabase or local storage
    // await Supabase.instance.client.from('user_settings').upsert({
    //   'user_id': userId,
    //   'notifications_enabled': value,
    // });
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoggingOut: true, errorMessage: null));

    try {
      await Supabase.instance.client.auth.signOut();
      emit(state.copyWith(
        isLoggingOut: false,
        successMessage: 'Logged out successfully',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoggingOut: false,
        errorMessage: 'Error logging out: $e',
        successMessage: null,
      ));
    }
  }

  void clearMessages() {
    emit(state.copyWith(errorMessage: null, successMessage: null));
  }
}


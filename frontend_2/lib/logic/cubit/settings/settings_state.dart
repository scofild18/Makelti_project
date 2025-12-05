class SettingsState {
  final bool notificationsEnabled;
  final bool isLoggingOut;
  final String? errorMessage;
  final String? successMessage;

  SettingsState({
    this.notificationsEnabled = true,
    this.isLoggingOut = false,
    this.errorMessage,
    this.successMessage,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? isLoggingOut,
    String? errorMessage,
    String? successMessage,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}


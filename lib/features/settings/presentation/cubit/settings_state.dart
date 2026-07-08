import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String username;
  final String joinDate;
  final bool notificationEnabled;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const SettingsState({
    required this.username,
    required this.joinDate,
    required this.notificationEnabled,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  SettingsState copyWith({
    String? username,
    String? joinDate,
    bool? notificationEnabled,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return SettingsState(
      username: username ?? this.username,
      joinDate: joinDate ?? this.joinDate,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        username,
        joinDate,
        notificationEnabled,
        isLoading,
        successMessage,
        errorMessage,
      ];
}

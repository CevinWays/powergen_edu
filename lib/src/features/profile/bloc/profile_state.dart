abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String fullName;
  final String email;
  final String nis;
  final String className;

  ProfileLoaded({
    required this.fullName,
    required this.email,
    required this.nis,
    required this.className,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class LogoutSuccess extends ProfileState {}

abstract class EditProfileEvent {}

class UpdateProfile extends EditProfileEvent {
  final String fullName;

  UpdateProfile({required this.fullName});
}

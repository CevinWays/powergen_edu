import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      // TODO: Implement load profile logic
      emit(ProfileLoaded(
        fullName: 'John Doe',
        email: 'john.doe@email.com',
        nis: '2024001',
        className: 'Power Generation - Class A',
      ));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Implement logout logic
      emit(LogoutSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

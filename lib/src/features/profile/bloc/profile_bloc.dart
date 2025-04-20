import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String fullName = prefs.getString('userName') ?? '';
      final String email = prefs.getString('email') ?? '';
      final String nis = prefs.getString('nis') ?? '';
      final String className = prefs.getString('className') ?? '';

      emit(ProfileLoaded(
        fullName: fullName,
        email: email,
        nis: nis,
        className: className,
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
      // Sign out from Firebase
      await _auth.signOut();

      // Clear SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      emit(LogoutSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  final String nis;
  final String namaLengkap;
  // final String kelas;

  const RegisterSubmitted({
    required this.email,
    required this.password,
    required this.username,
    required this.nis,
    required this.namaLengkap,
    // required this.kelas,
  });

  @override
  List<Object?> get props => [
        email, password, username, nis, namaLengkap,
        // kelas
      ];
}

// States
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final UserCredential userCredential;

  const RegisterSuccess(this.userCredential);

  @override
  List<Object?> get props => [userCredential];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (userCredential.user != null) {
        final idToken = await userCredential.user!.getIdToken() ?? '';
        final isTeacher = event.nis.length == 16 ? true : false;
        await prefs.setString('token', idToken);
        await prefs.setString('email', event.email);
        await prefs.setString('userName', event.username);
        await prefs.setString('nis', event.nis);
        await prefs.setString('fullName', event.namaLengkap);
        await prefs.setString('uid', userCredential.user?.uid ?? '');
        await prefs.setBool('isTeacher', isTeacher);
        // Store additional user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': event.username,
          'nis': event.nis,
          'fullName': event.namaLengkap,
          // 'kelas': event.kelas,
          'email': event.email,
          'createdAt': DateTime.now(),
          'uid': userCredential.user?.uid ?? '',
          'isTeacher': isTeacher,
          'total_progress': 0,
        });

        emit(RegisterSuccess(userCredential));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      }
      emit(RegisterFailure(errorMessage));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}

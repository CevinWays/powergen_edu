import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginCheckToken extends LoginEvent {}

// States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserCredential userCredential;
  final Map<String, dynamic>? userData;
  final bool isTeacher;
  final bool isDonePretest;

  const LoginSuccess(
      {required this.userCredential,
      this.userData,
      this.isTeacher = false,
      this.isDonePretest = false});

  @override
  List<Object?> get props => [userCredential, userData];
}

class LoginCheckTokenSuccess extends LoginState {
  final bool isDonePretest;

  const LoginCheckTokenSuccess({required this.isDonePretest});
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginCheckToken>(_onLoginCheckToken);
  }

  Future<void> _onLoginCheckToken(
    LoginCheckToken event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final isDonePretest = prefs.getBool('isDonePretest') ?? false;
    if (token != null && token.isNotEmpty) {
      emit(LoginCheckTokenSuccess(isDonePretest: isDonePretest));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Fetch user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      final userData = userDoc.data();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final idToken = await userCredential.user!.getIdToken() ?? '';
      await prefs.setString('token', idToken);
      await prefs.setString('email', userCredential.user?.email ?? '');
      await prefs.setString('uid', userCredential.user?.uid ?? '');
      await prefs.setString('nis', userData?['nis'] ?? '');
      await prefs.setString('fullName', userData?['fullName'] ?? '');
      await prefs.setInt('totalProgress', userData?['total_progress'] ?? 0);
      await prefs.setString('fullName', userData?['fullName'] ?? '');
      await prefs.setBool(
          'isDonePretest', userData?['is_done_pretest'] ?? false);

      // Store additional user data from Firestore if available
      if (userData != null) {
        await prefs.setString('userName', userData['username'] ?? '');
        // You can store more user data from Firestore here
      }

      bool isTeacher = false;
      final nis = userData?['nis'] ?? '';
      if (nis.length == 16) {
        isTeacher = true;
      }
      await prefs.setBool('isTeacher', isTeacher);
      final isDonePretest = prefs.getBool('isDonePretest') ?? false;
      final pointPretest = prefs.getInt('pointPretest') ?? 0;

      emit(LoginSuccess(
        userCredential: userCredential,
        userData: userData,
        isTeacher: isTeacher,
        isDonePretest: isDonePretest,
      ));
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      }
      emit(LoginFailure(errorMessage));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}

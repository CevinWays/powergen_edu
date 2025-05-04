import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

class SplashCheckToken extends SplashEvent {}

// States
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final String token;
  final String email;
  final String userName;
  final String nis;
  final bool isTeacher;
  final bool isDonePretest;

  const SplashAuthenticated({
    required this.token,
    required this.email,
    required this.userName,
    required this.nis,
    this.isTeacher = false,
    this.isDonePretest = false,
  });

  @override
  List<Object?> get props => [token, email, userName];
}

class SplashUnauthenticated extends SplashState {}

// Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashCheckToken>(_onSplashCheckToken);
  }

  Future<void> _onSplashCheckToken(
    SplashCheckToken event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    try {
      emit(SplashLoading());
      await Future.delayed(const Duration(seconds: 2));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final email = prefs.getString('email');
      final userName = prefs.getString('userName');
      final nis = prefs.getString('nis');
      final className = prefs.getString('className');
      final isTeacher = prefs.getBool('isTeacher') ?? false;
      final fullName = prefs.getString('fullName') ?? false;
      final isDonePretest = prefs.getBool('isDonePretest') ?? false;

      if (token != null && token.isNotEmpty) {
        emit(SplashAuthenticated(
          token: token,
          email: email ?? '',
          userName: userName ?? '',
          nis: nis ?? '',
          isTeacher: isTeacher,
          isDonePretest: isDonePretest,
        ));
      } else {
        emit(SplashUnauthenticated());
      }
    } catch (e) {
      emit(SplashUnauthenticated());
    }
  }
}

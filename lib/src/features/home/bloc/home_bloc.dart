import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/modules/models/module_model.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ModuleModel>? modules;
  final String? username;
  final int? totalProgress;

  const HomeLoaded({
    this.modules,
    this.username,
    this.totalProgress,
  });
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  FutureOr<void> _onLoadHomeData(event, emit) async {
    emit(HomeLoading());
    try {
      // Simulate API call
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid') ?? '';
      final username = prefs.getString('userName') ?? 'Guest';
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data();
      await prefs.setInt('totalProgress', userData?['total_progress'] ?? 0);
      await prefs.setInt('pointPretest', userData?['point_pretest'] ?? 0);
      await prefs.setBool(
          'isDonePretest', userData?['is_done_pretest'] ?? false);

      final querySnapshot = await _firestore
          .collection('module')
          .where('uid', isEqualTo: uid)
          .get();
      final modules = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ModuleModel.fromJson(jsonDecode(jsonEncode(data)));
      }).toList();

      for (var module in modules) {
        if (module.idModule == 1) {
          module.title = 'Bab ${module.idModule}';
          module.description =
              'Konsep Dasar Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit.';
          module.estimatedHours = 2;
          module.isLocked = module.isLocked;
        } else if (module.idModule == 2) {
          module.title = 'Title for module ${module.idModule}';
          module.description = 'Description for module ${module.idModule}';
          module.estimatedHours = 2;
          module.isLocked = module.isLocked;
        } else if (module.idModule == 3) {
          module.title = 'Title for module ${module.idModule}';
          module.description = 'Description for module ${module.idModule}';
          module.estimatedHours = 3;
          module.isLocked = module.isLocked;
        } else if (module.idModule == 4) {
          module.title = 'Title for module ${module.idModule}';
          module.description = 'Description for module ${module.idModule}';
          module.estimatedHours = 2;
          module.isLocked = module.isLocked;
        }
      }
      await Future.delayed(const Duration(seconds: 1));
      // final modules = [
      //   ModuleModel(
      //     idModule: 1,
      //     title: 'Fundamentals of Power Plant Machinery',
      //     description:
      //         'Learn the basic concepts and principles of power plant machinery',
      //     estimatedHours: 1,
      //     isCompleted: true,
      //   ),
      //   ModuleModel(
      //     idModule: 2,
      //     title: 'Structure and Components',
      //     description:
      //         'Understand the structure and components of power plant systems',
      //     estimatedHours: 2,
      //   ),
      //   ModuleModel(
      //     idModule: 3,
      //     title: 'Working Principles',
      //     description: 'Master the working principles of power generation',
      //     estimatedHours: 1,
      //     isLocked: true,
      //   ),
      // ];
      emit(HomeLoaded(
          modules: modules,
          username: username,
          totalProgress: userData?['total_progress'] ?? 0));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

import 'dart:async';
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
  final int? totalModules;
  final int? totalFinishModules;
  final int? totalInProgressModules;
  final ModuleModel lastModule;
  final String? uid;

  const HomeLoaded({
    this.modules,
    this.username,
    this.totalProgress,
    this.totalFinishModules,
    this.totalInProgressModules,
    this.totalModules,
    required this.lastModule,
    this.uid,
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
      final totalProgress = userData?['total_progress'] ?? 0;
      await prefs.setInt('totalProgress', totalProgress);
      await prefs.setInt('pointPretest', userData?['point_pretest'] ?? 0);
      await prefs.setBool(
          'isDonePretest', userData?['is_done_pretest'] ?? false);

      final querySnapshot = await _firestore
          .collection('modules')
          .where('uid', isEqualTo: uid)
          .get();
      final modules = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ModuleModel.fromJson(data);
      }).toList();

      for (var module in modules) {
        if (module.idModule == 1) {
          module.title = 'Bab ${module.idModule}';
          module.description =
              'Konsep Dasar Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit.';
          module.estimatedHours = 2;
          module.isLocked = module.isLocked;
        } else if (module.idModule == 2) {
          module.title = 'Bab ${module.idModule}';
          module.description =
              'Pengoperasian Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit';
          module.estimatedHours = 2;
          module.isLocked = module.isLocked;
        } else if (module.idModule == 3) {
          module.title = 'Bab ${module.idModule}';
          module.description =
              'Pemeliharaan Mesin Listrik Pembangkit dan Peralatan Mekanis Pembangkit';
          module.estimatedHours = 3;
          module.isLocked = module.isLocked;
        } else if (module.idModule == 4) {
          module.title = 'Final Project';
          module.description =
              'Sistem Pemeliharaan dan Pengoperasian Mesin Listrik Pembangkit';
          module.estimatedHours = 2;
          module.isLocked = module.isLocked;
        }
      }
      final finishModules = modules.where((data) => data.isFinish);
      final inProgressModules =
          modules.where((data) => (data.pointPostTest ?? 0) > 0);
      final lastModule = modules.lastWhere(
        (data) => data.idModule == (totalProgress / 25) + 1,
        orElse: () {
          return ModuleModel(
              idModule: 5,
              title: 'Silahkan upload dokumen praktikum',
              description: '',
              estimatedHours: 0,
              isLocked: false,
              isFinish: false);
        },
      );
      emit(
        HomeLoaded(
          modules: modules,
          username: username,
          totalProgress: totalProgress,
          totalModules: modules.length,
          totalFinishModules: finishModules.length,
          totalInProgressModules: inProgressModules.length,
          lastModule: lastModule,
          uid: uid,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

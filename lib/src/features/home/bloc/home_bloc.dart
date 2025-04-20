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
  final List<ModuleModel> modules;
  final String username;

  const HomeLoaded(this.modules,this.username);

  @override
  List<Object> get props => [modules,username];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        // Simulate API call

        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('userName') ?? 'Guest';
        await Future.delayed(const Duration(seconds: 1));
        final modules = [
          ModuleModel(
            id: 1,
            title: 'Fundamentals of Power Plant Machinery',
            description:
                'Learn the basic concepts and principles of power plant machinery',
            estimatedHours: 1,
            isCompleted: true,
          ),
          ModuleModel(
            id: 2,
            title: 'Structure and Components',
            description:
                'Understand the structure and components of power plant systems',
            estimatedHours: 2,
          ),
          ModuleModel(
            id: 3,
            title: 'Working Principles',
            description: 'Master the working principles of power generation',
            estimatedHours: 1,
            isLocked: true,
          ),
        ];
        emit(HomeLoaded(modules,username));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}

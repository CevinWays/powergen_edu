import '../models/content_model.dart';

abstract class ModuleState{}

class InitModuleState extends ModuleState{}

class LoadingModuleState extends ModuleState{}
class LoadedModuleState extends ModuleState{
  final List<ContentModel> contents;

  LoadedModuleState({required this.contents});
}
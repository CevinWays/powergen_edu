import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:powergen_edu/src/features/modules/bloc/module_state.dart';
import 'package:powergen_edu/src/features/modules/models/content_model.dart';

class ModuleBloc extends Cubit<ModuleState> {
  ModuleBloc() : super(InitModuleState());

  Future<void> fetchBab1(int? id) async {
    emit(LoadingModuleState());

    String response = '';

    if (id == 1) {
      response = await rootBundle.loadString('assets/data/bab1.json');
    } else if(id == 2) {
      response = await rootBundle.loadString('assets/data/bab2.json');
    } else if (id == 3) {
      response = await rootBundle.loadString('assets/data/bab3.json');
    } else if (id == 4) {
      response = await rootBundle.loadString('assets/data/final.json');
    } else {
      return;
    }

    final Map<String, dynamic> data = json.decode(response);

    final List<dynamic> contentList = data['content'] as List<dynamic>;

    emit(LoadedModuleState(
        contents:
            contentList.map((item) => ContentModel.fromJson(item)).toList()));
  }
}

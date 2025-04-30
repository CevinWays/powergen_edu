import 'package:powergen_edu/src/features/modules/models/content_model.dart';

class ModuleModel {
  final int? idModule;
  String? title;
  String? description;
  int? estimatedHours;
  bool isLocked;
  int? point;
  List<ContentModel>? content;

  ModuleModel({
    this.idModule,
    this.title,
    this.description,
    this.estimatedHours,
    this.isLocked = false,
    this.content,
    this.point,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      idModule: json['id_module'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      estimatedHours: json['estimatedHours'] as int?,
      isLocked: json['is_locked'] as bool? ?? false,
      point: json['point'] as int?,
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => ContentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

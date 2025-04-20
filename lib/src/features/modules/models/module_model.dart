import 'package:powergen_edu/src/features/modules/models/content_model.dart';

class ModuleModel {
  final int id;
  final String title;
  final String description;
  final int estimatedHours;
  final bool isCompleted;
  final bool isLocked;
  final List<ContentModel>? content;

  ModuleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.estimatedHours,
    this.isCompleted = false,
    this.isLocked = false,
    this.content,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      estimatedHours: json['estimatedHours'],
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? false,
      content: (json['content'] as List?)
          ?.map((item) => ContentModel.fromJson(item))
          .toList(),
        );
  }
}

class ContentModel {
  final String type;
  final String content;
  final bool? isTitle;

  ContentModel({
    required this.type,
    required this.content,
    this.isTitle,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      type: json['type'],
      content: json['content'],
      isTitle: json['isTitle'],
    );
  }
}
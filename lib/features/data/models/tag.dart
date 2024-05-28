import '../../domain/entities/tag.dart';

class TagModel extends TagEntity {
  const TagModel({
    required super.id,
    required super.content,
    required super.title,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as int,
      content: json['content'] as String,
      title: json['title'] as String,
    );
  }
}

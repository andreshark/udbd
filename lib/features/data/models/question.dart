import '../../domain/entities/question.dart';

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.title,
    required super.content,
    required super.rating,
    required super.createDate,
    required super.views,
    required super.authorId,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as int,
      content: json['content'] as String,
      title: json['title'] as String,
      rating: json['rating'] as int,
      createDate: DateTime.parse(json['create_date']),
      views: json['views'] as int,
      authorId: json['author_id'] as int,
    );
  }
}

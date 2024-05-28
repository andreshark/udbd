import '../../domain/entities/answer.dart';

class AnswerModel extends AnswerEntity {
  const AnswerModel({
    required super.id,
    required super.bestAnswer,
    required super.content,
    required super.rating,
    required super.createDate,
    required super.questId,
    required super.authorId,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] as int,
      content: json['content'] as String,
      bestAnswer: json['best_answer'] as bool,
      rating: json['rating'] as int,
      createDate: DateTime.parse(json['create_date']),
      questId: json['quest_id'] as int,
      authorId: json['author_id'] as int,
    );
  }
}

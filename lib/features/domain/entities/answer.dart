import 'package:equatable/equatable.dart';

class AnswerEntity extends Equatable {
  const AnswerEntity({
    required this.id,
    required this.bestAnswer,
    required this.content,
    required this.rating,
    required this.createDate,
    required this.questId,
    required this.authorId,
  });

  final int id;
  final bool bestAnswer;
  final String content;
  final int rating;
  final DateTime createDate;
  final int questId;
  final int authorId;

  @override
  List<Object?> get props {
    return [id, bestAnswer, content, rating, createDate, questId, authorId];
  }
}

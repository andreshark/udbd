import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  const QuestionEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.rating,
    required this.createDate,
    required this.views,
    required this.authorId,
  });

  final int id;
  final String title;
  final String content;
  final int rating;
  final DateTime createDate;
  final int views;
  final int authorId;

  @override
  List<Object?> get props {
    return [id, title, content, rating, createDate, views, authorId];
  }
}

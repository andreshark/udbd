import 'package:equatable/equatable.dart';

class AchievementEntity extends Equatable {
  const AchievementEntity({
    required this.id,
    required this.content,
    required this.title,
  });

  final int id;
  final String title;
  final String content;

  @override
  List<Object?> get props {
    return [id, content, title];
  }
}

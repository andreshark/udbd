import '../../domain/entities/achievement.dart';

class AchievementModel extends AchievementEntity {
  const AchievementModel({
    required super.id,
    required super.content,
    required super.title,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int,
      content: json['content'] as String,
      title: json['title'] as String,
    );
  }
}

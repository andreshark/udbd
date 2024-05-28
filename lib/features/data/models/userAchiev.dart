import '../../domain/entities/userAchiev.dart';

class UserAchievModel extends UserAchievEntity {
  const UserAchievModel({
    required super.userId,
    required super.achievId,
  });

  factory UserAchievModel.fromJson(Map<String, dynamic> json) {
    return UserAchievModel(
      userId: json['user_id'] as int,
      achievId: json['achiev_id'] as int,
    );
  }
}

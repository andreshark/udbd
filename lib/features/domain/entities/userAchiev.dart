import 'package:equatable/equatable.dart';

class UserAchievEntity extends Equatable {
  const UserAchievEntity({
    required this.userId,
    required this.achievId,
  });

  final int userId;
  final int achievId;

  @override
  List<Object?> get props {
    return [userId, achievId];
  }
}

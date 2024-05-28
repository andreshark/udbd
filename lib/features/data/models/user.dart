import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.id,
      required super.email,
      required super.password,
      required super.nickname,
      required super.dataReg,
      required super.lastVisit,
      required super.reputation});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      nickname: json['nickname'] as String,
      dataReg: json['date_reg'] as DateTime,
      lastVisit: json['last_visit'] as DateTime,
      reputation: json['id'] as int,
    );
  }
}

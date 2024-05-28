import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity(
      {required this.id,
      required this.email,
      required this.password,
      required this.nickname,
      required this.dataReg,
      required this.lastVisit,
      required this.reputation});

  final int id;
  final String email;
  final String password;
  final String nickname;
  final DateTime dataReg;
  final DateTime lastVisit;
  final int reputation;

  @override
  List<Object?> get props {
    return [id, email, password, nickname, dataReg, lastVisit, reputation];
  }
}

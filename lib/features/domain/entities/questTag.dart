import 'package:equatable/equatable.dart';

class QuestTagEntity extends Equatable {
  const QuestTagEntity({
    required this.questId,
    required this.tagId,
  });

  final int questId;
  final int tagId;

  @override
  List<Object?> get props {
    return [questId, tagId];
  }
}

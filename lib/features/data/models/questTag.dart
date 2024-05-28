import '../../domain/entities/questTag.dart';

class QuestTagModel extends QuestTagEntity {
  const QuestTagModel({
    required super.questId,
    required super.tagId,
  });

  factory QuestTagModel.fromJson(Map<String, dynamic> json) {
    return QuestTagModel(
      questId: json['quest_id'] as int,
      tagId: json['tag_id'] as int,
    );
  }
}

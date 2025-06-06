import 'package:json_annotation/json_annotation.dart';

import '../../shared/model/base_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment extends BaseModel {
  const Comment({
    required super.id,
    required this.task,
    required this.author,
    required this.content,
    super.dateCreated,
    super.lastUpdated,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  final String task;
  final String author;
  final String content;

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  static Comment? maybeFromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return Comment.fromJson(json);
    }
    return null;
  }
}

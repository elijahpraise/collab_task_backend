import 'package:json_annotation/json_annotation.dart';

import '../../shared/model/base_model.dart';

part 'task_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Task extends BaseModel {
  const Task({
    required super.id,
    required this.title,
    required this.description,
    required this.column,
    required this.assignee,
    required this.tags,
    required this.order,
    super.dateCreated,
    super.lastUpdated,
    this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String title;
  final String description;
  final String column;
  final String assignee;
  final DateTime? deadline;
  final List<String> tags;
  final int order;

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  static Task? maybeFromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return Task.fromJson(json);
    }
    return null;
  }
}

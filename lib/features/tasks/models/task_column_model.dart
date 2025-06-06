import 'package:json_annotation/json_annotation.dart';

import '../../shared/model/base_model.dart';

part 'task_column_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskColumn extends BaseModel {
  const TaskColumn({
    required super.id,
    required this.name,
    required this.workspace,
    required this.orderIndex,
    super.dateCreated,
    super.lastUpdated,
  });

  factory TaskColumn.fromJson(Map<String, dynamic> json) =>
      _$TaskColumnFromJson(json);

  final String name;
  final String workspace;
  final int orderIndex;

  Map<String, dynamic> toJson() => _$TaskColumnToJson(this);

  static TaskColumn? maybeFromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return TaskColumn.fromJson(json);
    }
    return null;
  }
}

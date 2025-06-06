import 'package:json_annotation/json_annotation.dart';

import '../../shared/model/base_model.dart';

part 'workspace_model.g.dart';

@JsonSerializable()
class Workspace extends BaseModel {
  const Workspace({
    required super.id,
    required this.name,
    required this.description,
    required this.user,
    required this.members,
    super.dateCreated,
    super.lastUpdated,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);

  final String name;
  final String description;
  final String user;
  final List<String> members;

  Map<String, dynamic> toJson() => _$WorkspaceToJson(this);

  static Workspace? maybeFromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return Workspace.fromJson(json);
    }
    return null;
  }
}

import 'package:collab_task_backend/features/shared/model/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User extends BaseModel {
  const User({
    required super.id,
    required this.email,
    required this.username,
    required this.passwordHash,
    super.dateCreated,
    super.lastUpdated,
  });
  final String email;
  final String username;
  final String passwordHash;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static User? maybeFromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return User.fromJson(json);
    }
    return null;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workspace _$WorkspaceFromJson(Map<String, dynamic> json) => Workspace(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      user: json['user'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$WorkspaceToJson(Workspace instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'user': instance.user,
      'members': instance.members,
    };

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
      dateCreated: json['date_created'] == null
          ? null
          : DateTime.parse(json['date_created'] as String),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$WorkspaceToJson(Workspace instance) => <String, dynamic>{
      'id': instance.id,
      'date_created': instance.dateCreated?.toIso8601String(),
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'name': instance.name,
      'description': instance.description,
      'user': instance.user,
      'members': instance.members,
    };

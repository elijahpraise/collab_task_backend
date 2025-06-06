// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_column_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskColumn _$TaskColumnFromJson(Map<String, dynamic> json) => TaskColumn(
      id: json['id'] as String,
      name: json['name'] as String,
      workspace: json['workspace'] as String,
      order: (json['order'] as num).toInt(),
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$TaskColumnToJson(TaskColumn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'name': instance.name,
      'workspace': instance.workspace,
      'order': instance.order,
    };

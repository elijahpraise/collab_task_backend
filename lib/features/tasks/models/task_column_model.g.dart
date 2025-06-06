// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_column_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskColumn _$TaskColumnFromJson(Map<String, dynamic> json) => TaskColumn(
      id: json['id'] as String,
      name: json['name'] as String,
      workspace: json['workspace'] as String,
      orderIndex: (json['order_index'] as num).toInt(),
      dateCreated: json['date_created'] == null
          ? null
          : DateTime.parse(json['date_created'] as String),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$TaskColumnToJson(TaskColumn instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_created': instance.dateCreated?.toIso8601String(),
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'name': instance.name,
      'workspace': instance.workspace,
      'order_index': instance.orderIndex,
    };

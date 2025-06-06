// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      column: json['column'] as String,
      assignee: json['assignee'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      order: (json['order'] as num).toInt(),
      dateCreated: json['date_created'] == null
          ? null
          : DateTime.parse(json['date_created'] as String),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'date_created': instance.dateCreated?.toIso8601String(),
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'column': instance.column,
      'assignee': instance.assignee,
      'deadline': instance.deadline?.toIso8601String(),
      'tags': instance.tags,
      'order': instance.order,
    };

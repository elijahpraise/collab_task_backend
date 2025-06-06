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
      assignee: json['assigneeId'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      order: (json['order'] as num).toInt(),
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'column': instance.column,
      'assigneeId': instance.assignee,
      'deadline': instance.deadline?.toIso8601String(),
      'tags': instance.tags,
      'order': instance.order,
    };

import 'dart:convert';

import 'package:collab_task_backend/features/shared/repository/base_repository.dart';
import 'package:collab_task_backend/features/tasks/tasks_index.dart';
import 'package:sqlite3/common.dart';

final taskRepository = TaskRepository();

class TaskRepository extends BaseRepository {
  Future<Task> createTask(CreateTaskDto dto) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final dateCreated = DateTime.now();

    // Get next order
    final orderResult = database.select(
      '''
      SELECT MAX(order_index) as max_order FROM tasks WHERE column = ?
    ''',
      [dto.column],
    );
    final order = (orderResult.first['max_order'] as int? ?? -1) + 1;

    database.execute('''
      INSERT INTO tasks (id, title, description, column, assignee, deadline, tags, order_index, date_created)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      id,
      dto.title,
      dto.description,
      dto.column,
      dto.assignee,
      dto.deadline?.toIso8601String(),
      jsonEncode(dto.tags),
      order,
      dateCreated.toIso8601String(),
    ]);

    return Task(
      id: id,
      title: dto.title,
      description: dto.description,
      column: dto.column,
      assignee: dto.assignee,
      deadline: dto.deadline,
      tags: dto.tags,
      order: order,
      dateCreated: dateCreated,
    );
  }

  Future<List<Task>> getTasksByColumnId(String columnId) async {
    final result = database.select(
      '''
      SELECT * FROM tasks WHERE column = ? ORDER BY order_index
    ''',
      [columnId],
    );

    return result.map((row) => row.task).toList();
  }

  Future<Task?> getTaskById(String id) async {
    final result = database.select('SELECT * FROM tasks WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    final row = result.first;
    return row.task;
  }

  Future<Task?> updateTask(UpdateTaskDto dto) async {
    database.execute('''
      UPDATE tasks SET title = ?, description = ?, deadline = ?, tags = ? WHERE id = ?
    ''', [
      dto.title,
      dto.description,
      dto.deadline?.toIso8601String(),
      jsonEncode(dto.tags),
      dto.id,
    ]);

    return getTaskById(dto.id);
  }

  Future<bool> deleteTask(String id) async {
    database.execute('DELETE FROM tasks WHERE id = ?', [id]);
    return true;
  }
}

extension TaskRowExt on Row {
  Task get task {
    final row = this;
    return Task.fromJson(row);
  }
}

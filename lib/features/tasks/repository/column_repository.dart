import 'package:collab_task_backend/features/shared/repository/base_repository.dart';
import 'package:collab_task_backend/features/tasks/tasks_index.dart';
import 'package:sqlite3/common.dart';

final columnRepository = ColumnRepository();

class ColumnRepository extends BaseRepository {
  Future<TaskColumn> createColumn(CreateColumnDto dto) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final dateCreated = DateTime.now();

    // Get next order
    final orderResult = database.select(
      '''
      SELECT MAX(order) as max_order FROM columns WHERE workspace = ?
    ''',
      [dto.workspace],
    );
    final order = (orderResult.first['max_order'] as int? ?? -1) + 1;

    database.execute(
      '''
      INSERT INTO columns (id, name, workspace, order, dateCreated)
      VALUES (?, ?, ?, ?, ?)
    ''',
      [id, dto.name, dto.workspace, order, dateCreated.toIso8601String()],
    );

    return TaskColumn(
      id: id,
      name: dto.name,
      workspace: dto.workspace,
      order: order,
      dateCreated: dateCreated,
    );
  }

  Future<List<TaskColumn>> getColumnsByWorkspaceId(String workspaceId) async {
    final result = database.select(
      '''
      SELECT * FROM columns WHERE workspace = ? ORDER BY order
    ''',
      [workspaceId],
    );

    return result.map((row) => row.taskColumn).toList();
  }

  Future<TaskColumn?> updateColumn(UpdateColumnDto dto) async {
    final lastUpdated = DateTime.now();
    database.execute(
      'UPDATE columns SET name = ? lastUpdated = ? WHERE id = ?',
      [dto.name, lastUpdated, dto.id],
    );

    final result =
        database.select('SELECT * FROM columns WHERE id = ?', [dto.id]);
    if (result.isEmpty) return null;

    final row = result.first;
    return row.taskColumn;
  }

  Future<bool> deleteColumn(String id) async {
    database.execute('DELETE FROM columns WHERE id = ?', [id]);
    return true;
  }
}

extension TaskColumnRowExt on Row {
  TaskColumn get taskColumn {
    final row = this;
    return TaskColumn.fromJson(row);
  }
}

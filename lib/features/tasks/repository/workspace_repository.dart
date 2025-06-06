import 'dart:convert';

import 'package:collab_task_backend/features/tasks/dtos/update_workspace_dto.dart';
import 'package:sqlite3/common.dart';

import '../../shared/repository/base_repository.dart';
import '../dtos/create_workspace_dto.dart';
import '../models/workspace_model.dart';

class WorkspaceRepository extends BaseRepository {
  Future<Workspace> createWorkspace(CreateWorkspaceDto dto) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final dateCreated = DateTime.now();
    final members = [dto.user];

    database.execute('''
      INSERT INTO workspaces (id, name, description, user, members, date_created)
      VALUES (?, ?, ?, ?, ?, ?)
    ''', [
      id,
      dto.name,
      dto.description,
      dto.user,
      jsonEncode(members),
      dateCreated.toIso8601String(),
    ]);

    return Workspace(
      id: id,
      name: dto.name,
      description: dto.description,
      user: dto.user,
      members: members,
      dateCreated: dateCreated,
    );
  }

  Future<List<Workspace>> getWorkspacesByUserId(String userId) async {
    final result = database.select(
      '''
      SELECT * FROM workspaces WHERE owner = ? OR members LIKE ?
    ''',
      [userId, '%"$userId"%'],
    );

    return result.map((row) => row.workspace).toList();
  }

  Future<Workspace?> getWorkspaceById(String id) async {
    final result =
        database.select('SELECT * FROM workspaces WHERE id = ?', [id]);
    if (result.isEmpty) return null;

    final row = result.first;
    return row.workspace;
  }

  Future<Workspace?> updateWorkspace(UpdateWorkspaceDto dto) async {
    final lastUpdated = DateTime.now();
    database.execute(
      '''
      UPDATE workspaces SET name = ?, description = ? last_updated = ? WHERE id = ?
    ''',
      [dto.name, dto.description, lastUpdated.toIso8601String(), dto.id],
    );

    return getWorkspaceById(dto.id);
  }

  Future<bool> deleteWorkspace(String id) async {
    database.execute('DELETE FROM workspaces WHERE id = ?', [id]);
    return true;
  }
}

extension WorkspaceRowExt on Row {
  Workspace get workspace {
    final row = this;
    return Workspace.fromJson(row);
  }
}

import 'package:collab_task_backend/features/tasks/repository/column_repository.dart';
import 'package:collab_task_backend/features/tasks/repository/workspace_repository.dart';
import 'package:collab_task_backend/features/tasks/tasks_index.dart';

final workspaceService = WorkspaceService();

class WorkspaceService {
  final WorkspaceRepository _workspaceRepository = WorkspaceRepository();
  final ColumnRepository _columnRepository = ColumnRepository();

  Future<Workspace> createWorkspace(CreateWorkspaceDto dto) async {
    final workspace = await _workspaceRepository.createWorkspace(dto);

    // Create default columns
    await Future.wait([
      _columnRepository.createColumn(
        CreateColumnDto(name: 'To Do', workspace: workspace.id),
      ),
      _columnRepository.createColumn(
        CreateColumnDto(name: 'In Progress', workspace: workspace.id),
      ),
      _columnRepository.createColumn(
        CreateColumnDto(name: 'Done', workspace: workspace.id),
      ),
    ]);

    return workspace;
  }

  Future<List<Workspace>> getUserWorkspaces(String userId) async {
    return _workspaceRepository.getWorkspacesByUserId(userId);
  }

  Future<Workspace?> getWorkspace(String id) async {
    return _workspaceRepository.getWorkspaceById(id);
  }

  Future<Workspace?> updateWorkspace(UpdateWorkspaceDto dto) async {
    return _workspaceRepository.updateWorkspace(dto);
  }

  Future<bool> deleteWorkspace(String id) async {
    return _workspaceRepository.deleteWorkspace(id);
  }
}

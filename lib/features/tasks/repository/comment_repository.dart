import 'package:collab_task_backend/features/shared/repository/base_repository.dart';
import 'package:collab_task_backend/features/tasks/tasks_index.dart';
import 'package:sqlite3/common.dart';

final commentRepository = CommentRepository();

class CommentRepository extends BaseRepository {
  Future<Comment> createComment(CreateCommentDto dto) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final dateCreated = DateTime.now();

    database.execute(
      '''
      INSERT INTO comments (id, task, author, content, dateCreated)
      VALUES (?, ?, ?, ?, ?)
    ''',
      [id, dto.task, dto.author, dto.content, dateCreated.toIso8601String()],
    );

    return Comment(
      id: id,
      task: dto.task,
      author: dto.author,
      content: dto.content,
      dateCreated: dateCreated,
    );
  }

  Future<List<Comment>> getCommentsByTaskId(String task) async {
    final result = database.select(
      '''
      SELECT * FROM comments WHERE task = ? ORDER BY created_at DESC
    ''',
      [task],
    );

    return result.map((row) => row.comment).toList();
  }

  Future<bool> deleteComment(String id) async {
    database.execute('DELETE FROM comments WHERE id = ?', [id]);
    return true;
  }
}

extension CommentRowExt on Row {
  Comment get comment {
    final row = this;
    return Comment.fromJson(row);
  }
}

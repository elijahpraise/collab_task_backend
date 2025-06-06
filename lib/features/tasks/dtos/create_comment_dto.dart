class CreateCommentDto {
  CreateCommentDto({
    required this.task,
    required this.author,
    required this.content,
  });
  final String task;
  final String author;
  final String content;
}

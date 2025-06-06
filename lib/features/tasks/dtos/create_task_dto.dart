class CreateTaskDto {
  CreateTaskDto({
    required this.title,
    required this.description,
    required this.column,
    required this.assignee,
    required this.tags,
    this.deadline,
  });
  final String title;
  final String description;
  final String column;
  final String assignee;
  final List<String> tags;
  final DateTime? deadline;
}

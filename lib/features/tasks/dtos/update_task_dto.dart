class UpdateTaskDto {
  UpdateTaskDto({
    required this.id,
    this.title,
    this.description,
    this.deadline,
    this.tags,
  });
  final String id;
  final String? title;
  final String? description;
  final DateTime? deadline;
  final List<String>? tags;
}

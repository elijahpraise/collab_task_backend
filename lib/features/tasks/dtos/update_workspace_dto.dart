class UpdateWorkspaceDto {
  UpdateWorkspaceDto({
    required this.id,
    this.name,
    this.description,
  });
  final String id;
  final String? name;
  final String? description;
}

class CreateWorkspaceDto {
  CreateWorkspaceDto({
    required this.name,
    required this.description,
    required this.user,
  });
  final String name;
  final String description;
  final String user;
}

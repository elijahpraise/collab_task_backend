class CreateUserDto {
  CreateUserDto({
    required this.email,
    required this.username,
    required this.password,
  });
  final String email;
  final String username;
  final String password;
}

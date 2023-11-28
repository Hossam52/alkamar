enum UserRoleEnum {
  admin,
  assistant,
}

extension UserRole on UserRoleEnum {
  static UserRoleEnum byName(String role) {
    switch (role) {
      case 'admin':
        return UserRoleEnum.admin;
      case 'assistant':
      default:
        return UserRoleEnum.assistant;
    }
  }

  bool get isAdmin => name == 'admin';
}

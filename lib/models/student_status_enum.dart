enum StudentStatus { disabled, enabled }

extension StudentStatusMethods on StudentStatus {
  int get getIndex {
    if (this == StudentStatus.disabled) return 0;
    if (this == StudentStatus.enabled) {
      return 1;
    } else {
      return 2;
    }
  }

  static StudentStatus getStudentStatusEnum(int status) {
    for (var element in StudentStatus.values) {
      if (element.index == status) return element;
    }
    return StudentStatus.disabled;
  }

  String get getText {
    if (this == StudentStatus.disabled) return 'متوقف';
    if (this == StudentStatus.enabled) return 'منتظم';
    return 'غير معروف';
  }
}

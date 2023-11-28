class EndPoints {
  EndPoints._();

  static const String availablePermissions = '/availablePermissions';

  // Auth endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String profile = '/auth/profile';
  static const String attendanceStats = '/auth/attendance_stats';
  static const String updateProfile = '/auth/update';
  static const String changePhone = '/auth/changePhone';
  static const String changePassword = '/auth/changePassword';
  static const String logout = '/auth/logout';
  static const String allUsers = '/auth/allUsers';
  static const String addPermission = '/auth/addPermissions';

  //Stages endpoints
  static const String stages = '/stages';

  // Students endpoints
  static const String createStudent = '/students/create';
  static const String updateStudent = '/students/update';
  static const String listStudents = '/students/list';
  static const String studentAttendances = '/students/attendance';
  static const String studenthomeworks = '/students/homeworks';
  static const String studentpayments = '/students/payments';
  static const String studentData = '/students/profile';
  static const String studentProfile = '/students';
  static const String generatePdf = '/students/generate_pdf';

  // Exams endpoints
  static const String allExams = '/exams';
  static const String examStats = '/exams/stats';
  static const String createExam = '/exams/create';
  static const String collectiveExams = '/exams/collectiveExams';
  static const String updateExam = '/exams/update';
  static const String deleteExam = '/exams/delete';

  // Grades endpoints
  static const String storeGrade = '/grades/store';

  // Payments endpoints
  static const String storeStudentPayment = '/payments/store_student_payment';
  static const String paymentStats = '/payments/stats';
  static const String createPayment = '/payments/store';

  // Lectures endpoints
  static const String storeLecture = '/lectures/store';
  static const String updateLecture = '/lectures/update';
  static const String deleteLecture = '/lectures/delete';
  static const String lectureStats = '/lectures/stats';

  // Attendances endpoints
  static const String storeAttendance = '/attendances/store';

  // Attendances endpoints
  static const String storeHomework = '/homeworks/store';

  // Search endpoints
  static const String searchStudent = '/search';

  // groups endpoints
  static const String allGroups = '/groups';
  static const String storeGroups = '/groups/store';
}

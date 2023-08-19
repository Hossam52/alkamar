class StudentQrsResponse {
  final bool status;
  final String message;
  final String pdf_url;

  StudentQrsResponse(
      {required this.status, required this.message, required this.pdf_url});

  factory StudentQrsResponse.fromMap(Map<String, dynamic> map) {
    return StudentQrsResponse(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      pdf_url: map['pdf_url'] ?? '',
    );
  }
}

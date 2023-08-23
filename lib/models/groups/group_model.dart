class GroupResponseModel {
  final bool status;
  final String message;
  final List<GroupModel> groups;
  GroupResponseModel({
    required this.status,
    required this.message,
    required this.groups,
  });

  factory GroupResponseModel.fromMap(Map<String, dynamic> map) {
    return GroupResponseModel(
      status: map['status'] ?? false,
      message: map['message'] ?? '',
      groups: List<GroupModel>.from(
          map['groups']?.map((x) => GroupModel.fromMap(x))),
    );
  }
  void appendGroup(GroupModel group) {
    groups.add(group);
  }
}

class GroupModel {
  final int id;
  final String title;
  GroupModel({
    required this.id,
    required this.title,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
    );
  }
}

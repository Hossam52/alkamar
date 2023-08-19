class GenderModel {
  String key;
  String value;
  GenderModel({
    required this.key,
    required this.value,
  });
}

List<GenderModel> genders = [
  GenderModel(key: 'male', value: 'ذكر'),
  GenderModel(key: 'female', value: 'انثي')
];

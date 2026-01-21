class UserDataModel {
  final String id;
  final Map<String, dynamic> data;
  final String formTitle;
  final String version;
  final DateTime submittedAt;

  UserDataModel({
    required this.id,
    required this.data,
    required this.formTitle,
    required this.version,
    required this.submittedAt,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'] as String,
      data: json['data'] as Map<String, dynamic>,
      formTitle: json['form_title'] as String,
      version: json['version'] as String,
      submittedAt: DateTime.parse(json['submitted_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'form_title': formTitle,
      'version': version,
      'submitted_at': submittedAt.toIso8601String(),
    };
  }
}

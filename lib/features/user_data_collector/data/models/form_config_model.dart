import 'form_field_model.dart';

class FormConfigModel {
  final String formTitle;
  final String version;
  final List<FormFieldModel> fields;

  FormConfigModel({
    required this.formTitle,
    required this.version,
    required this.fields,
  });

  factory FormConfigModel.fromJson(Map<String, dynamic> json) {
    return FormConfigModel(
      formTitle: json['form_title'] as String,
      version: json['version'] as String,
      fields: (json['fields'] as List)
          .map((field) => FormFieldModel.fromJson(field as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form_title': formTitle,
      'version': version,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }
}

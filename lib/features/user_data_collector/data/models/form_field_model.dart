class FormFieldModel {
  final String key;
  final String label;
  final String type; // text, number, dropdown, checkbox
  final bool required;
  final String? placeholder;
  final String? validationRegex;
  final String? errorText;
  final List<String>? options; // For dropdown
  final dynamic initialValue; // For checkbox
  final String? dependsOn; // Key of field this depends on
  final String? dependsOnValue; // Value that triggers this field

  FormFieldModel({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    this.placeholder,
    this.validationRegex,
    this.errorText,
    this.options,
    this.initialValue,
    this.dependsOn,
    this.dependsOnValue,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      required: json['required'] as bool? ?? false,
      placeholder: json['placeholder'] as String?,
      validationRegex: json['validation_regex'] as String?,
      errorText: json['error_text'] as String?,
      options: json['options'] != null
          ? List<String>.from(json['options'] as List)
          : null,
      initialValue: json['initial_value'],
      dependsOn: json['depends_on'] as String?,
      dependsOnValue: json['depends_on_value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'type': type,
      'required': required,
      'placeholder': placeholder,
      'validation_regex': validationRegex,
      'error_text': errorText,
      'options': options,
      'initial_value': initialValue,
      'depends_on': dependsOn,
      'depends_on_value': dependsOnValue,
    };
  }
}

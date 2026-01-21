import 'package:flutter/material.dart';
import '../../data/models/form_config_model.dart';
import '../../data/models/form_field_model.dart';
import '../../data/models/user_data_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../widgets/dynamic_form_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _storageService = StorageService();
  FormConfigModel? _formConfig;
  Map<String, dynamic> _formValues = {};
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFormConfig();
  }

  Future<void> _loadFormConfig() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final config = await _apiService.fetchFormConfig();
      setState(() {
        _formConfig = config;
        // Initialize form values with default values
        for (final field in config.fields) {
          if (field.type == 'checkbox') {
            _formValues[field.key] = field.initialValue ?? false;
          } else if (field.type == 'dropdown') {
            // Dropdown fields should be null initially, not empty string
            _formValues[field.key] = null;
          } else {
            _formValues[field.key] = '';
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load form: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  bool _shouldShowField(FormFieldModel field) {
    if (field.dependsOn == null) {
      return true;
    }

    final dependentValue = _formValues[field.dependsOn];
    if (dependentValue == null) {
      return false;
    }

    // Handle checkbox dependencies
    if (dependentValue is bool) {
      final expectedValue = field.dependsOnValue?.toLowerCase() == 'true';
      return dependentValue == expectedValue;
    }

    // Handle other field types
    return dependentValue.toString() == field.dependsOnValue;
  }

  void _handleFieldChange(String key, dynamic value) {
    setState(() {
      _formValues[key] = value;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required fields
    for (final field in _formConfig!.fields) {
      if (field.required && _shouldShowField(field)) {
        final value = _formValues[field.key];
        if (value == null ||
            value.toString().isEmpty ||
            (field.type == 'checkbox' && value == false)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please fill ${field.label}'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Submit to API
      final success = await _apiService.submitFormData({
        'form_title': _formConfig!.formTitle,
        'version': _formConfig!.version,
        'data': _formValues,
      });

      if (success) {
        // Save to local storage
        final submission = UserDataModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          data: _formValues,
          formTitle: _formConfig!.formTitle,
          version: _formConfig!.version,
          submittedAt: DateTime.now(),
        );
        await _storageService.saveSubmission(submission);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to submit form. Please try again.';
          _isSubmitting = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.edit_note_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text('Fill Form'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : _formConfig == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE8E8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: const Color(0xFFD4A5A5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _errorMessage ?? 'Failed to load form',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF5A5A5A),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: _loadFormConfig,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF9CAF88)
                                          .withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description_rounded,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _formConfig!.formTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF5A5A5A),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8B4B8)
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Version ${_formConfig!.version}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: const Color(0xFFE8B4B8),
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              ..._formConfig!.fields.map((field) {
                                return DynamicFormField(
                                  key: ValueKey(field.key),
                                  field: field,
                                  initialValue: _formValues[field.key],
                                  onChanged: (value) => _handleFieldChange(field.key, value),
                                  formValues: _formValues,
                                  isVisible: _shouldShowField(field),
                                );
                              }).toList(),
                              if (_errorMessage != null)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFE8E8),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFD4A5A5)
                                          .withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        color: const Color(0xFFD4A5A5),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                            color: Color(0xFFD4A5A5),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBF5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9CAF88).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isSubmitting ? null : _handleSubmit,
                                icon: _isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.check_circle_outline_rounded),
                                label: Text(
                                  _isSubmitting ? 'Submitting...' : 'Submit Form',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

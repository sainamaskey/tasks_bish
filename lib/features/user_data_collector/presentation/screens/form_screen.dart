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
      appBar: AppBar(
        title: const Text('Fill Form'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _formConfig == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage ?? 'Failed to load form',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFormConfig,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formConfig!.formTitle,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Version ${_formConfig!.version}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
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
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[300]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.red[700]),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: TextStyle(color: Colors.red[700]),
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
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Submit Form'),
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

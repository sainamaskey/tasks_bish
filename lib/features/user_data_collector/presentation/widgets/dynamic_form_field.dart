import 'package:flutter/material.dart';
import '../../data/models/form_field_model.dart';

class DynamicFormField extends StatefulWidget {
  final FormFieldModel field;
  final dynamic initialValue;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> formValues;
  final bool isVisible;

  const DynamicFormField({
    super.key,
    required this.field,
    this.initialValue,
    required this.onChanged,
    required this.formValues,
    this.isVisible = true,
  });

  @override
  State<DynamicFormField> createState() => _DynamicFormFieldState();
}

class _DynamicFormFieldState extends State<DynamicFormField> {
  late TextEditingController _controller;
  String? _errorText;
  dynamic _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? widget.field.initialValue;
    
    // For dropdown, validate that initial value exists in options
    if (widget.field.type == 'dropdown') {
      final options = widget.field.options ?? [];
      if (_value != null && !options.contains(_value.toString())) {
        _value = null; // Reset to null if value doesn't exist in options
      }
    }
    
    if (widget.field.type == 'text' || widget.field.type == 'number') {
      _controller = TextEditingController(
        text: _value?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    if (widget.field.type == 'text' || widget.field.type == 'number') {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _validate(String? value) {
    if (widget.field.required && (value == null || value.isEmpty)) {
      _errorText = 'This field is required';
      return false;
    }

    if (widget.field.type == 'checkbox') {
      if (widget.field.required && (_value == null || _value == false)) {
        _errorText = widget.field.errorText ?? 'This field is required';
        return false;
      }
      return true;
    }

    if (value != null && value.isNotEmpty) {
      if (widget.field.validationRegex != null) {
        final regex = RegExp(widget.field.validationRegex!);
        if (!regex.hasMatch(value)) {
          _errorText = widget.field.errorText ?? 'Invalid format';
          return false;
        }
      }
    }

    _errorText = null;
    return true;
  }

  void _handleChange(dynamic value) {
    setState(() {
      _value = value;
      _validate(value?.toString());
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    Widget fieldWidget;

    switch (widget.field.type) {
      case 'text':
        fieldWidget = TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.field.label,
            hintText: widget.field.placeholder,
            errorText: _errorText,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            _handleChange(value);
          },
          validator: (value) {
            if (!_validate(value)) {
              return _errorText;
            }
            return null;
          },
        );
        break;

      case 'number':
        fieldWidget = TextFormField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.field.label,
            hintText: widget.field.placeholder,
            errorText: _errorText,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            _handleChange(value);
          },
          validator: (value) {
            if (!_validate(value)) {
              return _errorText;
            }
            return null;
          },
        );
        break;

      case 'dropdown':
        final options = widget.field.options ?? [];
        final currentValue = _value?.toString();
        // Only set value if it exists in the options list
        final validValue = (currentValue != null && options.contains(currentValue))
            ? currentValue
            : null;
        
        fieldWidget = DropdownButtonFormField<String>(
          value: validValue,
          decoration: InputDecoration(
            labelText: widget.field.label,
            errorText: _errorText,
            border: const OutlineInputBorder(),
          ),
          items: options.isEmpty
              ? null
              : options.map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  )).toList(),
          onChanged: (value) {
            _handleChange(value);
          },
          validator: (value) {
            if (!_validate(value)) {
              return _errorText;
            }
            return null;
          },
        );
        break;

      case 'checkbox':
        fieldWidget = FormField<bool>(
          initialValue: _value as bool? ?? false,
          validator: (value) {
            if (widget.field.required && (value == null || value == false)) {
              return widget.field.errorText ?? 'This field is required';
            }
            return null;
          },
          builder: (formFieldState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: formFieldState.hasError
                      ? const Color(0xFFD4A5A5)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: Text(
                      widget.field.label,
                      style: const TextStyle(
                        color: Color(0xFF5A5A5A),
                        fontSize: 15,
                      ),
                    ),
                    value: _value as bool? ?? false,
                    onChanged: (value) {
                      _handleChange(value);
                      formFieldState.didChange(value);
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).colorScheme.primary,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  if (formFieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text(
                        formFieldState.errorText ?? '',
                        style: const TextStyle(
                          color: Color(0xFFD4A5A5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
        break;

      default:
        fieldWidget = Text('Unsupported field type: ${widget.field.type}');
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: fieldWidget,
    );
  }
}

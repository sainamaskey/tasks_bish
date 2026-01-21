import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/form_config_model.dart';
import 'auth_service.dart';

class ApiService {
  // Replace with your actual backend URL
  static const String baseUrl = 'https://your-backend-api.com/api';
  final AuthService _authService = AuthService();

  Future<FormConfigModel> fetchFormConfig() async {
    // For demo, return the sample form config
    // In production, this would fetch from the API
    final sampleJson = {
      'form_title': 'Customer Onboarding',
      'version': '1.0.2',
      'fields': [
        {
          'key': 'full_name',
          'label': 'Full Name',
          'type': 'text',
          'required': true,
          'placeholder': 'Enter your legal name',
          'validation_regex': '^[a-zA-Z ]+\$',
          'error_text': 'Please enter a valid name (letters only)',
        },
        {
          'key': 'mobile_number',
          'label': 'Mobile Number',
          'type': 'number',
          'required': true,
          'placeholder': '98XXXXXXXX',
          'validation_regex': '^[0-9]{10}\$',
          'error_text': 'Enter a valid 10-digit number',
        },
        {
          'key': 'gender',
          'label': 'Gender',
          'type': 'dropdown',
          'required': true,
          'options': ['Male', 'Female', 'Other'],
        },
        {
          'key': 'has_voter_id',
          'label': 'Do you have a Voter ID?',
          'type': 'checkbox',
          'required': false,
          'initial_value': false,
        },
        {
          'key': 'voter_id',
          'label': 'Voter ID Number',
          'type': 'text',
          'required': false,
          'placeholder': 'Enter your Voter ID',
          'depends_on': 'has_voter_id',
          'depends_on_value': 'true',
        },
        {
          'key': 'is_terms_accepted',
          'label': 'I accept the terms and conditions',
          'type': 'checkbox',
          'required': true,
          'initial_value': false,
        },
      ],
    };

    return FormConfigModel.fromJson(sampleJson);

    // Uncomment below for actual API call:
    /*
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/form-config'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return FormConfigModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load form config');
    }
    */
  }

  Future<bool> submitFormData(Map<String, dynamic> formData) async {
    // For demo, simulate successful submission
    // In production, this would POST to the API
    await Future.delayed(const Duration(seconds: 1));
    return true;

    // Uncomment below for actual API call:
    /*
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/submit-form'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(formData),
    );

    return response.statusCode == 200 || response.statusCode == 201;
    */
  }

  Future<List<Map<String, dynamic>>> fetchSubmissionHistory() async {
    // For demo, return empty list or sample data
    // In production, this would fetch from the API
    await Future.delayed(const Duration(milliseconds: 500));
    return [];

    // Uncomment below for actual API call:
    /*
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/submissions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load submission history');
    }
    */
  }
}

# User Data Collector - Implementation Summary

## Overview
A Flutter application for a SAAS provider that collects user data using dynamic forms configured by the backend. The application supports login/logout, dynamic form rendering, dependent fields, validation, and submission history.

## Features Implemented

### 1. Authentication
- **Login Screen**: Username/password authentication
- **Logout**: Logout functionality with confirmation dialog
- **Session Management**: Uses SharedPreferences for local storage
- **Splash Screen**: Checks authentication status on app launch

### 2. Dynamic Form Rendering
- **Form Configuration**: Fetches form configuration from backend (currently using sample data)
- **Field Types Supported**:
  - Text fields
  - Number fields
  - Dropdown fields
  - Checkbox fields
- **Field Properties**:
  - Required/optional fields
  - Placeholder text
  - Validation regex patterns
  - Custom error messages
  - Initial values

### 3. Dependent Fields
- Fields can depend on other fields
- Example: `voter_id` field appears when `has_voter_id` checkbox is checked
- Supports boolean dependencies (checkbox) and string dependencies
- Fields are automatically shown/hidden based on dependency values

### 4. Validation
- Required field validation
- Regex pattern validation
- Custom error messages from backend
- Real-time validation feedback
- Form-level validation before submission

### 5. Data Submission
- Submits form data to backend API
- Saves submissions to local storage (SharedPreferences)
- Error handling for failed submissions
- Success feedback to user

### 6. Submission History
- **Home Screen**: Displays all form submissions in cards
- **Submission Cards**: Show form title, version, submission date, and key field values
- **Details View**: Tap on a card to see full submission details
- **Pull to Refresh**: Refresh submission list
- **Empty State**: Shows message when no submissions exist

## Project Structure

```
lib/
└── features/
    └── user_data_collector/
        ├── data/
        │   ├── models/
        │   │   ├── form_field_model.dart      # Individual field model
        │   │   ├── form_config_model.dart     # Form configuration model
        │   │   └── user_data_model.dart       # User submission model
        │   └── services/
        │       ├── auth_service.dart          # Authentication logic
        │       ├── api_service.dart           # API calls
        │       └── storage_service.dart       # Local storage
        └── presentation/
            ├── screens/
            │   ├── splash_screen.dart         # Initial auth check
            │   ├── login_screen.dart          # Login UI
            │   ├── home_screen.dart           # Submission history
            │   └── form_screen.dart           # Dynamic form
            └── widgets/
                └── dynamic_form_field.dart    # Reusable form field widget
```

## Key Components

### Models
- **FormFieldModel**: Represents a single form field with all its properties
- **FormConfigModel**: Represents the complete form configuration
- **UserDataModel**: Represents a submitted form entry

### Services
- **AuthService**: Handles login, logout, and session management
- **ApiService**: Fetches form config and submits form data
- **StorageService**: Manages local storage of submissions

### Screens
- **SplashScreen**: Checks auth status and routes accordingly
- **LoginScreen**: User authentication
- **HomeScreen**: Displays submission history with cards
- **FormScreen**: Renders dynamic form based on backend config

### Widgets
- **DynamicFormField**: Handles rendering and validation of different field types

## Configuration

### Backend API Integration
The `ApiService` currently uses sample data for demonstration. To connect to your backend:

1. Update `baseUrl` in `api_service.dart`
2. Uncomment the actual API call code in:
   - `fetchFormConfig()`
   - `submitFormData()`
   - `fetchSubmissionHistory()`

### Form Configuration Format
The backend should return JSON in this format:

```json
{
  "form_title": "Customer Onboarding",
  "version": "1.0.2",
  "fields": [
    {
      "key": "full_name",
      "label": "Full Name",
      "type": "text",
      "required": true,
      "placeholder": "Enter your legal name",
      "validation_regex": "^[a-zA-Z ]+$",
      "error_text": "Please enter a valid name (letters only)"
    },
    {
      "key": "has_voter_id",
      "label": "Do you have a Voter ID?",
      "type": "checkbox",
      "required": false,
      "initial_value": false
    },
    {
      "key": "voter_id",
      "label": "Voter ID Number",
      "type": "text",
      "required": false,
      "depends_on": "has_voter_id",
      "depends_on_value": "true"
    }
  ]
}
```

## Dependencies

Added to `pubspec.yaml`:
- `shared_preferences: ^2.2.2` - For local storage
- `http: ^1.2.0` - Already present, used for API calls

## Usage

1. **Login**: Enter any username and password (demo mode)
2. **Fill Form**: Tap "Fill New Form" or the FAB button
3. **Submit**: Fill required fields and submit
4. **View History**: See all submissions on the home screen
5. **Logout**: Use the logout button in the app bar

## Next Steps

1. Run `flutter pub get` to install dependencies
2. Update API endpoints in `api_service.dart` with your backend URLs
3. Test the application with your backend form configurations
4. Customize UI/UX as needed
5. Add additional field types if required (date, file upload, etc.)

## Notes

- Authentication is currently demo mode (accepts any non-empty credentials)
- Form submissions are stored locally and can be synced with backend
- Dependent fields automatically show/hide based on parent field values
- All validations are enforced as per backend configuration

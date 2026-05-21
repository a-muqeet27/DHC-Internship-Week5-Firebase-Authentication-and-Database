# Firebase Auth Firestore App

A modern Flutter application with Firebase Authentication and Firestore database integration. The app features a beautiful UI with comprehensive form validation, user authentication, and profile management.

## 🎯 Features

- **User Authentication**
  - Email/Password Sign Up
  - Email/Password Login
  - User Logout
  - Session Management

- **Form Validation**
  - Email format validation
  - Password strength validation
  - Real-time field validation
  - User-friendly error messages
  - Firebase error handling with specific messages

- **User Profile Management**
  - Store user data in Firestore
  - Display user information
  - Profile avatar with user initial
  - User ID display

- **Beautiful UI/UX**
  - Modern gradient backgrounds
  - Smooth animations
  - Responsive design
  - Clean and intuitive interface
  - Dark mode friendly theme

- **Security Features**
  - Password requirements (6+ characters, uppercase, number)
  - Email validation
  - Secure password handling
  - Firebase security rules

## 📋 Prerequisites

Before running this project, ensure you have:

- **Flutter SDK** (3.9.2 or higher)
- **Dart SDK** (included with Flutter)
- **Firebase Account** (https://firebase.google.com)
- **Chrome Browser** (for web development)
- **Code Editor** (VS Code, Android Studio, or IntelliJ IDEA)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd firebase_auth_firestore_app
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Set Up Firebase

#### For Android:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new Firebase project or select an existing one
3. Add an Android app to your Firebase project
4. Download `google-services.json` from Firebase
5. Place it in `android/app/` directory
6. The app is configured with:
   - Project ID: `fir-auth-firestore-app-4dc2f`
   - API Key: `AIzaSyD24EM9DaYqaaNj8ipG_PX-sREBLpqvp0M`

#### For Web:
1. Add a web app to your Firebase project
2. Copy the Firebase configuration
3. Update `lib/firebase_options.dart` with your web app ID and measurement ID:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR_API_KEY',
  authDomain: 'YOUR_PROJECT.firebaseapp.com',
  projectId: 'YOUR_PROJECT_ID',
  storageBucket: 'YOUR_PROJECT.appspot.com',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  appId: '1:YOUR_NUMBER:web:YOUR_APP_ID',
  measurementId: 'G-YOUR_MEASUREMENT_ID',
);
```

### 4. Enable Authentication Methods

In Firebase Console:
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider

### 5. Set Up Firestore Database

In Firebase Console:
1. Go to **Firestore Database**
2. Create a new database in **production mode**
3. Add the following security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

## 🏃 Running the App

### Web
```bash
flutter run -d chrome
```

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point with theme setup
├── firebase_options.dart     # Firebase configuration
├── theme/
│   └── app_theme.dart       # Theme colors and styles
├── screens/
│   ├── login_screen.dart    # Login page with validation
│   ├── signup_screen.dart   # Signup page with validation
│   └── profile_screen.dart  # User profile page
├── services/
│   ├── auth_service.dart    # Authentication logic
│   └── firestore_service.dart # Firestore database logic
└── widgets/                  # Reusable widgets (if any)
```

## 🎨 Theme & Colors

The app uses a modern color scheme:

- **Primary Color**: Purple (#6C63FF) - for login
- **Secondary Color**: Red (#FF6B6B) - for signup
- **Success Color**: Green (#48BB78)
- **Background**: Light Blue-Grey (#F8F9FF)
- **Text Primary**: Dark Grey (#1A202C)
- **Text Secondary**: Medium Grey (#718096)

## ✅ Validation Rules

### Email Validation
- Required field
- Valid email format (xxx@xxx.xxx)
- Specific Firebase error messages for existing accounts

### Password Validation (Login)
- Minimum 6 characters
- Real-time validation feedback

### Password Validation (Signup)
- Minimum 6 characters
- At least one uppercase letter
- At least one number
- Visual requirements checklist

### Name Validation (Signup)
- Required field
- Minimum 2 characters

## 🔐 Firebase Error Handling

The app provides specific, user-friendly error messages for:

- **user-not-found**: "No account found with this email. Please sign up."
- **wrong-password**: "Incorrect password. Please try again."
- **email-already-in-use**: "An account with this email already exists."
- **invalid-email**: "Invalid email format."
- **weak-password**: "Password is too weak. Use a stronger password."
- **too-many-requests**: "Too many failed login attempts. Please try again later."

## 📱 Responsive Design

The app is fully responsive and works on:
- Mobile devices (Android, iOS)
- Web browsers (Chrome, Firefox, Safari, Edge)
- Tablets and iPads

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Firebase Auth**: Authentication service
- **Cloud Firestore**: Real-time database
- **Firebase Core**: Firebase integration
- **Material Design 3**: UI design system

## 📦 Dependencies

Key packages used:

```yaml
firebase_core: ^3.1.0
firebase_auth: ^5.1.0
cloud_firestore: ^5.0.1
flutter: sdk
```

## 🚨 Troubleshooting

### Blank Screen on Web
**Issue**: App shows blank screen when running in Chrome
**Solution**: Ensure Firebase options are properly configured in `firebase_options.dart`

### Firebase Connection Error
**Issue**: "FirebaseOptions cannot be null"
**Solution**: Check that `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` is called in `main.dart`

### Port Already in Use
**Issue**: "Only one usage of each socket address"
**Solution**: Use a different port:
```bash
flutter run -d chrome --web-port 5174
```

### Login Not Working
**Issue**: Login fails with "too-many-requests"
**Solution**: Wait a few minutes or reset Firebase security rules

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Support

For support and questions:
- Check the [Flutter Documentation](https://flutter.dev/docs)
- Visit [Firebase Documentation](https://firebase.google.com/docs)
- Open an issue in the repository

## 🔄 Future Enhancements

- [ ] Google Sign-In integration
- [ ] Password reset functionality
- [ ] Email verification
- [ ] Social media authentication
- [ ] User profile editing
- [ ] Dark mode toggle
- [ ] Push notifications
- [ ] Two-factor authentication

## 📊 Project Statistics

- **Lines of Code**: ~1000+
- **Files**: 9 main files
- **Supported Platforms**: Android, iOS, Web
- **Min Flutter Version**: 3.9.2

---

**Built with ❤️ using Flutter and Firebase**

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

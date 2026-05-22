import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => message;
}

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Future<void> _ensureInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  // Validation helper
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String password, {bool isSignup = false}) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (isSignup) {
      if (!password.contains(RegExp(r'[A-Z]'))) {
        return 'Password must contain at least one uppercase letter';
      }
      if (!password.contains(RegExp(r'[0-9]'))) {
        return 'Password must contain at least one number';
      }
    }
    return null;
  }

  // Get user-friendly error message from Firebase error code
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign in is not enabled.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use a stronger password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }

  // Signup
  Future<User?> signUp(
    String email,
    String password,
  ) async {
    try {
      // Validate inputs
      String? emailError = validateEmail(email);
      if (emailError != null) {
        throw AuthException(emailError);
      }

      String? passwordError = validatePassword(password, isSignup: true);
      if (passwordError != null) {
        throw AuthException(passwordError);
      }

      await _ensureInitialized();
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e), code: e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Sign up failed. Please try again.');
    }
  }

  // Login
  Future<User?> login(
    String email,
    String password,
  ) async {
    try {
      // Validate inputs
      String? emailError = validateEmail(email);
      if (emailError != null) {
        throw AuthException(emailError);
      }

      String? passwordError = validatePassword(password);
      if (passwordError != null) {
        throw AuthException(passwordError);
      }

      await _ensureInitialized();
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e), code: e.code);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Login failed. Please try again.');
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
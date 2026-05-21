import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  bool isLoading = false;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? generalError;

  void validateName() {
    setState(() {
      if (nameController.text.isEmpty) {
        nameError = 'Name is required';
      } else if (nameController.text.length < 2) {
        nameError = 'Name must be at least 2 characters';
      } else {
        nameError = null;
      }
    });
  }

  void validateEmail() {
    setState(() {
      emailError = authService.validateEmail(emailController.text);
    });
  }

  void validatePassword() {
    setState(() {
      passwordError = authService.validatePassword(passwordController.text, isSignup: true);
    });
  }

  void signup() async {
    // Clear previous errors
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      generalError = null;
    });

    // Validate all fields
    validateName();
    validateEmail();
    validatePassword();

    if (nameError != null || emailError != null || passwordError != null) {
      return;
    }

    setState(() => isLoading = true);

    try {
      var user = await authService.signUp(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        await firestoreService.saveUser(
          user.uid,
          nameController.text,
          emailController.text,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created successfully! Redirecting to login...'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 2),
          ),
        );

        // Wait for snackbar to show, then redirect
        await Future.delayed(Duration(seconds: 2));

        // Redirect to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        generalError = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.secondaryColor,
              AppTheme.secondaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join us today',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                ),
                SizedBox(height: 40),
                // General Error
                if (generalError != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.secondaryColor),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: AppTheme.secondaryColor, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            generalError!,
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Name Field
                Text(
                  'Full Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  onChanged: (_) => validateName(),
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person, color: AppTheme.secondaryColor),
                    hintText: 'Enter your full name',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                if (nameError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      nameError!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: nameError != null ? 16 : 24),
                // Email Field
                Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  onChanged: (_) => validateEmail(),
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.email, color: AppTheme.secondaryColor),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                if (emailError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      emailError!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: emailError != null ? 16 : 24),
                // Password Field
                Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  onChanged: (_) => validatePassword(),
                  obscureText: true,
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.lock, color: AppTheme.secondaryColor),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                if (passwordError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      passwordError!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: passwordError != null ? 16 : 24),
                // Password Requirements
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildPasswordRequirement(
                        'At least 6 characters',
                        passwordController.text.length >= 6,
                      ),
                      _buildPasswordRequirement(
                        'At least one uppercase letter',
                        passwordController.text.contains(RegExp(r'[A-Z]')),
                      ),
                      _buildPasswordRequirement(
                        'At least one number',
                        passwordController.text.contains(RegExp(r'[0-9]')),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                // Signup Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.secondaryColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.secondaryColor,
                              ),
                            ),
                          )
                        : Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool ismet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            ismet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: ismet ? AppTheme.successColor : Colors.white38,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: ismet ? AppTheme.successColor : Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import 'profile_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  String? emailError;
  String? passwordError;
  String? generalError;

  void validateEmail() {
    setState(() {
      emailError = authService.validateEmail(emailController.text);
    });
  }

  void validatePassword() {
    setState(() {
      passwordError = authService.validatePassword(passwordController.text);
    });
  }

  void login() async {
    // Clear previous errors
    setState(() {
      emailError = null;
      passwordError = null;
      generalError = null;
    });

    // Validate fields
    validateEmail();
    validatePassword();

    if (emailError != null || passwordError != null) {
      return;
    }

    setState(() => isLoading = true);

    try {
      var user = await authService.login(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(uid: user.uid),
          ),
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
              AppTheme.primaryColor,
              AppTheme.primaryLight,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  'Login to your account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                ),
                SizedBox(height: 50),
                // General Error
                if (generalError != null)
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryLight,
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
                    prefixIcon: Icon(Icons.email, color: AppTheme.primaryColor),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    errorText: emailError,
                  ),
                ),
                if (emailError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      emailError!,
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
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
                    prefixIcon: Icon(Icons.lock, color: AppTheme.primaryColor),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    errorText: passwordError,
                  ),
                ),
                if (passwordError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      passwordError!,
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                SizedBox(height: passwordError != null ? 32 : 40),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
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
                                AppTheme.primaryColor,
                              ),
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24),
                // Signup Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      ),
                      child: Text(
                        'Sign Up',
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
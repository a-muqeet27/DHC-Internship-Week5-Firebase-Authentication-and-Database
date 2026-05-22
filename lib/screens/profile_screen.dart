import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService firestoreService = FirestoreService();

  String name = "";
  String email = "";
  bool isLoading = true;
  String? errorMessage;
  int retryCount = 0;
  final int maxRetries = 3;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Add a small delay to ensure data is synced to Firestore
      await Future.delayed(Duration(seconds: 1));

      final userMap = await firestoreService.getUser(widget.uid);

      if (mounted) {
        setState(() {
          name = userMap['name'] ?? 'User';
          email = userMap['email'] ?? '';
          isLoading = false;
          errorMessage = null;
          retryCount = 0;
        });
      }
    } catch (e) {
      final errorMsg = e.toString();
      print('Error loading user data: $errorMsg');

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = errorMsg;
          name = '';
          email = '';
        });
      }
    }
  }

  void retryLoadUserData() {
    if (retryCount < maxRetries) {
      retryCount++;
      loadUserData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile after $maxRetries attempts. Please try again later.'),
          backgroundColor: AppTheme.secondaryColor,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  void logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: GestureDetector(
                onTap: logout,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.logout, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading your profile...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.secondaryColor,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Error Loading Profile',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: AppTheme.secondaryColor),
                          ),
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: retryLoadUserData,
                                icon: Icon(Icons.refresh),
                                label: Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: logout,
                                icon: Icon(Icons.logout),
                                label: Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.secondaryColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Profile Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryLight,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'U',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Name
                      Text(
                        name.isNotEmpty ? name : 'User',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 8),
                      // Email
                      Text(
                        email.isNotEmpty ? email : 'Email not available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                      SizedBox(height: 40),
                      // User Info Cards
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.person,
                              label: 'Full Name',
                              value: name.isNotEmpty ? name : 'Not set',
                            ),
                            Divider(color: AppTheme.borderColor, height: 24),
                            _buildInfoRow(
                              icon: Icons.email,
                              label: 'Email Address',
                              value: email.isNotEmpty ? email : 'Not set',
                            ),
                            Divider(color: AppTheme.borderColor, height: 24),
                            _buildInfoRow(
                              icon: Icons.verified_user,
                              label: 'User ID',
                              value: widget.uid.substring(0, 12) + '...',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: logout,
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreException implements Exception {
  final String message;
  final String? code;

  FirestoreException(this.message, {this.code});

  @override
  String toString() => message;
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference users;

  FirestoreService() {
    users = _firestore.collection('users');
    // Enable offline persistence
    _enableOfflinePersistence();
  }

  void _enableOfflinePersistence() {
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (e) {
      print('Error enabling offline persistence: $e');
    }
  }

  // Save user data
  Future<void> saveUser(
    String uid,
    String name,
    String email,
  ) async {
    try {
      if (uid.isEmpty || name.isEmpty || email.isEmpty) {
        throw FirestoreException('User data cannot be empty');
      }

      await users.doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Failed to save user: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException('Failed to save user data: ${e.toString()}');
    }
  }

  // Get user data with better error handling
  Future<Map<String, dynamic>> getUser(String uid) async {
    try {
      if (uid.isEmpty) {
        throw FirestoreException('User ID cannot be empty');
      }

      // Increased timeout to 30 seconds for better reliability
      final doc = await users.doc(uid).get().timeout(
            Duration(seconds: 30),
            onTimeout: () {
              throw FirestoreException(
                'Request timeout. Please check your internet connection and try again.',
              );
            },
          );

      if (!doc.exists) {
        // User document might not be created yet, return empty data
        return {
          'name': 'User',
          'email': '',
          'createdAt': null,
          'updatedAt': null,
        };
      }

      final data = doc.data() as Map<String, dynamic>;

      // Ensure required fields exist with fallback values
      return {
        'name': data['name']?.toString().trim() ?? 'User',
        'email': data['email']?.toString().trim() ?? '',
        'createdAt': data['createdAt'],
        'updatedAt': data['updatedAt'],
      };
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw FirestoreException(
          'You do not have permission to access this profile.',
        );
      } else if (e.code == 'unavailable') {
        throw FirestoreException(
          'Firestore is temporarily unavailable. Please try again in a moment.',
        );
      }
      throw FirestoreException(
        'Database error: ${e.message ?? e.code}',
        code: e.code,
      );
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(
        'Failed to load user profile. ${e.toString()}',
      );
    }
  }

  // Update user data
  Future<void> updateUser(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      if (uid.isEmpty) {
        throw FirestoreException('User ID cannot be empty');
      }

      data['updatedAt'] = FieldValue.serverTimestamp();

      await users.doc(uid).update(data);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Failed to update user: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException('Failed to update user: ${e.toString()}');
    }
  }

  // Delete user data
  Future<void> deleteUser(String uid) async {
    try {
      if (uid.isEmpty) {
        throw FirestoreException('User ID cannot be empty');
      }

      await users.doc(uid).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Failed to delete user: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException('Failed to delete user: ${e.toString()}');
    }
  }
}
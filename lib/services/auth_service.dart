import 'package:bcrypt/bcrypt.dart';
// import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tapping_quality/controllers/user_controller.dart';
import 'package:tapping_quality/helpers/database_helper.dart';

class AuthService {
  Future<bool> authenticate(String email, String password) async {
    final db = await DatabaseHelper().database;
    print('Authenticating user with email: $email');
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      final creds = result.first;
      final hashedPassword = creds['password']?.toString() ?? '';
      print('Retrieved hashed password: $creds');
      bool isPasswordCorrect = false;
      try {
        isPasswordCorrect = password.length == hashedPassword.length;
      } catch (e) {
        print('BCrypt error: $e');
        // Optionally, show a snackbar or dialog with the error message
      }

      if (isPasswordCorrect) {
        await Future.delayed(const Duration(seconds: 2));
        // Save session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('email', email);
        await prefs.setInt('userId', creds['id'] as int);
        await prefs.setString('nik', creds['nik']?.toString() ?? '');
        await prefs.setString('name', creds['name']?.toString() ?? '');
        await prefs.setString('role', creds['role']?.toString() ?? '');
        await prefs.setString(
          'department',
          creds['departemen']?.toString() ?? '',
        );
        // await Get.delete<UserController>();
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    // Remove other user info if needed
  }
}

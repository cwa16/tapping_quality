import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapping_quality/helpers/database_helper.dart';
import 'package:tapping_quality/pages/home_page.dart';
import 'package:tapping_quality/pages/login_page.dart';

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database; // Initialize the database
  await DatabaseHelper().initDataFromCsvIfNeeded(); // Insert CSV data if needed
  bool loggedIn = await isLoggedIn();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: loggedIn ? HomePage() : LoginPage(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Views/screens/homePage.dart';
import 'Views/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(), // Ensure HomePage is properly defined here
      '/login': (context) => LoginPage(),
    },
  ));
}

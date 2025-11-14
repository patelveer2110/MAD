// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/app_database.dart';
import 'providers/grade_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/course_screen.dart';
import 'screens/add_edit_grade_screen.dart';
import 'models/grade.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the local database
  await AppDatabase.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // App-level theme (keep simple and adjustable)
  ThemeData _buildTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      primaryColor: Colors.indigo,
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.indigo,
        secondary: Colors.teal,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 2,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 4,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide GradeProvider app-wide
    return ChangeNotifierProvider<GradeProvider>(
      create: (_) => GradeProvider()..loadAllGrades(),
      child: MaterialApp(
        title: 'Result & Grade Tracker',
        theme: _buildTheme(),
        debugShowCheckedModeBanner: false,
        // Named routes
        initialRoute: DashboardScreen.routeName,
        routes: {
          DashboardScreen.routeName: (ctx) => const DashboardScreen(),
          CourseScreen.routeName: (ctx) => const CourseScreen(),
        },
        // Use onGenerateRoute to support passing arguments to Add/Edit screen
        onGenerateRoute: (settings) {
          if (settings.name == AddEditGradeScreen.routeName) {
            final args = settings.arguments;
            // If an existing Grade is passed then open edit, otherwise add new
            if (args is Grade) {
              return MaterialPageRoute(
                builder: (ctx) => AddEditGradeScreen.edit(grade: args),
                settings: settings,
              );
            } else {
              return MaterialPageRoute(
                builder: (ctx) => const AddEditGradeScreen.add(),
                settings: settings,
              );
            }
          }

          // Unknown route fallback
          return MaterialPageRoute(
            builder: (ctx) => const DashboardScreen(),
            settings: settings,
          );
        },
      ),
    );
  }
}

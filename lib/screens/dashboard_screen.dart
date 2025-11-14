// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grade_provider.dart';
import '../screens/add_edit_grade_screen.dart';
import '../screens/course_screen.dart';
import '../widgets/grade_item.dart';
import '../widgets/small_chart.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = "/dashboard";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context);
    final recent = gradeProvider.recentGrades;
    final gpa = gradeProvider.gpa;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddEditGradeScreen.routeName);
        },
      ),

      body: RefreshIndicator(
        onRefresh: () => gradeProvider.loadAllGrades(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // GPA Card
            Card(
              elevation: 3,
              child: ListTile(
                title: const Text("Current GPA",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(gpa.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 20),

            // Trend Chart Placeholder
            const Text(
              "Performance Trend",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 150, child: SmallChart()),

            const SizedBox(height: 25),

            // Recent Grades
            const Text(
              "Recent Grades",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            if (recent.isEmpty)
              const Center(child: Text("No grades added yet.")),

            ...recent.map((g) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      CourseScreen.routeName,
                      arguments: g.courseCode,
                    );
                  },
                  child: GradeItem(grade: g),
                )),
          ],
        ),
      ),
    );
  }
}

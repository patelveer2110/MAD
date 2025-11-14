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
    final p = Provider.of<GradeProvider>(context);
    final recent = p.recentGrades;
    final gpa = p.gpa;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 20),
        onPressed: () {
          Navigator.pushNamed(context, AddEditGradeScreen.routeName);
        },
      ),

      body: RefreshIndicator(
        onRefresh: () => p.loadAllGrades(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [

            // ------------------------- GPA ---------------------------
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("GPA"),
                  Text(
                    gpa.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------- Trend Chart -----------------------
            const Text("Trend", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 150,
                color: Colors.grey.shade100,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SmallChart(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --------------------- Recent Grades ----------------------
            const Text("Recent Grades", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),

            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    "Nothing added yet.",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),

            ...recent.map(
              (g) => InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CourseScreen.routeName,
                    arguments: g.courseCode,
                  );
                },
                child: GradeItem(grade: g),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

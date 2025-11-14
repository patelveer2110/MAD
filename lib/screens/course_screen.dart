import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grade_provider.dart';
import '../widgets/grade_item.dart';
import 'add_edit_grade_screen.dart';

class CourseScreen extends StatelessWidget {
  static const routeName = "/course";

  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseCode = ModalRoute.of(context)!.settings.arguments as String;
    final gradeProvider = Provider.of<GradeProvider>(context);
    final courseGrades = gradeProvider.getByCourse(courseCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(courseCode),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddEditGradeScreen.routeName);
        },
        child: const Icon(Icons.add, size: 20),
      ),

      body: courseGrades.isEmpty
          ? const Center(
              child: Text(
                "No assessments yet.",
                style: TextStyle(fontSize: 14),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: courseGrades.length,
              itemBuilder: (context, index) {
                final g = courseGrades[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AddEditGradeScreen.routeName,
                      arguments: g,
                    );
                  },
                  child: GradeItem(grade: g),
                );
              },
            ),
    );
  }
}

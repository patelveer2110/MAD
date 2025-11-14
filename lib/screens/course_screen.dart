// lib/screens/course_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grade_provider.dart';
import '../models/grade.dart';
import '../widgets/grade_item.dart';
import 'add_edit_grade_screen.dart';

class CourseScreen extends StatelessWidget {
  static const routeName = "/course";

  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // we expect to receive a courseCode from arguments
    final courseCode = ModalRoute.of(context)!.settings.arguments as String;
    final gradeProvider = Provider.of<GradeProvider>(context);
    final courseGrades = gradeProvider.getByCourse(courseCode);

    return Scaffold(
      appBar: AppBar(
        title: Text("Course: $courseCode"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Allow adding for same course but user may edit fields
          Navigator.pushNamed(
            context,
            AddEditGradeScreen.routeName,
          );
        },
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "$courseGrades.length Assessments Found",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          ...courseGrades.map((g) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddEditGradeScreen.routeName,
                    arguments: g,
                  );
                },
                child: GradeItem(grade: g),
              )),
        ],
      ),
    );
  }
}

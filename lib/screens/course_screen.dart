// lib/screens/course_screen.dart

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
    // receive course code
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
          Navigator.pushNamed(context, AddEditGradeScreen.routeName);
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: courseGrades.isEmpty
            ? const Center(
                child: Text(
                  "No assessments added for this course yet.",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${courseGrades.length} Assessment(s) Found",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: courseGrades.length,
                      itemBuilder: (context, i) {
                        final g = courseGrades[i];
                        return GestureDetector(
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
                  ),
                ],
              ),
      ),
    );
  }
}

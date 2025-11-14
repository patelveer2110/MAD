// lib/widgets/grade_item.dart

import 'package:flutter/material.dart';
import '../models/grade.dart';

class GradeItem extends StatelessWidget {
  final Grade grade;

  const GradeItem({super.key, required this.grade});

  Color _getGradeColor(String gradeLetter) {
    switch (gradeLetter) {
      case "A+":
      case "A":
        return Colors.green;
      case "B":
        return Colors.blue;
      case "C":
        return Colors.orange;
      case "D":
        return Colors.redAccent;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = grade.percentage.toStringAsFixed(1);
    final gradeLetter = grade.gradeLetter;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Grade badge
            CircleAvatar(
              radius: 28,
              backgroundColor: _getGradeColor(gradeLetter).withOpacity(0.15),
              child: Text(
                gradeLetter,
                style: TextStyle(
                  color: _getGradeColor(gradeLetter),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade.courseCode,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    grade.assessmentType,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Marks: ${grade.obtainedMarks}/${grade.maxMarks}  (${percentage}%)",
                    style: const TextStyle(fontSize: 14),
                  ),

                  if (grade.term != null)
                    Text(
                      "Term: ${grade.term}",
                      style: const TextStyle(fontSize: 13),
                    )
                ],
              ),
            ),

            // Date
            Column(
              children: [
                Text(
                  "${grade.date.day}/${grade.date.month}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  grade.date.year.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

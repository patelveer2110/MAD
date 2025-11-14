// lib/utils/gpa_calculator.dart

import '../models/grade.dart';

class GpaCalculator {
  // Convert percentage to grade point (example scale).
  static double _gradePointFromPercent(double p) {
    if (p >= 90) return 10;
    if (p >= 80) return 9;
    if (p >= 70) return 8;
    if (p >= 60) return 7;
    if (p >= 50) return 6;
    if (p >= 40) return 5;
    return 0;
  }

  /// Calculate GPA by first averaging percentages per course,
  /// then mapping average percent to a grade point and averaging those.
  static double calculateGpa(List<Grade> grades) {
    if (grades.isEmpty) return 0.0;

    final Map<String, List<Grade>> byCourse = {};
    for (final g in grades) {
      byCourse.putIfAbsent(g.courseCode, () => []).add(g);
    }

    double totalPoints = 0.0;
    int courseCount = 0;

    byCourse.forEach((course, list) {
      final avgPercent =
          list.map((e) => e.percentage).reduce((a, b) => a + b) / list.length;
      totalPoints += _gradePointFromPercent(avgPercent);
      courseCount += 1;
    });

    if (courseCount == 0) return 0.0;
    final gpa = totalPoints / courseCount;
    return double.parse(gpa.toStringAsFixed(2));
  }

  /// Forecast GPA if you add a hypothetical grade
  static double forecastGpa(List<Grade> grades, Grade hypothetical) {
    final copy = List<Grade>.from(grades)..add(hypothetical);
    return calculateGpa(copy);
  }

  // ------------------------------
  // Helper funcs used by PDF etc.
  // ------------------------------

  /// Convert marks to percentage (safe division).
  static double marksToPercentage(double obtained, double maxMarks) {
    if (maxMarks <= 0) return 0.0;
    return (obtained / maxMarks) * 100.0;
  }

  /// Convert a percentage to the GPA-point mapping used in calculateGpa.
  /// Exposed so PDF/export code can show per-row GPA value.
  static double percentageToGpa(double percent) {
    return _gradePointFromPercent(percent);
  }
}

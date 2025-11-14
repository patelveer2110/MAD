// lib/providers/grade_provider.dart

import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../models/grade.dart';
import '../utils/gpa_calculator.dart';

class GradeProvider extends ChangeNotifier {
  List<Grade> _grades = [];
  double _gpa = 0.0;

  List<Grade> get grades => _grades;
  double get gpa => _gpa;

  /// Load all grades from DB (called from main.dart)
  Future<void> loadAllGrades() async {
    _grades = await AppDatabase.instance.getAllGrades();
    _recalculateGPA();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  Future<void> addGrade(Grade grade) async {
    await AppDatabase.instance.insertGrade(grade);
    await loadAllGrades(); // reload list + GPA
  }

  Future<void> updateGrade(Grade grade) async {
    if (grade.id == null) return;

    await AppDatabase.instance.updateGrade(grade);
    await loadAllGrades();
  }

  Future<void> deleteGrade(int id) async {
    await AppDatabase.instance.deleteGrade(id);
    await loadAllGrades();
  }

  // ---------------------------------------------------------------------------
  // FILTERS & HELPERS
  // ---------------------------------------------------------------------------

  /// Grades grouped by courseCode
  Map<String, List<Grade>> get gradesByCourse {
    Map<String, List<Grade>> map = {};
    for (var g in _grades) {
      map.putIfAbsent(g.courseCode, () => []);
      map[g.courseCode]!.add(g);
    }
    return map;
  }

  /// Filter by course code
  List<Grade> getByCourse(String courseCode) {
    return _grades.where((g) => g.courseCode == courseCode).toList();
  }

  /// Filter by term/semester
  List<Grade> getByTerm(String term) {
    return _grades.where((g) => g.term == term).toList();
  }

  /// Get recent entries (latest 5)
  List<Grade> get recentGrades {
    List<Grade> sorted = [..._grades];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }
  
  get GPACalculator => null;

  // ---------------------------------------------------------------------------
  // GPA CALCULATION
  // ---------------------------------------------------------------------------

  void _recalculateGPA() {
    _gpa = GPACalculator.calculateGPA(_grades);
  }
}

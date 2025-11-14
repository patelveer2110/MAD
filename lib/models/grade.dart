// lib/models/grade.dart

import 'package:flutter/foundation.dart';

/// Represents a single grade entry in the system.
class Grade {
  final int? id; // Primary Key from SQLite
  final String courseCode;
  final String assessmentType; // Midterm / Final / Assignment
  final double maxMarks;
  final double obtainedMarks;
  final DateTime date;
  final String? remarks;
  final String? scannedFilePath; // Local path to stored marksheet image/PDF
  final String? term; // Optional: e.g., "Sem 1", "Sem 2"

  Grade({
    this.id,
    required this.courseCode,
    required this.assessmentType,
    required this.maxMarks,
    required this.obtainedMarks,
    required this.date,
    this.remarks,
    this.scannedFilePath,
    this.term,
  });

  /// Percentage calculation
  double get percentage =>
      maxMarks == 0 ? 0 : (obtainedMarks / maxMarks) * 100;

  /// Convert percentage into grade letter (customizable)
  String get gradeLetter {
    final pct = percentage;
    if (pct >= 90) return "A+";
    if (pct >= 80) return "A";
    if (pct >= 70) return "B";
    if (pct >= 60) return "C";
    if (pct >= 50) return "D";
    return "F";
  }

  /// Convert Grade object → SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseCode': courseCode,
      'assessmentType': assessmentType,
      'maxMarks': maxMarks,
      'obtainedMarks': obtainedMarks,
      'date': date.toIso8601String(),
      'remarks': remarks,
      'scannedFilePath': scannedFilePath,
      'term': term,
    };
  }

  /// Create Grade object from SQLite Map
  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'] as int?,
      courseCode: map['courseCode'] ?? '',
      assessmentType: map['assessmentType'] ?? '',
      maxMarks: (map['maxMarks'] as num).toDouble(),
      obtainedMarks: (map['obtainedMarks'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      remarks: map['remarks'],
      scannedFilePath: map['scannedFilePath'],
      term: map['term'],
    );
  }

  /// Create a new modified copy
  Grade copyWith({
    int? id,
    String? courseCode,
    String? assessmentType,
    double? maxMarks,
    double? obtainedMarks,
    DateTime? date,
    String? remarks,
    String? scannedFilePath,
    String? term,
  }) {
    return Grade(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      assessmentType: assessmentType ?? this.assessmentType,
      maxMarks: maxMarks ?? this.maxMarks,
      obtainedMarks: obtainedMarks ?? this.obtainedMarks,
      date: date ?? this.date,
      remarks: remarks ?? this.remarks,
      scannedFilePath: scannedFilePath ?? this.scannedFilePath,
      term: term ?? this.term,
    );
  }

  @override
  String toString() {
    return "Grade(id: $id, course: $courseCode, type: $assessmentType, "
        "marks: $obtainedMarks / $maxMarks, date: $date)";
  }
}

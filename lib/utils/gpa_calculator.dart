// utils/gpa_calculator.dart

class GPACalculator {
  /// Convert percentage to GPA (simple 10-point scale)
  static double percentageToGpa(double percentage) {
    if (percentage >= 90) return 10.0;
    if (percentage >= 80) return 9.0;
    if (percentage >= 70) return 8.0;
    if (percentage >= 60) return 7.0;
    if (percentage >= 50) return 6.0;
    if (percentage >= 45) return 5.0;
    if (percentage >= 40) return 4.0;
    return 0.0;
  }

  /// Calculate GPA from list of percentages
  static double calculateTermGpa(List<double> percentages) {
    if (percentages.isEmpty) return 0.0;
    final gpas = percentages.map((p) => percentageToGpa(p)).toList();
    final total = gpas.reduce((a, b) => a + b);
    return double.parse((total / gpas.length).toStringAsFixed(2));
  }

  /// Convert obtained & max marks to percentage
  static double marksToPercentage(double obtained, double max) {
    if (max == 0) return 0.0;
    return (obtained / max) * 100;
  }
}

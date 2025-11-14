// lib/widgets/small_chart.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grade_provider.dart';
import '../models/grade.dart';

class SmallChart extends StatelessWidget {
  // optional fixed width can be provided by parent; default will be flexible.
  final double? width;
  final double height;

  const SmallChart({super.key, this.width, this.height = 48});

  @override
  Widget build(BuildContext context) {
    final grades = Provider.of<GradeProvider>(context).grades;

    if (grades.isEmpty) {
      return SizedBox(
        width: width,
        height: height,
        child: const Center(child: Text("No data", style: TextStyle(fontSize: 10, color: Colors.grey))),
      );
    }

    final sorted = [...grades]..sort((a, b) => a.date.compareTo(b.date));

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SmallChartPainter(sorted),
      ),
    );
  }
}

class _SmallChartPainter extends CustomPainter {
  final List<Grade> grades;
  _SmallChartPainter(this.grades);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final paintDot = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    if (grades.isEmpty) return;

    final int n = grades.length;
    // avoid division by zero
    final double gap = n == 1 ? 0 : size.width / (n - 1);

    Path path = Path();

    for (int i = 0; i < n; i++) {
      final double x = n == 1 ? size.width / 2 : gap * i;
      double pct = grades[i].percentage;
      if (pct.isNaN) pct = 0.0;
      // clamp percent 0..100
      pct = pct.clamp(0.0, 100.0);
      final double y = size.height - (pct / 100.0 * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      // small dot
      canvas.drawCircle(Offset(x, y), 2.0, paintDot);
    }

    // draw smooth (you can keep straight path for performance)
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
    
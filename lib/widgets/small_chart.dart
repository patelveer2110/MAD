// lib/widgets/small_chart.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/grade_provider.dart';

class SmallChart extends StatelessWidget {
  const SmallChart({super.key});

  @override
  Widget build(BuildContext context) {
    final grades = Provider.of<GradeProvider>(context).grades;

    if (grades.isEmpty) {
      return const Center(
          child: Text(
        "No data",
        style: TextStyle(color: Colors.grey),
      ));
    }

    final sorted = [...grades]..sort((a, b) => a.date.compareTo(b.date));

    return SizedBox(
      height: 140,
      child: CustomPaint(
        painter: _SmallChartPainter(sorted),
      ),
    );
  }
}

class _SmallChartPainter extends CustomPainter {
  final List grades;
  _SmallChartPainter(this.grades);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintDot = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    double gap = size.width / (grades.length - 1);

    Path path = Path();

    for (int i = 0; i < grades.length; i++) {
      double x = gap * i;
      double y = size.height - (grades[i].percentage / 100 * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // dot
      canvas.drawCircle(Offset(x, y), 2.5, paintDot);
    }

    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

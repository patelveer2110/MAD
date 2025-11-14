// lib/utils/pdf_export.dart

import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/grade.dart';
import 'gpa_calculator.dart';

class PDFExport {
  static Future<Uint8List> generateTranscriptPdf({
    required List<Grade> grades,
    required double overallGpa,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                "Academic Transcript",
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Text("Overall GPA: ${overallGpa.toStringAsFixed(2)}",
                style: pw.TextStyle(
                    fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              border: pw.TableBorder.all(),
              headers: [
                "Course",
                "Type",
                "Marks",
                "Percentage",
                "GPA",
                "Date",
              ],
              data: grades.map((g) {
                // use the Grade.percentage getter and GpaCalculator helpers
                final percent = GpaCalculator.marksToPercentage(
                    g.obtainedMarks, g.maxMarks);
                final gpa = GpaCalculator.percentageToGpa(percent);

                return [
                  g.courseCode,
                  g.assessmentType,
                  "${g.obtainedMarks}/${g.maxMarks}",
                  percent.toStringAsFixed(1),
                  gpa.toStringAsFixed(1),
                  g.date.toIso8601String().substring(0, 10),
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Generated on ${DateTime.now().toIso8601String().substring(0, 10)}",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Opens print preview (also allows saving PDF)
  static Future<void> exportTranscript({
    required List<Grade> grades,
    required double gpa,
  }) async {
    final pdfData = await generateTranscriptPdf(
      grades: grades,
      overallGpa: gpa,
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdfData,
    );
  }
}

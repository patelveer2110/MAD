// lib/screens/add_edit_grade_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/grade.dart';
import '../providers/grade_provider.dart';

class AddEditGradeScreen extends StatefulWidget {
  static const routeName = "/add-edit-grade";

  final Grade? grade;

  const AddEditGradeScreen.add({super.key}) : grade = null;
  const AddEditGradeScreen.edit({required this.grade, super.key});

  @override
  State<AddEditGradeScreen> createState() => _AddEditGradeScreenState();
}

class _AddEditGradeScreenState extends State<AddEditGradeScreen> {
  final _formKey = GlobalKey<FormState>();

  late String courseCode;
  late String assessmentType;
  late double maxMarks;
  late double obtainedMarks;
  late DateTime selectedDate;
  String? remarks;
  String? term;

  @override
  void initState() {
    super.initState();

    final g = widget.grade;

    courseCode = g?.courseCode ?? "";
    assessmentType = g?.assessmentType ?? "Midterm";
    maxMarks = g?.maxMarks ?? 100;
    obtainedMarks = g?.obtainedMarks ?? 0;
    selectedDate = g?.date ?? DateTime.now();
    remarks = g?.remarks;
    term = g?.term ?? "Sem 1";
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final gp = Provider.of<GradeProvider>(context, listen: false);

    final grade = Grade(
      id: widget.grade?.id,
      courseCode: courseCode,
      assessmentType: assessmentType,
      maxMarks: maxMarks,
      obtainedMarks: obtainedMarks,
      date: selectedDate,
      remarks: remarks,
      term: term,
    );

    if (widget.grade == null) {
      await gp.addGrade(grade);
    } else {
      await gp.updateGrade(grade);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.grade != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Grade" : "Add Grade"),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await Provider.of<GradeProvider>(context, listen: false)
                    .deleteGrade(widget.grade!.id!);
                Navigator.pop(context);
              },
            )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Course Code
              TextFormField(
                initialValue: courseCode,
                decoration: const InputDecoration(labelText: "Course Code"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter course code" : null,
                onSaved: (v) => courseCode = v!.trim(),
              ),

              // Assessment Type
              DropdownButtonFormField(
                value: assessmentType,
                decoration:
                    const InputDecoration(labelText: "Assessment Type"),
                items: const [
                  DropdownMenuItem(value: "Midterm", child: Text("Midterm")),
                  DropdownMenuItem(value: "Final", child: Text("Final")),
                  DropdownMenuItem(value: "Assignment", child: Text("Assignment")),
                ],
                onChanged: (v) => assessmentType = v.toString(),
              ),

              // Max Marks
              TextFormField(
                initialValue: maxMarks.toString(),
                decoration: const InputDecoration(labelText: "Max Marks"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || double.tryParse(v) == null ? "Invalid" : null,
                onSaved: (v) => maxMarks = double.parse(v!),
              ),

              // Obtained Marks
              TextFormField(
                initialValue: obtainedMarks.toString(),
                decoration:
                    const InputDecoration(labelText: "Obtained Marks"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || double.tryParse(v) == null ? "Invalid" : null,
                onSaved: (v) => obtainedMarks = double.parse(v!),
              ),

              // Term
              DropdownButtonFormField(
                value: term,
                decoration: const InputDecoration(labelText: "Term"),
                items: const [
                  DropdownMenuItem(value: "Sem 1", child: Text("Sem 1")),
                  DropdownMenuItem(value: "Sem 2", child: Text("Sem 2")),
                  DropdownMenuItem(value: "Sem 3", child: Text("Sem 3")),
                  DropdownMenuItem(value: "Sem 4", child: Text("Sem 4")),
                ],
                onChanged: (v) => term = v.toString(),
              ),

              // Remarks
              TextFormField(
                initialValue: remarks,
                decoration: const InputDecoration(labelText: "Remarks"),
                onSaved: (v) => remarks = v,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? "Update" : "Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

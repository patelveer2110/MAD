// lib/screens/add_edit_grade_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/grade.dart';
import '../providers/grade_provider.dart';

class AddEditGradeScreen extends StatefulWidget {
  static const routeName = "/add-edit-grade";

  final Grade? grade;

  const AddEditGradeScreen({super.key, this.grade});

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
    remarks = g?.remarks ?? "";
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
        centerTitle: true,
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
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _simpleField(
                label: "Course Code",
                initial: courseCode,
                onSave: (v) => courseCode = v!,
              ),

              const SizedBox(height: 12),

              _simpleDropdown(
                label: "Assessment Type",
                value: assessmentType,
                items: ["Midterm", "Final", "Assignment"],
                onChanged: (v) => assessmentType = v!,
              ),

              const SizedBox(height: 12),

              _simpleField(
                label: "Max Marks",
                initial: maxMarks.toString(),
                number: true,
                onSave: (v) => maxMarks = double.parse(v!),
              ),

              const SizedBox(height: 12),

              _simpleField(
                label: "Obtained Marks",
                initial: obtainedMarks.toString(),
                number: true,
                onSave: (v) => obtainedMarks = double.parse(v!),
              ),

              const SizedBox(height: 12),

              _simpleDropdown(
                label: "Term",
                value: term!,
                items: ["Sem 1", "Sem 2", "Sem 3", "Sem 4"],
                onChanged: (v) => term = v!,
              ),

              const SizedBox(height: 12),

              _simpleField(
                label: "Remarks",
                initial: remarks,
                onSave: (v) => remarks = v,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isEdit ? "Update" : "Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // REUSABLE SIMPLE WIDGETS
  // -------------------------------------------------------------

  Widget _simpleField({
    required String label,
    required String? initial,
    required FormFieldSetter<String?> onSave,
    bool number = false,
  }) {
    return TextFormField(
      initialValue: initial,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
      onSaved: onSave,
    );
  }

  Widget _simpleDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/gpa_calculation/presentation/bloc/gpa_bloc.dart';
import '../../../../shared/models/course.dart';
import '../../../../shared/models/semester.dart';
import '../../../../shared/widgets/analyzer_card.dart';
import '../../../../shared/widgets/course_row.dart';
import '../../../../shared/widgets/gpa_result_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Each semester holds a list of CourseRowData
  final List<List<CourseRowData>> _semesters = [];
  Map<int, double> _semesterGPAs = {};
  double? _cgpa;

  @override
  void initState() {
    super.initState();
    _loadFromStorage();
  }

  @override
  void dispose() {
    for (final sem in _semesters) {
      for (final row in sem) {
        row.dispose();
      }
    }
    super.dispose();
  }

  // ── Storage ──────────────────────────────────────────────────────────────

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.coursesStorageKey);
    if (raw == null) {
      _addSemester();
      return;
    }
    try {
      final List decoded = jsonDecode(raw) as List;
      setState(() {
        _semesters.clear();
        for (final semList in decoded) {
          final rows = (semList as List).map((c) {
            return CourseRowData(
              name: c['name'] as String?,
              credits: c['credits'] as String?,
              grade: c['grade'] as String?,
            );
          }).toList();
          _semesters.add(rows.isEmpty ? [CourseRowData()] : rows);
        }
        if (_semesters.isEmpty) _semesters.add([CourseRowData()]);
      });
      _recalculate();
    } catch (_) {
      _addSemester();
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _semesters.map((sem) {
      return sem.map((row) => {
            'name': row.nameController.text,
            'credits': row.creditsController.text,
            'grade': row.selectedGrade,
          }).toList();
    }).toList();
    await prefs.setString(AppConstants.coursesStorageKey, jsonEncode(data));
  }

  // ── Semester management ───────────────────────────────────────────────────

  void _addSemester() {
    setState(() => _semesters.add([CourseRowData()]));
    _recalculate();
  }

  void _removeSemester(int index) {
    for (final row in _semesters[index]) {
      row.dispose();
    }
    setState(() => _semesters.removeAt(index));
    _recalculate();
  }

  void _addCourse(int semIndex) {
    setState(() => _semesters[semIndex].add(CourseRowData()));
    _recalculate();
  }

  void _removeCourse(int semIndex, int courseIndex) {
    _semesters[semIndex][courseIndex].dispose();
    setState(() => _semesters[semIndex].removeAt(courseIndex));
    _recalculate();
  }

  // ── GPA calculation ───────────────────────────────────────────────────────

  void _recalculate() {
    final semesters = <Semester>[];
    for (int i = 0; i < _semesters.length; i++) {
      final validCourses = _semesters[i]
          .where((r) => r.isValid)
          .map((r) => Course(
                name: r.nameController.text.trim().isEmpty
                    ? 'Course ${_semesters[i].indexOf(r) + 1}'
                    : r.nameController.text.trim(),
                credits: r.credits,
                grade: r.gradePoints,
              ))
          .toList();
      semesters.add(Semester(number: i, courses: validCourses));
    }
    context.read<GpaBloc>().add(CalculateGpaEvent(semesters));
    _saveToStorage();
  }

  void _resetAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset everything?',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
        content: const Text(
          'This will clear all semesters and courses.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              for (final sem in _semesters) {
                for (final row in sem) row.dispose();
              }
              setState(() {
                _semesters.clear();
                _semesters.add([CourseRowData()]);
                _semesterGPAs = {};
                _cgpa = null;
              });
              _saveToStorage();
            },
            child: const Text('Reset',
                style: TextStyle(color: AppColors.gpaLow)),
          ),
        ],
      ),
    );
  }

  Map<String, double> get _allGrades {
    final grades = <String, double>{};
    for (final sem in _semesters) {
      for (final row in sem) {
        if (row.isValid) {
          final name = row.nameController.text.trim().isEmpty
              ? 'Course'
              : row.nameController.text.trim();
          grades[name] = row.gradePoints;
        }
      }
    }
    return grades;
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<GpaBloc, GpaState>(
      listener: (context, state) {
        if (state is GpaCalculated) {
          setState(() {
            _semesterGPAs = state.result.semesterGpas;
            _cgpa = state.result.finalCgpa;
          });
        } else if (state is GpaError) {
          setState(() {
            _semesterGPAs = {};
            _cgpa = null;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // GPA result
                  GpaResultCard(
                    cgpa: _cgpa,
                    semesterGpas: _semesterGPAs,
                  ),
                  if (_cgpa != null) ...[
                    const SizedBox(height: 12),
                    AnalyzerCard(grades: _allGrades),
                  ],
                  const SizedBox(height: 28),
                  // Semesters
                  ..._buildSemesters(),
                  const SizedBox(height: 16),
                  // Add semester button
                  _AddSemesterButton(onTap: _addSemester),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.bg,
      pinned: true,
      expandedHeight: 100,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GradeMaster',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'GPA Calculator',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            _ResetButton(onTap: _resetAll),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSemesters() {
    return List.generate(_semesters.length, (semIndex) {
      return _SemesterSection(
        key: ValueKey('sem_$semIndex'),
        semesterIndex: semIndex,
        courses: _semesters[semIndex],
        semesterGpa: _semesterGPAs[semIndex],
        canRemove: _semesters.length > 1,
        onRemoveSemester: () => _removeSemester(semIndex),
        onAddCourse: () => _addCourse(semIndex),
        onRemoveCourse: (i) => _removeCourse(semIndex, i),
        onChanged: _recalculate,
      );
    });
  }
}

// ── Semester section ──────────────────────────────────────────────────────────

class _SemesterSection extends StatelessWidget {
  final int semesterIndex;
  final List<CourseRowData> courses;
  final double? semesterGpa;
  final bool canRemove;
  final VoidCallback onRemoveSemester;
  final VoidCallback onAddCourse;
  final Function(int) onRemoveCourse;
  final VoidCallback onChanged;

  const _SemesterSection({
    super.key,
    required this.semesterIndex,
    required this.courses,
    required this.semesterGpa,
    required this.canRemove,
    required this.onRemoveSemester,
    required this.onAddCourse,
    required this.onRemoveCourse,
    required this.onChanged,
  });

  Color _gpaColor(double gpa) {
    if (gpa >= AppConstants.gpaHighThreshold) return AppColors.gpaHigh;
    if (gpa >= AppConstants.gpaMidThreshold) return AppColors.gpaMid;
    return AppColors.gpaLow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Semester ${semesterIndex + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLight,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              if (semesterGpa != null)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    'GPA: ${semesterGpa!.toStringAsFixed(2)}',
                    key: ValueKey(semesterGpa!.toStringAsFixed(2)),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _gpaColor(semesterGpa!),
                    ),
                  ),
                ),
              if (canRemove) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onRemoveSemester,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.gpaLow.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        size: 15, color: AppColors.gpaLow),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Course rows
          ...List.generate(courses.length, (i) {
            return CourseRow(
              key: ValueKey('${semesterIndex}_$i'),
              index: i,
              data: courses[i],
              onDelete: courses.length > 1
                  ? () => onRemoveCourse(i)
                  : () {},
              onChanged: onChanged,
            );
          }),
          // Add course
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onAddCourse,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    style: BorderStyle.solid),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded,
                      size: 16, color: AppColors.primaryLight),
                  SizedBox(width: 6),
                  Text(
                    'Add Course',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add semester button ───────────────────────────────────────────────────────

class _AddSemesterButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddSemesterButton({required this.onTap});

  @override
  State<_AddSemesterButton> createState() => _AddSemesterButtonState();
}

class _AddSemesterButtonState extends State<_AddSemesterButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline_rounded,
                  size: 18,
                  color: _hovered ? AppColors.primary : AppColors.textMuted),
              const SizedBox(width: 8),
              Text(
                'Add Semester',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reset button ──────────────────────────────────────────────────────────────

class _ResetButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ResetButton({required this.onTap});

  @override
  State<_ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<_ResetButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.gpaLow.withOpacity(0.12)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? AppColors.gpaLow.withOpacity(0.4)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded,
                  size: 14,
                  color: _hovered ? AppColors.gpaLow : AppColors.textMuted),
              const SizedBox(width: 5),
              Text(
                'Reset',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? AppColors.gpaLow : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

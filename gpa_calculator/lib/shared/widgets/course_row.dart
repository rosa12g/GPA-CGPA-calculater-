import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class CourseRowData {
  final TextEditingController nameController;
  final TextEditingController creditsController;
  String selectedGrade;

  CourseRowData({
    String? name,
    String? credits,
    String? grade,
  })  : nameController = TextEditingController(text: name ?? ''),
        creditsController = TextEditingController(text: credits ?? ''),
        selectedGrade = grade ?? 'A';

  void dispose() {
    nameController.dispose();
    creditsController.dispose();
  }

  bool get isValid {
    final credits = double.tryParse(creditsController.text);
    return credits != null && credits > 0 && credits <= AppConstants.maxCredits;
  }

  double get gradePoints => AppConstants.gradeOptions[selectedGrade] ?? 0.0;
  double get credits => double.tryParse(creditsController.text) ?? 0.0;
}

class CourseRow extends StatefulWidget {
  final int index;
  final CourseRowData data;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const CourseRow({
    super.key,
    required this.index,
    required this.data,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<CourseRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Index badge
              Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(top: 10, right: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${widget.index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
              ),
              // Fields
              Expanded(
                child: Column(
                  children: [
                    // Course name
                    TextField(
                      controller: widget.data.nameController,
                      onChanged: (_) => widget.onChanged(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Course name (optional)',
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Credits
                        Expanded(
                          child: TextField(
                            controller: widget.data.creditsController,
                            onChanged: (_) => widget.onChanged(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Credits',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Grade dropdown
                        Expanded(
                          child: _GradeDropdown(
                            value: widget.data.selectedGrade,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => widget.data.selectedGrade = val);
                                widget.onChanged();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete button
              GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  margin: const EdgeInsets.only(top: 8, left: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.gpaLow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: AppColors.gpaLow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _GradeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.expand_more_rounded,
              size: 18, color: AppColors.textSecondary),
          items: AppConstants.gradeOptions.keys
              .map(
                (grade) => DropdownMenuItem(
                  value: grade,
                  child: Text(
                    '$grade  (${AppConstants.gradeOptions[grade]!.toStringAsFixed(1)})',
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

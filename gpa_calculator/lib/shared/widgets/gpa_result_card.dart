import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class GpaResultCard extends StatelessWidget {
  final double? cgpa;
  final Map<int, double> semesterGpas;

  const GpaResultCard({
    super.key,
    required this.cgpa,
    required this.semesterGpas,
  });

  Color _gpaColor(double gpa) {
    if (gpa >= AppConstants.gpaHighThreshold) return AppColors.gpaHigh;
    if (gpa >= AppConstants.gpaMidThreshold) return AppColors.gpaMid;
    return AppColors.gpaLow;
  }

  String _gpaLabel(double gpa) {
    if (gpa >= AppConstants.gpaHighThreshold) return 'Excellent';
    if (gpa >= AppConstants.gpaMidThreshold) return 'Good';
    if (gpa >= 1.0) return 'Needs Work';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    if (cgpa == null) return const SizedBox.shrink();

    final color = _gpaColor(cgpa!);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: Container(
        key: ValueKey(cgpa!.toStringAsFixed(2)),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // CGPA display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUMULATIVE GPA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _AnimatedGpaNumber(value: cgpa!, color: color),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _gpaLabel(cgpa!),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            // Semester breakdown
            if (semesterGpas.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: semesterGpas.entries.map((e) {
                  final semColor = _gpaColor(e.value);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: semColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: semColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'SEM ${e.key + 1}',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e.value.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: semColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedGpaNumber extends StatefulWidget {
  final double value;
  final Color color;

  const _AnimatedGpaNumber({required this.value, required this.color});

  @override
  State<_AnimatedGpaNumber> createState() => _AnimatedGpaNumberState();
}

class _AnimatedGpaNumberState extends State<_AnimatedGpaNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  double _prev = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedGpaNumber old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _prev = old.value;
      _anim = Tween<double>(begin: _prev, end: widget.value)
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Text(
        _anim.value.toStringAsFixed(2),
        style: TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.w800,
          color: widget.color,
          letterSpacing: -2,
          height: 1,
        ),
      ),
    );
  }
}

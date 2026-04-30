import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../features/analysis/presentation/bloc/analysis_bloc.dart';

class AnalyzerCard extends StatelessWidget {
  final Map<String, double> grades;

  const AnalyzerCard({super.key, required this.grades});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AnalysisState state) {
    if (state is AnalysisLoading) {
      return _CardShell(
        key: const ValueKey('loading'),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Analyzing your performance...',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (state is AnalysisError) {
      return _CardShell(
        key: const ValueKey('error'),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.gpaLow, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                state.message,
                style: const TextStyle(
                    color: AppColors.gpaLow, fontSize: 13),
              ),
            ),
            TextButton(
              onPressed: () => context
                  .read<AnalysisBloc>()
                  .add(AnalyzePerformanceEvent(grades)),
              child: const Text('Retry',
                  style: TextStyle(color: AppColors.primary, fontSize: 13)),
            ),
          ],
        ),
      );
    }

    if (state is AnalysisCompleted) {
      return _CardShell(
        key: const ValueKey('done'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.primaryLight, size: 16),
                ),
                const SizedBox(width: 10),
                const Text(
                  'AI Insights',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              state.result,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.65,
              ),
            ),
          ],
        ),
      );
    }

    // Initial — show trigger button
    return _CardShell(
      key: const ValueKey('idle'),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded,
              color: AppColors.textMuted, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Get AI-powered feedback on your performance.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          _AnalyzeButton(grades: grades),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _AnalyzeButton extends StatefulWidget {
  final Map<String, double> grades;
  const _AnalyzeButton({required this.grades});

  @override
  State<_AnalyzeButton> createState() => _AnalyzeButtonState();
}

class _AnalyzeButtonState extends State<_AnalyzeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context
            .read<AnalysisBloc>()
            .add(AnalyzePerformanceEvent(widget.grades)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Analyze',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _hovered ? Colors.white : AppColors.primaryLight,
            ),
          ),
        ),
      ),
    );
  }
}

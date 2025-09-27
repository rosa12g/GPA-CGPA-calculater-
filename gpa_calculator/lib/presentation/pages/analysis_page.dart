import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/analysis/presentation/bloc/analysis_bloc.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/error_widget.dart' as custom;
import '../widgets/gradient_button.dart';
import '../../core/constants/app_constants.dart';

class AnalysisPage extends StatefulWidget {
  final Map<String, double> grades;

  const AnalysisPage({super.key, required this.grades});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  void initState() {
    super.initState();
    // Automatically start analysis when page loads
    context.read<AnalysisBloc>().add(AnalyzePerformanceEvent(widget.grades));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "AI Performance Analysis",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF263238),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Courses:",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: AppConstants.cardElevation,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: widget.grades.entries.map(
                              (e) => ListTile(
                                title: Text(
                                  e.key,
                                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                trailing: Text(
                                  e.value.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: GradientButton(
                          text: "Analyze My Weaknesses",
                          onPressed: () {
                            context.read<AnalysisBloc>().add(AnalyzePerformanceEvent(widget.grades));
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<AnalysisBloc, AnalysisState>(
                        builder: (context, state) {
                          if (state is AnalysisLoading) {
                            return const LoadingWidget(message: "Analyzing your performance...");
                          } else if (state is AnalysisError) {
                            return custom.ErrorWidget(
                              message: state.message,
                              onRetry: () {
                                context.read<AnalysisBloc>().add(AnalyzePerformanceEvent(widget.grades));
                              },
                            );
                          } else if (state is AnalysisCompleted) {
                            return Card(
                              elevation: AppConstants.cardElevation,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                              color: Colors.grey[850],
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "AI Insights:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      state.result,
                                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
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

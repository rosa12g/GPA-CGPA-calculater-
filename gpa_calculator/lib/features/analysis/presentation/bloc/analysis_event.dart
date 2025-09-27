part of 'analysis_bloc.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();

  @override
  List<Object?> get props => [];
}

class AnalyzePerformanceEvent extends AnalysisEvent {
  final Map<String, double> grades;
  
  const AnalyzePerformanceEvent(this.grades);
  
  @override
  List<Object?> get props => [grades];
}

part of 'analysis_bloc.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisCompleted extends AnalysisState {
  final String result;
  
  const AnalysisCompleted(this.result);
  
  @override
  List<Object?> get props => [result];
}

class AnalysisError extends AnalysisState {
  final String message;
  
  const AnalysisError(this.message);
  
  @override
  List<Object?> get props => [message];
}

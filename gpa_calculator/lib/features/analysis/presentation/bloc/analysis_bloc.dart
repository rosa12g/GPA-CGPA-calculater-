import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/analyze_performance.dart';

part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalyzePerformance analyzePerformance;

  AnalysisBloc({
    required this.analyzePerformance,
  }) : super(AnalysisInitial()) {
    on<AnalyzePerformanceEvent>(_onAnalyzePerformance);
  }

  Future<void> _onAnalyzePerformance(AnalyzePerformanceEvent event, Emitter<AnalysisState> emit) async {
    emit(AnalysisLoading());
    
    final result = await analyzePerformance(event.grades);
    result.fold(
      (failure) => emit(AnalysisError(failure.message)),
      (analysis) => emit(AnalysisCompleted(analysis)),
    );
  }
}

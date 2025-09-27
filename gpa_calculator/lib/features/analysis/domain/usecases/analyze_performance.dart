import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/analysis_repository.dart';

class AnalyzePerformance {
  final AnalysisRepository repository;

  AnalyzePerformance(this.repository);

  Future<Either<Failure, String>> call(Map<String, double> grades) async {
    return await repository.analyzePerformance(grades);
  }
}

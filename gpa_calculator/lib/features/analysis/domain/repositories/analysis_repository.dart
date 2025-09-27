import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AnalysisRepository {
  Future<Either<Failure, String>> analyzePerformance(Map<String, double> grades);
}

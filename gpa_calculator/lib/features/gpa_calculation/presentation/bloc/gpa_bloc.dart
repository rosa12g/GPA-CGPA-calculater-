import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../shared/models/semester.dart';
import '../../../../shared/models/gpa_result.dart';
import '../../domain/usecases/calculate_gpa.dart';

part 'gpa_event.dart';
part 'gpa_state.dart';

class GpaBloc extends Bloc<GpaEvent, GpaState> {
  final CalculateGpa calculateGpa;

  GpaBloc({
    required this.calculateGpa,
  }) : super(GpaInitial()) {
    on<CalculateGpaEvent>(_onCalculateGpa);
  }

  Future<void> _onCalculateGpa(CalculateGpaEvent event, Emitter<GpaState> emit) async {
    emit(GpaLoading());
    
    final result = await calculateGpa(event.semesters);
    result.fold(
      (failure) => emit(GpaError(failure.message)),
      (gpaResult) => emit(GpaCalculated(gpaResult)),
    );
  }
}

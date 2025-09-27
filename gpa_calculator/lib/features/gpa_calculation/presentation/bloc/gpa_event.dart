part of 'gpa_bloc.dart';

abstract class GpaEvent extends Equatable {
  const GpaEvent();

  @override
  List<Object?> get props => [];
}

class CalculateGpaEvent extends GpaEvent {
  final List<Semester> semesters;
  
  const CalculateGpaEvent(this.semesters);
  
  @override
  List<Object?> get props => [semesters];
}

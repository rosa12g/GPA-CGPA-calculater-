part of 'gpa_bloc.dart';

abstract class GpaState extends Equatable {
  const GpaState();

  @override
  List<Object?> get props => [];
}

class GpaInitial extends GpaState {}

class GpaLoading extends GpaState {}

class GpaCalculated extends GpaState {
  final GpaResult result;
  
  const GpaCalculated(this.result);
  
  @override
  List<Object?> get props => [result];
}

class GpaError extends GpaState {
  final String message;
  
  const GpaError(this.message);
  
  @override
  List<Object?> get props => [message];
}

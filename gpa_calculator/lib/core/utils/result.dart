import 'package:equatable/equatable.dart';

abstract class Result<T> extends Equatable {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  
  const Success(this.data);
  
  @override
  List<Object> get props => [data as Object];
}

class Error<T> extends Result<T> {
  final String message;
  
  const Error(this.message);
  
  @override
  List<Object> get props => [message];
}

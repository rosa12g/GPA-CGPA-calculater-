import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String name;
  final double credits;
  final double grade;
  final int? id;

  const Course({
    required this.name,
    required this.credits,
    required this.grade,
    this.id,
  });

  Course copyWith({
    String? name,
    double? credits,
    double? grade,
    int? id,
  }) {
    return Course(
      name: name ?? this.name,
      credits: credits ?? this.credits,
      grade: grade ?? this.grade,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'credits': credits,
      'grade': grade,
      'id': id,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'] ?? '',
      credits: (map['credits'] ?? 0.0).toDouble(),
      grade: (map['grade'] ?? 0.0).toDouble(),
      id: map['id'],
    );
  }

  @override
  List<Object?> get props => [name, credits, grade, id];
}

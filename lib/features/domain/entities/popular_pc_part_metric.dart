import 'package:equatable/equatable.dart';

class PcPartMetricEntity extends Equatable {
  const PcPartMetricEntity({required this.name, required this.count});
  final String name;
  final int count;

  @override
  List<Object?> get props {
    return [name, count];
  }
}

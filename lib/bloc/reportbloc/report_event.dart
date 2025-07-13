import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override List<Object?> get props => [];
}

class LoadReports extends ReportEvent {}
import 'package:equatable/equatable.dart';
import '/core/model/wasteReportModel.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<WasteReport> reports;
  const ReportLoaded(this.reports);
  @override
  List<Object?> get props => [reports];
}

class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);
  @override
  List<Object?> get props => [message];
}

class ReportSubmitting extends ReportState {}

class ReportSubmitted extends ReportState {}

class ReportSubmitFailed extends ReportState {
  final String error;
  const ReportSubmitFailed(this.error);
  @override
  List<Object?> get props => [error];
}

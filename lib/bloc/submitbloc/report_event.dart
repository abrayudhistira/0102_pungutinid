import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();
  @override
  List<Object?> get props => [];
}

class LoadReports extends ReportEvent {}

class SubmitReport extends ReportEvent {
  final int userId;
  final double latitude;
  final double longitude;
  final File imageFile;
  final String description;

  const SubmitReport({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.imageFile,
    required this.description,
  });

  @override
  List<Object?> get props => [userId, latitude, longitude, imageFile, description];
}

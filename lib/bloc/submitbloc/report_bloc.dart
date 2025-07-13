import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/submitbloc/report_event.dart';
import 'package:pungutinid/bloc/submitbloc/report_state.dart';
import 'package:pungutinid/bloc/submitbloc/report_event.dart';
import 'package:pungutinid/bloc/submitbloc/report_state.dart';
import 'package:pungutinid/core/service/reportService.dart';
import 'package:pungutinid/core/model/wasteReportModel.dart';
import 'dart:io';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService _repo;

  ReportBloc(this._repo) : super(ReportInitial()) {
    on<LoadReports>((event, emit) async {
      emit(ReportLoading());
      try {
        final list = await _repo.fetchReports();
        emit(ReportLoaded(list));
      } catch (e) {
        emit(ReportError(e.toString()));
      }
    });

    on<SubmitReport>((event, emit) async {
      emit(ReportSubmitting());
      try {
        final bytes = await event.imageFile.readAsBytes();
        //final base64Image = base64Encode(bytes);

        print('[Bloc] SubmitReport event received');
        print(' - userId: ${event.userId}');
        print(' - latitude: ${event.latitude}');
        print(' - longitude: ${event.longitude}');
        print(' - description: ${event.description}');
        print(' - image path: ${event.imageFile.path}');

        await _repo.createReport(
          userId: event.userId,
          latitude: event.latitude,
          longitude: event.longitude,
          photo: event.imageFile,
          description: event.description,
        );
        print('[Bloc] Report submitted successfully');
        emit(ReportSubmitted());
      } catch (e) {
        print('[Bloc] Report submission failed: $e');
        emit(ReportSubmitFailed(e.toString()));
      }
    });
  }
}

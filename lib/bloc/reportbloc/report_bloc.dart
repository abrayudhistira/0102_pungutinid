import 'package:flutter_bloc/flutter_bloc.dart';
import 'report_event.dart';
import 'report_state.dart';
import '/core/service/reportService.dart';

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
  }
}

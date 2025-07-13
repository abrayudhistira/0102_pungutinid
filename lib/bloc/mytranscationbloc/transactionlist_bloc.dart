// lib/bloc/transactionlistbloc/transactionlist_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/mytranscationbloc/transactionlist_event';
import 'transactionlist_state.dart';
import 'package:pungutinid/core/service/transactionService.dart';

class TransactionListBloc extends Bloc<TransactionListEvent, TransactionListState> {
  final TransactionService _service;
  TransactionListBloc(this._service) : super(TransactionListInitial()) {
    on<LoadMyTransactions>((_, emit) async {
      emit(TransactionListLoading());
      try {
        final list = await _service.fetchMyTransactions();
        emit(TransactionListLoaded(list));
      } catch (e) {
        emit(TransactionListError(e.toString()));
      }
    });
  }
}

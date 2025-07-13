import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../core/service/transactionService.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _service;
  TransactionBloc(this._service) : super(TransactionInitial()) {
    on<CreateSale>((e, emit) async {
      emit(TransactionLoading());
      try {
        final sale = await _service.createSale(
          sellerId: e.sellerId,
          weightKg: e.weightKg,
          pricePerKg: e.pricePerKg,
        );
        emit(TransactionSuccess(sale));
      } catch (err) {
        emit(TransactionFailure(err.toString()));
      }
    });
  }
}

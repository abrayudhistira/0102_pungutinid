import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/buyertransactionbloc/wastesale_event.dart';
import 'package:pungutinid/bloc/buyertransactionbloc/wastesale_state.dart';
import 'package:pungutinid/core/service/transactionService.dart';

class WasteSaleBloc extends Bloc<WasteSaleEvent, WasteSaleState> {
  final TransactionService service;

  WasteSaleBloc(this.service) : super(WasteSaleInitial()) {
    on<LoadWasteSales>(_onLoad);
    on<UploadPaymentProof>(_onUpload);
  }

  // Future<void> _onLoad(LoadWasteSales event, Emitter emit) async {
  //   emit(WasteSaleLoading());
  //   try {
  //     final waste = await service.fetchAvailableWaste();
  //     emit(WasteSaleLoaded(waste));
  //   } catch (e) {
  //     emit(WasteSaleError(e.toString()));
  //   }
  // }
  Future<void> _onLoad(LoadWasteSales event, Emitter emit) async {
  emit(WasteSaleLoading());
  print('[WasteSaleBloc] Loading waste sales...');
  try {
    final waste = await service.fetchAvailableWaste();
    print('[WasteSaleBloc] Loaded waste sales: ${waste.length}');
    emit(WasteSaleLoaded(waste));
  } catch (e, stackTrace) {
    print('[WasteSaleBloc] Failed to load waste sales: $e');
    print(stackTrace);
    emit(WasteSaleError("Gagal memuat data penjualan: ${e.toString()}"));
  }
}


  Future<void> _onUpload(UploadPaymentProof event, Emitter emit) async {
    emit(PaymentUploading());
    try {
      await service.uploadPaymentProof(
        saleId: event.saleId,
        imageFile: event.paymentProof,
      );
      add(LoadWasteSales()); // refresh list
      emit(PaymentUploaded());
    } catch (e) {
      emit(WasteSaleError(e.toString()));
    }
  }
}

import 'dart:io';

abstract class WasteSaleEvent {}

class LoadWasteSales extends WasteSaleEvent {}

class UploadPaymentProof extends WasteSaleEvent {
  final int saleId;
  final File paymentProof;

  UploadPaymentProof({required this.saleId, required this.paymentProof});
}

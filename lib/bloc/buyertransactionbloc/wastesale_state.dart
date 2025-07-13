import 'package:pungutinid/core/model/wasteSalesModel.dart';

abstract class WasteSaleState {}

class WasteSaleInitial extends WasteSaleState {}

class WasteSaleLoading extends WasteSaleState {}

class WasteSaleLoaded extends WasteSaleState {
  final List<WasteSale> wasteSales;
  WasteSaleLoaded(this.wasteSales);
}

class WasteSaleError extends WasteSaleState {
  final String message;
  WasteSaleError(this.message);
}

class PaymentUploading extends WasteSaleState {}

class PaymentUploaded extends WasteSaleState {}

import 'package:equatable/equatable.dart';
import '../../core/model/transactionModel.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}
class TransactionLoading extends TransactionState {}
class TransactionSuccess extends TransactionState {
  final Transaction sale;
  TransactionSuccess(this.sale);
  @override
  List<Object?> get props => [sale];
}
class TransactionFailure extends TransactionState {
  final String error;
  TransactionFailure(this.error);
  @override
  List<Object?> get props => [error];
}

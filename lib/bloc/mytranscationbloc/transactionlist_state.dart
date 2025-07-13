// lib/bloc/transactionlistbloc/transactionlist_state.dart
import 'package:equatable/equatable.dart';
import 'package:pungutinid/core/model/transactionGetModel.dart';

abstract class TransactionListState extends Equatable {
  const TransactionListState();
  @override List<Object?> get props => [];
}

class TransactionListInitial extends TransactionListState {}
class TransactionListLoading extends TransactionListState {}
class TransactionListLoaded extends TransactionListState {
  final List<TransactionGetModel> transactions;
  const TransactionListLoaded(this.transactions);
  @override List<Object?> get props => [transactions];
}
class TransactionListError extends TransactionListState {
  final String message;
  const TransactionListError(this.message);
  @override List<Object?> get props => [message];
}
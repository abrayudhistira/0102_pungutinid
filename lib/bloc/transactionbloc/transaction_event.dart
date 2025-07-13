import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateSale extends TransactionEvent {
  final int sellerId;
  final double weightKg;
  final double pricePerKg;

  CreateSale({
    required this.sellerId,
    required this.weightKg,
    required this.pricePerKg,
  });

  @override
  List<Object?> get props => [sellerId, weightKg, pricePerKg];
}

// lib/core/model/transactionModel.dart

class TransactionGetModel {
  final int saleId;
  final int sellerId;
  final int? buyerId;
  final double weightKg;
  final double pricePerKg;
  final double totalPrice;
  final String? paymentProofUrl;
  final String status;
  final DateTime createdAt;

  TransactionGetModel({
    required this.saleId,
    required this.sellerId,
    this.buyerId,
    required this.weightKg,
    required this.pricePerKg,
    required this.totalPrice,
    this.paymentProofUrl,
    required this.status,
    required this.createdAt,
  });

  factory TransactionGetModel.fromJson(Map<String, dynamic> json) {
    return TransactionGetModel(
      saleId: json['sale_id'] as int,
      sellerId: json['seller_id'] as int,
      buyerId: json['buyer_id'] as int?,
      weightKg: double.parse(json['weight_kg'].toString()),
      pricePerKg: double.parse(json['price_per_kg'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      paymentProofUrl: json['payment_proof_url'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

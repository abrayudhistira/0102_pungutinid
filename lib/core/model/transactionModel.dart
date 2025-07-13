class Transaction {
  final int? saleId;
  final int sellerId;
  final int? buyerId;
  final double weightKg;
  final double pricePerKg;
  final String? paymentProofUrl;
  final String status;

  Transaction({
    this.saleId,
    required this.sellerId,
    this.buyerId,
    required this.weightKg,
    required this.pricePerKg,
    this.paymentProofUrl,
    this.status = 'not_yet',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        saleId: json['sale_id'] as int?,
        sellerId: json['seller_id'] as int,
        buyerId: json['buyer_id'] as int?,
        weightKg: double.parse(json['weight_kg'].toString()),
        pricePerKg: double.parse(json['price_per_kg'].toString()),
        paymentProofUrl: json['payment_proof_url'] as String?,
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'seller_id': sellerId,
        'buyer_id': buyerId,
        'weight_kg': weightKg,
        'price_per_kg': pricePerKg,
      };
}
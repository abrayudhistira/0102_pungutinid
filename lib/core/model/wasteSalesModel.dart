// To parse this JSON data, do
//
//     final wasteSale = wasteSaleFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<WasteSale> wasteSaleFromJson(String str) => List<WasteSale>.from(json.decode(str).map((x) => WasteSale.fromJson(x)));

String wasteSaleToJson(List<WasteSale> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WasteSale {
    final int saleId;
    final int sellerId;
    final dynamic buyerId;
    final String weightKg;
    final String pricePerKg;
    final String totalPrice;
    final dynamic paymentProofUrl;
    final String status;
    final DateTime createdAt;
    final Seller seller;
    final dynamic buyer;

    WasteSale({
        required this.saleId,
        required this.sellerId,
        required this.buyerId,
        required this.weightKg,
        required this.pricePerKg,
        required this.totalPrice,
        required this.paymentProofUrl,
        required this.status,
        required this.createdAt,
        required this.seller,
        required this.buyer,
    });

    factory WasteSale.fromJson(Map<String, dynamic> json) => WasteSale(
        saleId: json["sale_id"],
        sellerId: json["seller_id"],
        buyerId: json["buyer_id"],
        weightKg: json["weight_kg"],
        pricePerKg: json["price_per_kg"],
        totalPrice: json["total_price"],
        paymentProofUrl: json["payment_proof_url"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        seller: Seller.fromJson(json["seller"]),
        buyer: json["buyer"],
    );

    Map<String, dynamic> toJson() => {
        "sale_id": saleId,
        "seller_id": sellerId,
        "buyer_id": buyerId,
        "weight_kg": weightKg,
        "price_per_kg": pricePerKg,
        "total_price": totalPrice,
        "payment_proof_url": paymentProofUrl,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "seller": seller.toJson(),
        "buyer": buyer,
    };
}

class Seller {
    final int userId;
    final String fullname;
    final String phone;

    Seller({
        required this.userId,
        required this.fullname,
        required this.phone,
    });

    factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        userId: json["user_id"],
        fullname: json["fullname"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "fullname": fullname,
        "phone": phone,
    };
}

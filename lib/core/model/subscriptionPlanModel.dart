class SubscriptionPlan {
  final int planId;
  final String name;
  final String? description;
  final double price;
  final String frequency;

  SubscriptionPlan({
    required this.planId,
    required this.name,
    this.description,
    required this.price,
    required this.frequency,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      planId: json['plan_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: double.parse(json['price'].toString()),
      frequency: json['frequency'] as String,
    );
  }
  Map<String, dynamic> toJson() => {
        // jangan sertakan plan_id saat create—server yang auto-increment
        'name'       : name,
        'description': description,
        'price'      : price,
        'frequency'  : frequency,
  };
}

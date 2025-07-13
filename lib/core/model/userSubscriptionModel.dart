import 'subscriptionPlanModel.dart';

import 'package:meta/meta.dart';
import 'dart:convert';

List<UserSubscription> userSubscriptionFromJson(String str) => List<UserSubscription>.from(json.decode(str).map((x) => UserSubscription.fromJson(x)));

String userSubscriptionToJson(List<UserSubscription> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSubscription {
    final int subscriptionId;
    final int userId;
    final String userName;
    final Plan plan;
    final DateTime startDate;
    final DateTime endDate;
    final bool isActive;

    UserSubscription({
        required this.subscriptionId,
        required this.userId,
        required this.userName,
        required this.plan,
        required this.startDate,
        required this.endDate,
        required this.isActive,
    });

    factory UserSubscription.fromJson(Map<String, dynamic> json) => UserSubscription(
        subscriptionId: json["subscription_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        plan: Plan.fromJson(json["plan"]),
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        isActive: json["is_active"],
    );

    Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "user_id": userId,
        "user_name": userName,
        "plan": plan.toJson(),
        "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "is_active": isActive,
    };
}

class Plan {
    final String name;
    final String description;
    final String frequency;
    final String price;

    Plan({
        required this.name,
        required this.description,
        required this.frequency,
        required this.price,
    });

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        name: json["name"],
        description: json["description"],
        frequency: json["frequency"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "frequency": frequency,
        "price": price,
    };
}


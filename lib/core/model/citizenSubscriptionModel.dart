import 'package:pungutinid/core/model/subscriptionPlanModel.dart';

class CitizenSubscription {
  final int subscriptionId;
  final int userId;
  final int planId;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final SubscriptionPlan plan;

  CitizenSubscription({
    required this.subscriptionId,
    required this.userId,
    required this.planId,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.plan,
  });

  factory CitizenSubscription.fromJson(Map<String, dynamic> json) {
    return CitizenSubscription(
      subscriptionId: json['subscription_id'],
      userId: json['user_id'],
      planId: json['plan_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      plan: SubscriptionPlan.fromJson(json['subscription_plan']),
    );
  }
}
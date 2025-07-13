// lib/bloc/subscriptionbloc/subscription_event.dart
import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
  @override List<Object?> get props => [];
}

/// Trigger loading plans
class LoadPlans extends SubscriptionEvent {}

/// User chooses to subscribe to a plan
class SelectPlan extends SubscriptionEvent {
  final int userId;
  final int planId;
  const SelectPlan({required this.userId, required this.planId});
  @override List<Object?> get props => [userId, planId];
}

/// User skips subscription
class SkipSubscription extends SubscriptionEvent {}
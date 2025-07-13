// lib/bloc/subscriptionbloc/subscription_event.dart

import 'package:equatable/equatable.dart';

abstract class UserSubscriptionEvent extends Equatable {
  const UserSubscriptionEvent();
  @override List<Object?> get props => [];
}

class LoadUserSubscriptions extends UserSubscriptionEvent {}

class UpdateSubscriptionStatus extends UserSubscriptionEvent {
  final int subscriptionId;
  final bool isActive;
  const UpdateSubscriptionStatus({required this.subscriptionId, required this.isActive});
  @override List<Object?> get props => [subscriptionId, isActive];
}

class CancelSubscription extends UserSubscriptionEvent {
  final int subscriptionId;
  const CancelSubscription({required this.subscriptionId});
  @override List<Object?> get props => [subscriptionId];
}

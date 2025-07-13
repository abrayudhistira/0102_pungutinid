// lib/bloc/subscriptionbloc/subscription_state.dart
import 'package:equatable/equatable.dart';
import 'package:pungutinid/core/model/subscriptionPlanModel.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
  @override List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}
class SubscriptionLoading  extends SubscriptionState {}
class PlansLoaded extends SubscriptionState {
  final List<SubscriptionPlan> plans;
  const PlansLoaded(this.plans);
  @override List<Object?> get props => [plans];
}
class SubscriptionInProgress extends SubscriptionState {}
class SubscriptionSuccess    extends SubscriptionState {}
class SubscriptionFailure    extends SubscriptionState {
  final String error;
  const SubscriptionFailure(this.error);
  @override List<Object?> get props => [error];
}
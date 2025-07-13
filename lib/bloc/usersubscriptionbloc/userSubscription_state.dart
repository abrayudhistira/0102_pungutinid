import 'package:equatable/equatable.dart';
import 'package:pungutinid/core/model/citizenSubscriptionModel.dart';

abstract class UserSubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserSubscriptionInitial extends UserSubscriptionState {}

class UserSubscriptionLoading extends UserSubscriptionState {}

class UserSubscriptionLoaded extends UserSubscriptionState {
  final List<CitizenSubscription> subscriptions;

  UserSubscriptionLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class UserSubscriptionError extends UserSubscriptionState {
  final String message;

  UserSubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}

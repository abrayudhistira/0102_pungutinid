import 'package:pungutinid/core/model/userSubscriptionModel.dart';

abstract class ProviderSubscriptionState {}

class ProviderSubscriptionLoading extends ProviderSubscriptionState {}

class ProviderSubscriptionLoaded extends ProviderSubscriptionState {
  final List<UserSubscription> subscriptions;
  ProviderSubscriptionLoaded(this.subscriptions);
}

class ProviderSubscriptionError extends ProviderSubscriptionState {
  final String message;
  ProviderSubscriptionError(this.message);
}

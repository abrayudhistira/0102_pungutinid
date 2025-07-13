abstract class ProviderSubscriptionEvent {}

class LoadAllSubscriptions extends ProviderSubscriptionEvent {}

class UpdateUserSubscriptionStatus extends ProviderSubscriptionEvent {
  final int subscriptionId;
  final bool isActive;

  UpdateUserSubscriptionStatus({required this.subscriptionId, required this.isActive});
}

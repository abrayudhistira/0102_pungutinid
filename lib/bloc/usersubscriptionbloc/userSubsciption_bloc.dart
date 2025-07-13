import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import 'package:pungutinid/bloc/usersubscriptionbloc/userSubscription_state.dart';
import 'package:pungutinid/bloc/usersubscriptionbloc/userSuscription_event.dart';

class UserSubscriptionBloc extends Bloc<UserSubscriptionEvent, UserSubscriptionState> {
  final SubscriptionService subscriptionService;

  UserSubscriptionBloc(this.subscriptionService) : super(UserSubscriptionInitial()) {
    on<LoadUserSubscriptions>(_onLoadUserSubscriptions);
    on<UpdateSubscriptionStatus>(_onUpdateSubscriptionStatus);
    on<CancelSubscription>(_onCancelSubscription);
  }

  // Handler: Load subscriptions
  Future<void> _onLoadUserSubscriptions(
    LoadUserSubscriptions event,
    Emitter<UserSubscriptionState> emit,
  ) async {
    emit(UserSubscriptionLoading());
    try {
      final subs = await subscriptionService.fetchUserSubscriptions();
      emit(UserSubscriptionLoaded(subs));
    } catch (e) {
      emit(UserSubscriptionError(e.toString()));
    }
  }

  // Handler: Update status aktif/tidak aktif
  Future<void> _onUpdateSubscriptionStatus(
    UpdateSubscriptionStatus event,
    Emitter<UserSubscriptionState> emit,
  ) async {
    emit(UserSubscriptionLoading());
    try {
      await subscriptionService.updateSubscriptionStatus(
        subscriptionId: event.subscriptionId,
        isActive: event.isActive,
      );
      final updated = await subscriptionService.fetchUserSubscriptions();
      emit(UserSubscriptionLoaded(updated));
    } catch (e) {
      emit(UserSubscriptionError(e.toString()));
    }
  }

  // Handler: Batalkan (cancel) langganan
  Future<void> _onCancelSubscription(
    CancelSubscription event,
    Emitter<UserSubscriptionState> emit,
  ) async {
    emit(UserSubscriptionLoading());
    try {
      await subscriptionService.cancelSubscription(event.subscriptionId);
      final updated = await subscriptionService.fetchUserSubscriptions();
      emit(UserSubscriptionLoaded(updated));
    } catch (e) {
      emit(UserSubscriptionError(e.toString()));
    }
  }
}

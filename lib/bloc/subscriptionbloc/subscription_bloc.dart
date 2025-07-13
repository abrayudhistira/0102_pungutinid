// lib/bloc/subscriptionbloc/subscription_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionService _service;
  SubscriptionBloc(this._service): super(SubscriptionInitial()) {
    on<LoadPlans>((e, emit) async {
      emit(SubscriptionLoading());
      try {
        final plans = await _service.fetchPlans();
        emit(PlansLoaded(plans));
      } catch (err) {
        emit(SubscriptionFailure(err.toString()));
      }
    });

    on<SelectPlan>((e, emit) async {
      emit(SubscriptionInProgress());
      try {
        await _service.subscribe(userId: e.userId, planId: e.planId);
        emit(SubscriptionSuccess());
      } catch (err) {
        emit(SubscriptionFailure(err.toString()));
      }
    });

    on<SkipSubscription>((e, emit) {
      emit(SubscriptionSuccess()); // treat skip as success
    });
  }
}
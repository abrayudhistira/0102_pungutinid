// lib/bloc/planbloc/plan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import 'plan_event.dart';
import 'plan_state.dart';

class PlanBloc extends Bloc<PlanEvent, PlanState> {
  final SubscriptionService _service;
  PlanBloc(this._service) : super(PlanInitial()) {
    on<LoadPlans>((e, emit) async {
      emit(PlanLoading());
      try {
        final plans = await _service.fetchPlans();
        emit(PlanLoaded(plans));
      } catch (e) {
        emit(PlanFailure(e.toString()));
      }
    });
    on<AddPlan>((e, emit) async {
      try {
        await _service.createPlan(e.plan);
        add(LoadPlans());
      } catch (e) { emit(PlanFailure(e.toString())); }
    });
    on<UpdatePlanEvt>((e, emit) async {
      try {
        await _service.updatePlan(e.plan);
        add(LoadPlans());
      } catch (e) { emit(PlanFailure(e.toString())); }
    });
    on<DeletePlanEvt>((e, emit) async {
      try {
        await _service.deletePlan(e.planId);
        add(LoadPlans());
      } catch (e) { emit(PlanFailure(e.toString())); }
    });
  }
}

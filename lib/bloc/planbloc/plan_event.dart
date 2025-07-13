// lib/bloc/planbloc/plan_event.dart
import 'package:equatable/equatable.dart';
import '../../core/model/subscriptionPlanModel.dart';

abstract class PlanEvent extends Equatable {
  const PlanEvent();
  @override List<Object?> get props => [];
}

class LoadPlans     extends PlanEvent {}
class AddPlan       extends PlanEvent { final SubscriptionPlan plan; const AddPlan(this.plan); @override List<Object?> get props=>[plan]; }
class UpdatePlanEvt extends PlanEvent { final SubscriptionPlan plan; const UpdatePlanEvt(this.plan); @override List<Object?> get props=>[plan]; }
class DeletePlanEvt extends PlanEvent { final int planId; const DeletePlanEvt(this.planId); @override List<Object?> get props=>[planId]; }

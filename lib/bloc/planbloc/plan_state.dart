// lib/bloc/planbloc/plan_state.dart
import 'package:equatable/equatable.dart';
import '../../core/model/subscriptionPlanModel.dart';

abstract class PlanState extends Equatable {
  const PlanState();
  @override List<Object?> get props => [];
}

class PlanInitial  extends PlanState {}
class PlanLoading  extends PlanState {}
class PlanLoaded   extends PlanState { final List<SubscriptionPlan> plans; const PlanLoaded(this.plans); @override List<Object?> get props => [plans]; }
class PlanFailure  extends PlanState { final String error; const PlanFailure(this.error); @override List<Object?> get props => [error]; }

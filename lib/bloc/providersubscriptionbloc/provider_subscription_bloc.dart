import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/providersubscriptionbloc/provider__subscription_state.dart';
import 'package:pungutinid/bloc/providersubscriptionbloc/provider_subscription_event.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';

class ProviderSubscriptionBloc extends Bloc<ProviderSubscriptionEvent, ProviderSubscriptionState> {
  final SubscriptionService service;

  ProviderSubscriptionBloc(this.service) : super(ProviderSubscriptionLoading()) {
    on<LoadAllSubscriptions>((event, emit) async {
      emit(ProviderSubscriptionLoading());
      try {
        print('[BLoC] LoadAllSubscriptions dipanggil');
        final subs = await service.getAllUserSubscriptions();
        print('[BLoC] Total subscription: ${subs.length}');
        emit(ProviderSubscriptionLoaded(subs));
      } catch (e) {
        print('[BLoC] Error saat memuat subscription: $e');
        emit(ProviderSubscriptionError(e.toString()));
      }
    });

    on<UpdateUserSubscriptionStatus>((event, emit) async {
      print('[BLoC] Update status untuk ID ${event.subscriptionId}, aktif: ${event.isActive}');
      try {
        await service.updateSubscriptionStatusByProvider(
          subscriptionId: event.subscriptionId,
          isActive: event.isActive,
        );
        add(LoadAllSubscriptions()); // refresh
      } catch (e) {
        print('[BLoC] Error update status: $e');
        emit(ProviderSubscriptionError(e.toString()));
      }
    });
  }
}

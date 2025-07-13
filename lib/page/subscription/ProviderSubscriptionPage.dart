import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/providersubscriptionbloc/provider__subscription_state.dart';
import 'package:pungutinid/bloc/providersubscriptionbloc/provider_subscription_bloc.dart';
import 'package:pungutinid/bloc/providersubscriptionbloc/provider_subscription_event.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';

class ProviderSubscriptionPage extends StatelessWidget {
  const ProviderSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProviderSubscriptionBloc(SubscriptionService())..add(LoadAllSubscriptions()),
      child: const _ProviderSubscriptionView(),
    );
  }
}

class _ProviderSubscriptionView extends StatelessWidget {
  const _ProviderSubscriptionView();

  @override
  Widget build(BuildContext context) {
    final authCtrl = context.watch<AuthController>();
    final user = authCtrl.user;
    return WillPopScope(
      onWillPop: () async {
        if (user != null) {
          final role = user.role?.toLowerCase();
          String route;

          if (role == 'provider') {
            route = '/providerDashboard';
          } else {
            route = '/login'; // fallback
          }

          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          return false; // Cegah pop default
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Kelola Langganan Pengguna'), backgroundColor: Colors.green[800]),
        body: BlocBuilder<ProviderSubscriptionBloc, ProviderSubscriptionState>(
          builder: (ctx, state) {
            if (state is ProviderSubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProviderSubscriptionLoaded) {
              final subs = state.subscriptions;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subs.length,
                itemBuilder: (_, i) {
                  final s = subs[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text('${s.userName} - ${s.plan.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mulai: ${s.startDate.toLocal().toString().split(' ')[0]}'),
                          if (s.endDate != null)
                            Text('Sampai: ${s.endDate!.toLocal().toString().split(' ')[0]}'),
                          Text('Status: ${s.isActive ? 'Aktif' : 'Tidak aktif'}'),
                        ],
                      ),
                      trailing: Switch(
                        value: s.isActive,
                        onChanged: (val) {
                          context.read<ProviderSubscriptionBloc>().add(
                            UpdateUserSubscriptionStatus(subscriptionId: s.subscriptionId, isActive: val),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
            if (state is ProviderSubscriptionError) {
              return Center(child: Text('Gagal: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/model/userSubscriptionModel.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import '../../bloc/usersubscriptionbloc/userSubsciption_bloc.dart';
import '../../bloc/usersubscriptionbloc/userSuscription_event.dart';
import '../../bloc/usersubscriptionbloc/userSubscription_state.dart';

class UserSubscriptionPage extends StatelessWidget {
  const UserSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          UserSubscriptionBloc(SubscriptionService())..add(LoadUserSubscriptions()),
      child: const _UserSubscriptionView(),
    );
  }
}

class _UserSubscriptionView extends StatelessWidget {
  const _UserSubscriptionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Langganan Saya'),
        backgroundColor: Colors.green[700],
      ),

      // FAB selalu muncul
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addSubscription');
          if (result == true) {
            context.read<UserSubscriptionBloc>().add(LoadUserSubscriptions());
          }
        },
        child: const Icon(Icons.add),
      ),

      body: BlocBuilder<UserSubscriptionBloc, UserSubscriptionState>(
        builder: (ctx, state) {
          if (state is UserSubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserSubscriptionLoaded) {
            final subs = state.subscriptions;
            if (subs.isEmpty) {
              return const Center(
                child: Text(
                  'Anda belum berlangganan',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subs.length,
              itemBuilder: (_, i) {
                final s = subs[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      s.plan.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (s.plan.description != null && s.plan.description!.isNotEmpty)
                          Text(s.plan.description!),
                        const SizedBox(height: 4),
                        Text('Mulai: ${s.startDate.toLocal().toString().split(' ')[0]}'),
                        if (s.endDate != null)
                          Text('Sampai: ${s.endDate!.toLocal().toString().split(' ')[0]}'),
                        const SizedBox(height: 4),
                        Text('Status: ${s.isActive ? 'Aktif' : 'Tidak aktif'}'),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (choice) {
                        switch (choice) {
                          case 'toggle':
                            ctx.read<UserSubscriptionBloc>().add(
                                  UpdateSubscriptionStatus(
                                    subscriptionId: s.subscriptionId,
                                    isActive: !s.isActive,
                                  ),
                                );
                            break;
                          case 'cancel':
                            ctx.read<UserSubscriptionBloc>().add(
                                  CancelSubscription(subscriptionId: s.subscriptionId),
                                );
                            break;
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(s.isActive ? 'Set Inaktif' : 'Set Aktif'),
                        ),
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Text('Batalkan'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is UserSubscriptionError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pungutinid/bloc/usersubscriptionbloc/userSubsciption_bloc.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/subscriptionService.dart';
import '../../bloc/subscriptionbloc/subscription_bloc.dart';
import '../../bloc/subscriptionbloc/subscription_event.dart';
import '../../bloc/subscriptionbloc/subscription_state.dart';

class AddSubscriptionPage extends StatelessWidget {
  const AddSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionBloc(SubscriptionService())..add(LoadPlans()),
      child: const _AddSubscriptionView(),
    );
  }
}

class _AddSubscriptionView extends StatelessWidget {
  const _AddSubscriptionView();

  Future<int?> _getUserId() async {
    final storage = const FlutterSecureStorage();
    final userJson = await storage.read(key: 'user');
    if (userJson == null) return null;
    final map = jsonDecode(userJson) as Map<String, dynamic>;
    return map['id'] as int?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Paket Langganan'),
        backgroundColor: Colors.green[700],
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (ctx, state) {
          if (state is SubscriptionSuccess) {
            // Setelah berhasil berlangganan, kembali dan refresh halaman langganan user
            Navigator.pop(ctx, true);
          } else if (state is SubscriptionFailure) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text('Gagal berlangganan: ${state.error}')),
            );
          }
        },
        builder: (ctx, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PlansLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.plans.length + 1,
              itemBuilder: (ctx, index) {
                // Tombol skip di atas
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: OutlinedButton(
                      onPressed: () {
                        ctx.read<SubscriptionBloc>().add(SkipSubscription());
                      },
                      child: const Text('Lewati', style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                final plan = state.plans[index - 1];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plan.description != null && plan.description!.isNotEmpty)
                          Text(plan.description!),
                        const SizedBox(height: 4),
                        Text('Harga: Rp${plan.price.toStringAsFixed(0)}'),
                        Text('Frekuensi: ${plan.frequency}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        // Ambil user dari AuthController
                        final user = context.read<AuthController>().user;
                        print('[UI] user from AuthController: $user');
                        final userId = user?.id;
                        if (userId == null) {
                          print('[UI] ERROR: userId is null!');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User tidak ditemukan di UI')),
                          );
                          return;
                        }

                        print('[UI] Dispatching SelectPlan event: userId=$userId, planId=${plan.planId}');
                        context.read<SubscriptionBloc>().add(
                              SelectPlan(userId: userId, planId: plan.planId),
                            );
                      },
                      child: const Text('Pilih'),
                    ),
                  ),
                );
              },
            );
          }
          if (state is SubscriptionInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SubscriptionFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
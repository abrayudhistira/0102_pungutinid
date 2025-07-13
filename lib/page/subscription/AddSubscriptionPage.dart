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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pilih Paket Langganan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (ctx, state) {
          if (state is SubscriptionSuccess) {
            Navigator.pop(ctx, true);
          } else if (state is SubscriptionFailure) {
            // Extract message from server response if it contains JSON
            String displayMessage = state.error;
            if (state.error.contains('"message":"')) {
              try {
                final regex = RegExp(r'"message":"([^"]+)"');
                final match = regex.firstMatch(state.error);
                if (match != null) {
                  displayMessage = match.group(1) ?? state.error;
                }
              } catch (e) {
                displayMessage = state.error;
              }
            }
            
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(displayMessage),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (ctx, state) {
          if (state is SubscriptionLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat paket langganan...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is PlansLoaded) {
            return Column(
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.diamond,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Upgrade ke Premium',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Dapatkan akses fitur eksklusif',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Plans list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: state.plans.length,
                    itemBuilder: (ctx, index) {
                      final plan = state.plans[index];
                      final isPopular = index == 1; // Make middle plan popular
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          gradient: isPopular
                              ? LinearGradient(
                                  colors: [Colors.green[600]!, Colors.green[700]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isPopular ? null : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: isPopular
                              ? null
                              : Border.all(color: Colors.grey[200]!),
                        ),
                        child: Stack(
                          children: [
                            // Popular badge
                            if (isPopular)
                              Positioned(
                                top: 0,
                                right: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[400],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'POPULER',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Plan name
                                  Text(
                                    plan.name,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: isPopular ? Colors.white : Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Description
                                  if (plan.description != null && plan.description!.isNotEmpty)
                                    Text(
                                      plan.description!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isPopular ? Colors.white70 : Colors.grey[600],
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  
                                  // Price section
                                  Row(
                                    children: [
                                      Text(
                                        'Rp',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: isPopular ? Colors.white : Colors.grey[800],
                                        ),
                                      ),
                                      Text(
                                        plan.price.toStringAsFixed(0),
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: isPopular ? Colors.white : Colors.green[700],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '/${plan.frequency}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isPopular ? Colors.white70 : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Select button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final user = context.read<AuthController>().user;
                                        print('[UI] user from AuthController: $user');
                                        final userId = user?.id;
                                        if (userId == null) {
                                          print('[UI] ERROR: userId is null!');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('User tidak ditemukan di UI'),
                                              backgroundColor: Colors.red[600],
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        print('[UI] Dispatching SelectPlan event: userId=$userId, planId=${plan.planId}');
                                        context.read<SubscriptionBloc>().add(
                                              SelectPlan(userId: userId, planId: plan.planId),
                                            );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isPopular ? Colors.white : Colors.green[700],
                                        foregroundColor: isPopular ? Colors.green[700] : Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        isPopular ? 'Pilih Paket Populer' : 'Pilih Paket',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is SubscriptionInProgress) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memproses langganan...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is SubscriptionFailure) {
            // Extract message from server response if it contains JSON
            String displayMessage = state.error;
            if (state.error.contains('"message":"')) {
              try {
                final regex = RegExp(r'"message":"([^"]+)"');
                final match = regex.firstMatch(state.error);
                if (match != null) {
                  displayMessage = match.group(1) ?? state.error;
                }
              } catch (e) {
                displayMessage = state.error;
              }
            }
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 64,
                    color: Colors.orange[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Informasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      displayMessage,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
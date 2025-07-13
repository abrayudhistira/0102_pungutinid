// lib/pages/transactions/MyTransactionsPage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/mytranscationbloc/transactionlist_bloc.dart';
import 'package:pungutinid/bloc/mytranscationbloc/transactionlist_event';
import 'package:pungutinid/bloc/mytranscationbloc/transactionlist_state.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/transactionService.dart';
import 'package:intl/intl.dart';

class MyTransactionsPage extends StatelessWidget {
  const MyTransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthController>().user;
    return BlocProvider(
      create: (_) =>
          TransactionListBloc(TransactionService())..add(LoadMyTransactions()),
      child: WillPopScope(
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
            return false; // Prevent default pop
          }

          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Transaksi Saya',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green[700],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                
                if (user != null) {
                  final role = user.role?.toLowerCase();
                  String route;

                  if (role == 'provider') {
                    route = '/providerDashboard';
                  } else {
                    route = '/login'; // fallback
                  }

                  Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
                }
              },
            ),
          ),
          body: BlocBuilder<TransactionListBloc, TransactionListState>(
            builder: (ctx, state) {
              if (state is TransactionListLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat transaksi...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              if (state is TransactionListLoaded) {
                final txs = state.transactions;
                if (txs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Transaksi Anda akan muncul di sini',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<TransactionListBloc>().add(LoadMyTransactions());
                  },
                  color: Colors.green[700],
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: txs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final t = txs[i];
                      final isCompleted = t.status == 'sold';
                      final statusColor = isCompleted ? Colors.green : Colors.orange;
                      final statusText = isCompleted ? 'Terjual' : 'Belum terjual';
                      
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('dd MMM yyyy').format(t.createdAt),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isCompleted ? Icons.check_circle : Icons.hourglass_empty,
                                          color: statusColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          statusText,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      icon: Icons.scale,
                                      label: 'Berat',
                                      value: '${t.weightKg} kg',
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      icon: Icons.monetization_on,
                                      label: 'Harga/kg',
                                      value: 'Rp ${NumberFormat('#,###').format(t.pricePerKg)}',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green[200]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Harga',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                    Text(
                                      'Rp ${NumberFormat('#,###').format(t.totalPrice)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              
              if (state is TransactionListError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi Kesalahan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TransactionListBloc>().add(LoadMyTransactions());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
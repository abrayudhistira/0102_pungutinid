import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/core/model/citizenSubscriptionModel.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Langganan Saya',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),

      // FAB dengan design yang lebih modern
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green[700],
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/addSubscription');
            if (result == true) {
              context.read<UserSubscriptionBloc>().add(LoadUserSubscriptions());
            }
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Tambah Langganan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      body: BlocBuilder<UserSubscriptionBloc, UserSubscriptionState>(
        builder: (ctx, state) {
          if (state is UserSubscriptionLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.green[700],
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat langganan...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is UserSubscriptionLoaded) {
            final subs = state.subscriptions;
            if (subs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.subscriptions_outlined,
                        size: 64,
                        color: Colors.green[300],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Belum Ada Langganan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan langganan pertama Anda\nuntuk mulai menggunakan layanan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, '/addSubscription');
                        if (result == true) {
                          context.read<UserSubscriptionBloc>().add(LoadUserSubscriptions());
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Langganan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: Colors.green[700],
              onRefresh: () async {
                context.read<UserSubscriptionBloc>().add(LoadUserSubscriptions());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subs.length,
                itemBuilder: (_, i) {
                  final s = subs[i];
                  return _buildSubscriptionCard(context, s);
                },
              ),
            );
          }

          if (state is UserSubscriptionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<UserSubscriptionBloc>().add(LoadUserSubscriptions());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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

  Widget _buildSubscriptionCard(BuildContext context, CitizenSubscription s) {
    final isActive = s.isActive;
    final statusColor = isActive ? Colors.green : Colors.orange;
    final statusText = isActive ? 'Aktif' : 'Tidak Aktif';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    s.plan.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                if (s.plan.description != null && s.plan.description!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            s.plan.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                // Date Info
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.play_circle_outline,
                        label: 'Mulai',
                        value: s.startDate.toLocal().toString().split(' ')[0],
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoItem(
                        icon: Icons.stop_circle_outlined,
                        label: 'Berakhir',
                        value: s.endDate?.toLocal().toString().split(' ')[0] ?? 'Tidak terbatas',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showActionDialog(context, s);
                        },
                        icon: Icon(
                          isActive ? Icons.pause_circle_outlined : Icons.play_circle_outlined,
                          size: 18,
                        ),
                        label: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: statusColor,
                          side: BorderSide(color: statusColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showCancelDialog(context, s);
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Batalkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[50],
                          foregroundColor: Colors.red[700],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
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
      ),
    );
  }

  void _showActionDialog(BuildContext context, CitizenSubscription s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            s.isActive ? 'Nonaktifkan Langganan' : 'Aktifkan Langganan',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            s.isActive
                ? 'Apakah Anda yakin ingin menonaktifkan langganan "${s.plan.name}"?'
                : 'Apakah Anda yakin ingin mengaktifkan langganan "${s.plan.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<UserSubscriptionBloc>().add(
                      UpdateSubscriptionStatus(
                        subscriptionId: s.subscriptionId,
                        isActive: !s.isActive,
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: s.isActive ? Colors.orange : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                s.isActive ? 'Nonaktifkan' : 'Aktifkan',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, CitizenSubscription s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Batalkan Langganan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin membatalkan langganan "${s.plan.name}"? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<UserSubscriptionBloc>().add(
                      CancelSubscription(subscriptionId: s.subscriptionId),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Batalkan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
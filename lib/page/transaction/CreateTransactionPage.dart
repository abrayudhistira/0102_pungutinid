import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pungutinid/bloc/transactionbloc/transaction_bloc.dart';
import 'package:pungutinid/bloc/transactionbloc/transaction_event.dart';
import 'package:pungutinid/bloc/transactionbloc/transaction_state.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/transactionService.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key}) : super(key: key);

  @override
  _CreateTransactionPageState createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {
  final _weightCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _weightFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  double get _weight => double.tryParse(_weightCtrl.text) ?? 0.0;
  double get _pricePerKg => double.tryParse(_priceCtrl.text) ?? 0.0;
  double get _total => _weight * _pricePerKg;

  @override
  void dispose() {
    _weightCtrl.dispose();
    _priceCtrl.dispose();
    _weightFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _showPreviewAndSubmit(BuildContext pageContext, TransactionBloc bloc, int sellerId) {
    showDialog(
      context: pageContext,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.visibility, color: Colors.green[700], size: 24),
              const SizedBox(width: 8),
              const Text('Preview Penjualan'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Placeholder untuk foto profil
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green[300]!, width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green[100],
                  child: Icon(Icons.person, size: 40, color: Colors.green[700]),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Penjual: ${pageContext.read<AuthController>().user?.fullname ?? 'Anda'}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Berat:', style: TextStyle(color: Colors.grey)),
                        Text('${_weight.toStringAsFixed(2)} kg', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Harga/kg:', style: TextStyle(color: Colors.grey)),
                        Text('Rp ${_pricePerKg.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          'Rp ${_total.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(pageContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                bloc.add(CreateSale(
                  sellerId: sellerId,
                  weightKg: _weight,
                  pricePerKg: _pricePerKg,
                ));
                Navigator.of(pageContext).pop();
              },
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputCard({
    required String title,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required String suffix,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.green[700])!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? Colors.green[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                suffixText: suffix,
                suffixStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthController>().user;
    final sellerId = user?.id;

    return BlocProvider(
      create: (_) => TransactionBloc(TransactionService()),
      child: Builder(builder: (innerCtx) {
        final bloc = innerCtx.read<TransactionBloc>();

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
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text('Jual Sampah'),
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            body: BlocListener<TransactionBloc, TransactionState>(
              listener: (ctx, state) {
                if (state is TransactionSuccess) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil dijual: ID ${state.sale.saleId}'),
                      backgroundColor: Colors.green[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  Navigator.pop(ctx);
                }
                if (state is TransactionFailure) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.error}'),
                      backgroundColor: Colors.red[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[700]!, Colors.green[500]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.recycling,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Masukkan Detail Penjualan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Isi berat dan harga sampah yang akan dijual',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Weight input
                    _buildInputCard(
                      title: 'Berat Sampah',
                      hint: 'Masukkan berat sampah',
                      controller: _weightCtrl,
                      focusNode: _weightFocusNode,
                      icon: Icons.scale,
                      suffix: 'kg',
                    ),
                    const SizedBox(height: 20),

                    // Price input
                    _buildInputCard(
                      title: 'Harga per Kilogram',
                      hint: 'Masukkan harga per kg',
                      controller: _priceCtrl,
                      focusNode: _priceFocusNode,
                      icon: Icons.attach_money,
                      suffix: 'Rp',
                      iconColor: Colors.orange[700],
                    ),
                    const SizedBox(height: 24),

                    // Total display
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Penjualan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${_total.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[700]!.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.calculate,
                              color: Colors.green[700],
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (ctx, state) {
                        final isLoading = state is TransactionLoading;
                        final isEnabled = !isLoading && 
                            sellerId != null && 
                            _weight > 0 && 
                            _pricePerKg > 0;

                        return Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: isEnabled
                                ? LinearGradient(
                                    colors: [Colors.green[700]!, Colors.green[500]!],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isEnabled ? Colors.transparent : Colors.grey[300],
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: isEnabled
                                ? () => _showPreviewAndSubmit(context, bloc, sellerId)
                                : null,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sell,
                                        size: 20,
                                        color: isEnabled ? Colors.white : Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Jual Sekarang',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isEnabled ? Colors.white : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
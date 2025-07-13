// lib/ui/pages/waste_sales_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pungutinid/bloc/buyertransactionbloc/wastesale_bloc.dart';
import 'package:pungutinid/bloc/buyertransactionbloc/wastesale_event.dart';
import 'package:pungutinid/bloc/buyertransactionbloc/wastesale_state.dart';
import 'package:pungutinid/core/model/wasteSalesModel.dart';
import 'package:pungutinid/core/service/transactionService.dart';

class WasteSalesPage extends StatelessWidget {
  const WasteSalesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WasteSaleBloc(TransactionService())..add(LoadWasteSales()),
      child: const _WasteSalesView(),
    );
  }
}

class _WasteSalesView extends StatelessWidget {
  const _WasteSalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beli Sampah"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<WasteSaleBloc, WasteSaleState>(
        builder: (context, state) {
          if (state is WasteSaleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WasteSaleLoaded) {
            final sales = state.wasteSales;
            if (sales.isEmpty) {
              return const Center(
                  child: Text("Tidak ada penjualan tersedia."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sales.length,
              itemBuilder: (ctx, i) {
                final sale = sales[i];
                return Card(
                  child: ListTile(
                    title: Text(
                        "${sale.seller.fullname} - ${sale.weightKg}kg"),
                    subtitle: Text("Rp ${sale.totalPrice}"),
                    trailing:
                        const Icon(Icons.shopping_cart_outlined),
                    onTap: () =>
                        _showPurchaseDialog(context, sale),
                  ),
                );
              },
            );
          } else if (state is WasteSaleError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WasteSale sale) {
    final bloc = context.read<WasteSaleBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: bloc,
          child: PurchaseDialog(sale: sale),
        );
      },
    );
  }
}

class PurchaseDialog extends StatefulWidget {
  final WasteSale sale;
  const PurchaseDialog({required this.sale, Key? key})
      : super(key: key);

  @override
  State<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      title: const Text("Konfirmasi Pembelian"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Penjual: ${widget.sale.seller.fullname}"),
          Text("Berat: ${widget.sale.weightKg} kg"),
          Text("Harga: Rp ${widget.sale.pricePerKg}/kg"),
          Text("Total: Rp ${widget.sale.totalPrice}"),
          const SizedBox(height: 12),
          if (selectedImage != null)
            Image.file(selectedImage!, height: 150)
          else
            const Text("Belum ada bukti pembayaran"),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text("Upload Bukti"),
            onPressed: () async {
              final picked = await ImagePicker()
                  .pickImage(source: ImageSource.gallery);
              if (picked != null) {
                setState(() {
                  selectedImage = File(picked.path);
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: selectedImage == null
              ? null
              : () {
                  context
                      .read<WasteSaleBloc>()
                      .add(UploadPaymentProof(
                        saleId: widget.sale.saleId,
                        paymentProof: selectedImage!,
                      ));
                  Navigator.pop(context);
                },
          child: const Text("Bayar"),
        ),
      ],
    );
  }
}

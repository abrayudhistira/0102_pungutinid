// lib/pages/waste_report_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pungutinid/bloc/reportbloc/report_bloc.dart';
import 'package:pungutinid/bloc/reportbloc/report_event.dart';
import 'package:pungutinid/bloc/reportbloc/report_state.dart';
import 'package:pungutinid/component/button/buyerNavbar.dart';
import 'package:pungutinid/component/button/citizenNavbar.dart';
import 'package:pungutinid/core/model/wasteReportModel.dart';
import 'package:pungutinid/core/service/reportService.dart';

class WasteReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportBloc(ReportService())..add(LoadReports()),
      child: _WasteReportView(),
    );
  }
}

class _WasteReportView extends StatefulWidget {
  @override
  _WasteReportViewState createState() => _WasteReportViewState();
}

class _WasteReportViewState extends State<_WasteReportView> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/citizenDashboard', (route) => false);
        return false; // mencegah pop default
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          elevation: 0,
          title: const Text('Laporan Sampah Liar', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.add, color: Colors.white),
          //     onPressed: () => Navigator.pushNamed(context, '/buyerDashboard'),
          //   ),
          // ],
        ),
        body: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReportLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ReportBloc>().add(LoadReports());
                },
                color: Colors.green[700],
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.reports.length,
                  itemBuilder: (_, i) => _buildReportCard(state.reports[i]),
                ),
              );
            } else if (state is ReportError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        bottomNavigationBar: CitizenNavbar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/postReport'),
          backgroundColor: Colors.green[700],
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReportCard(WasteReport report) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Gambar
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          report.imageUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 200,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                SizedBox(height: 8),
                Text('Gambar tidak tersedia', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),

      // Konten tanpa badge status
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Lokasi
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  report.location,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Deskripsi
          Text(
            report.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),

          const SizedBox(height: 12),

          // Tanggal Laporan
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Dilaporkan: ${DateFormat('dd MMM yyyy, HH:mm').format(report.reportedDate)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () => _showDetails(report),
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('Lihat Detail'),
                style: TextButton.styleFrom(foregroundColor: Colors.green[700]),
              ),
              TextButton.icon(
                onPressed: () => _share(report),
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Bagikan'),
                style: TextButton.styleFrom(foregroundColor: Colors.green[700]),
              ),
            ],
          ),
        ]),
      ),
    ]),
  );
}


  void _showDetails(WasteReport report) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Detail Laporan'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${report.id}'),
            Text('Lokasi: ${report.location}'),
            // Baris berikut dihapus:
            // Text('Status: ${report.status}'),
            Text('Deskripsi: ${report.description}'),
            Text('Dilaporkan: ${DateFormat('dd MMM yyyy, HH:mm').format(report.reportedDate)}'),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
      ],
    ),
  );
}


  void _share(WasteReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur berbagi akan segera tersedia')),
    );
  }
}

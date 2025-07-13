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
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBF8), // Softer green-tinted background
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildHeaderInfo(),
            Expanded(
              child: BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  if (state is ReportLoading) {
                    return _buildLoadingState();
                  } else if (state is ReportLoaded) {
                    if (state.reports.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildReportsList(state.reports);
                  } else if (state is ReportError) {
                    return _buildErrorState(state.message);
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CitizenNavbar(
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4CAF50), // More pleasant green
              Color(0xFF2E7D32),
            ],
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.eco,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Laporan Sampah',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF81C784),
            Color(0xFF4CAF50),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mari Jaga Lingkungan!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Laporkan sampah liar untuk lingkungan yang lebih bersih',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Memuat laporan...',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green[100]!,
                    Colors.green[200]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.eco,
                size: 60,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Belum Ada Laporan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E2E2E),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Jadilah yang pertama melaporkan sampah liar\ndi sekitar Anda untuk lingkungan yang lebih bersih!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF2E7D32),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/postReport'),
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text(
                  'Buat Laporan Pertama',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.red[200]!, width: 2),
              ),
              child: Icon(
                Icons.wifi_off,
                size: 50,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Ada Kendala',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E2E2E),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => context.read<ReportBloc>().add(LoadReports()),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList(List<WasteReport> reports) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReportBloc>().add(LoadReports());
      },
      color: const Color(0xFF4CAF50),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: reports.length,
        itemBuilder: (_, i) => _buildReportCard(reports[i]),
      ),
    );
  }

  Widget _buildReportCard(WasteReport report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with better error handling
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 180,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    report.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE8F5E8),
                            Color(0xFFC8E6C9),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak dapat dimuat',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange[600],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pending,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Proses',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location with better styling
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF4CAF50),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lokasi',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            report.location,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E2E2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Description
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        report.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Color(0xFF2E2E2E),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Date
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(report.reportedDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () => _showDetails(report),
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text(
                            'Detail',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () => _share(report),
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text(
                            'Bagikan',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4CAF50),
                            side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF2E7D32),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/postReport'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white, size: 24),
        label: const Text(
          'Lapor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showDetails(WasteReport report) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.article_outlined,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Detail Laporan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('ID Laporan', report.id),
              _buildDetailItem('Lokasi', report.location),
              _buildDetailItem('Deskripsi', report.description),
              _buildDetailItem(
                'Tanggal Laporan',
                DateFormat('dd MMM yyyy, HH:mm').format(report.reportedDate),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2E2E2E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _share(WasteReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            const Text(
              'Fitur berbagi akan segera tersedia',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class PanduanJenisSampahPage extends StatelessWidget {
  const PanduanJenisSampahPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _jenisSampah = const [
    {
      'judul': 'Sampah Organik',
      'deskripsi': 'Sampah yang mudah membusuk dan berasal dari makhluk hidup. Contoh: sisa makanan, sayuran, buah-buahan, dedaunan, ranting pohon. Dapat dikompos dalam 2-6 minggu.',
      'icon': Icons.eco,
      'color': Colors.green,
      'tips': 'Pisahkan dari sampah lain, buat kompos atau berikan ke bank sampah',
      'contoh': 'Kulit pisang, sisa nasi, daun kering, ampas teh',
      'penanganan': 'Kompos rumah tangga, biogas, atau pengomposan komunal'
    },
    {
      'judul': 'Sampah Anorganik',
      'deskripsi': 'Sampah yang tidak mudah membusuk dan membutuhkan waktu lama untuk terurai. Contoh: plastik, kaca, logam, karet. Dapat didaur ulang menjadi produk baru.',
      'icon': Icons.recycling,
      'color': Colors.blue,
      'tips': 'Bersihkan sebelum dibuang, pisahkan berdasarkan jenis material',
      'contoh': 'Botol plastik, kaleng, kaca, kardus, kertas',
      'penanganan': 'Bank sampah, daur ulang, atau dijual ke pengepul'
    },
    {
      'judul': 'Sampah B3 (Bahan Berbahaya dan Beracun)',
      'deskripsi': 'Sampah yang mengandung bahan berbahaya dan dapat merusak lingkungan serta kesehatan. Sesuai Permen LHK No. 6 Tahun 2021, harus ditangani khusus.',
      'icon': Icons.warning,
      'color': Colors.red,
      'tips': 'WAJIB dibuang ke tempat penampungan khusus B3, jangan campur dengan sampah lain',
      'contoh': 'Baterai, obat kadaluarsa, lampu neon, cat, insektisida',
      'penanganan': 'Serahkan ke fasilitas pengelolaan limbah B3 berlisensi'
    },
    {
      'judul': 'Sampah Residu',
      'deskripsi': 'Sampah yang tidak dapat didaur ulang atau dikompos. Merupakan sisa setelah proses pemilahan sampah organik, anorganik, dan B3.',
      'icon': Icons.delete,
      'color': Colors.grey,
      'tips': 'Minimalisir dengan mengurangi konsumsi produk sekali pakai',
      'contoh': 'Popok sekali pakai, pembalut, puntung rokok, styrofoam kotor',
      'penanganan': 'Buang ke TPA (Tempat Pembuangan Akhir) melalui TPS'
    },
    {
      'judul': 'Sampah Elektronik (E-Waste)',
      'deskripsi': 'Perangkat elektronik yang sudah tidak digunakan. Mengandung logam berat dan bahan berbahaya yang perlu penanganan khusus sesuai regulasi DLH.',
      'icon': Icons.computer,
      'color': Colors.purple,
      'tips': 'Serahkan ke pusat daur ulang resmi atau program take-back dari produsen',
      'contoh': 'Handphone, laptop, TV, kipas angin, rice cooker rusak',
      'penanganan': 'Pusat daur ulang elektronik berlisensi atau program CSR perusahaan'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Panduan Jenis Sampah',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Section
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
                  Icons.recycling,
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Klasifikasi Sampah Sesuai\nStandar Dinas Lingkungan Hidup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilah sampah untuk Indonesia yang lebih bersih',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _jenisSampah.length,
              itemBuilder: (context, index) {
                final item = _jenisSampah[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(16),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item['color'] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        item['judul']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          item['deskripsi']!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                      ),
                      children: [
                        const Divider(thickness: 1),
                        
                        // Contoh Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange[200]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.list, size: 14, color: Colors.orange[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Contoh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item['contoh']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Penanganan Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.build, size: 14, color: Colors.blue[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Penanganan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item['penanganan']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Tips Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 16,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tips Pengelolaan:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['tips']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[700],
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
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
          ),
          
          // Footer Info
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Klasifikasi ini mengacu pada standar Dinas Lingkungan Hidup dan peraturan pengelolaan sampah nasional Indonesia.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
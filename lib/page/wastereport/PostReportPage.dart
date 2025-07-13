import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:pungutinid/bloc/submitbloc/report_bloc.dart';
import 'package:pungutinid/bloc/submitbloc/report_event.dart';
import 'package:pungutinid/bloc/submitbloc/report_state.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/reportService.dart';

class PostReportPage extends StatefulWidget {
  const PostReportPage({super.key});

  @override
  State<PostReportPage> createState() => _PostReportPageState();
}

class _PostReportPageState extends State<PostReportPage> {
  final _descController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _reportService = ReportService();

  double? _latitude;
  double? _longitude;
  File? _imageFile;
  bool _isSubmitting = false;

  MapController _mapController = MapController();
  LatLng _defaultCenter = LatLng(-7.797068, 110.370529); // Yogyakarta default

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location service disabled')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = pos.latitude;
      _longitude = pos.longitude;
    });

    _mapController.move(LatLng(pos.latitude, pos.longitude), 17);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _dispatchReport() async {
  final userJson = context.read<AuthController>().user;

  if (userJson == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User tidak ditemukan')),
    );
    return;
  }

  if (_latitude == null || _longitude == null || _imageFile == null || _descController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lengkapi semua field terlebih dahulu')),
    );
    return;
  }

  final userId = userJson.id;

  print('[UI] Dispatching report:');
  print('User ID: $userId');
  print('Latitude: $_latitude');
  print('Longitude: $_longitude');
  print('Description: ${_descController.text}');
  print('Image path: ${_imageFile!.path}');

  context.read<ReportBloc>().add(SubmitReport(
    userId: userId,
    latitude: _latitude!,
    longitude: _longitude!,
    imageFile: _imageFile!,
    description: _descController.text,
  ));
}


  @override
  Widget build(BuildContext context) {
    final currentLocation = _latitude != null && _longitude != null
        ? LatLng(_latitude!, _longitude!)
        : _defaultCenter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Laporan Sampah'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentLocation,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.pungutinid',
                  ),
                  if (_latitude != null && _longitude != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: currentLocation,
                          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.my_location),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _latitude != null && _longitude != null
                        ? 'Lokasi: $_latitude, $_longitude'
                        : 'Lokasi belum tersedia',
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.gps_fixed),
                  label: const Text('Get Lokasi Saya'),
                  onPressed: _getCurrentLocation,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                )
              ],
            ),
            const SizedBox(height: 16),

            _imageFile != null
                ? Image.file(_imageFile!, height: 200, fit: BoxFit.cover)
                : const Placeholder(fallbackHeight: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Kamera'),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Galeri'),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            BlocListener<ReportBloc, ReportState>(
              listener: (context, state) {
                if (state is ReportSubmitted) {
                  Navigator.popAndPushNamed(context, '/wasteReport');
                } else if (state is ReportSubmitFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal mengirim laporan: ${state.error}')),
                  );
                }
              },
              child: BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is ReportSubmitting ? null : _dispatchReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is ReportSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Kirim Laporan'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }
}
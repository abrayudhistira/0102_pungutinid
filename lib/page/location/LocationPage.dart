import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pungutinid/core/service/locationService.dart';
import 'package:pungutinid/core/model/location.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/core/controller/authController.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final MapController _mapController = MapController();

  LatLng? _selectedLatLng;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedType = 'TPS';
  final List<String> _locationTypes = ['TPS', 'TPA', 'TPPengelolaan'];

  List<Location> _userLocations = [];

  @override
  void initState() {
    super.initState();
    _fetchUserLocations();
  }

  Future<void> _fetchUserLocations() async {
    final user = context.read<AuthController>().user;
    if (user == null) return;
    try {
      final locations = await LocationService().getLocationsByUserId(user.id);
      setState(() {
        _userLocations = locations;
      });
    } catch (e) {
      // Optional: tampilkan error
    }
  }

  void _handleLongPress(LatLng latlng) {
    setState(() {
      _selectedLatLng = latlng;
    });
  }

  void _handleAddLocation() async {
    if (_selectedLatLng == null) return;

    final user = context.read<AuthController>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User tidak ditemukan')),
      );
      return;
    }

    final location = Location(
      id: 0, // id akan diisi backend
      providerId: user.id, // pastikan field ini sesuai model user Anda
      name: _nameController.text,
      type: _selectedType,
      address: _addressController.text,
      latitude: _selectedLatLng!.latitude,
      longitude: _selectedLatLng!.longitude,
    );

    try {
      await LocationService().addLocation(location);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi berhasil ditambahkan')),
      );
      _nameController.clear();
      _addressController.clear();
      setState(() {
        _selectedLatLng = null;
        _selectedType = 'TPS';
      });
      await _fetchUserLocations(); // refresh marker setelah tambah lokasi
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah lokasi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultCenter = LatLng(-7.8004939538709825, 110.36626330079703);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/providerDashboard', (route) => false);
        return false; // prevent default pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tambah Lokasi'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.yellow.shade100,
              padding: EdgeInsets.all(8),
              child: Text(
                '📍 Silakan tekan dan tahan di peta selama 2 detik untuk menambahkan marker lokasi.',
                style: TextStyle(fontSize: 14),
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: defaultCenter,
                      initialZoom: 13.0,
                      onLongPress: (_, latlng) => _handleLongPress(latlng),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.pungutinid',
                      ),
                      // Marker merah untuk semua lokasi user
                      MarkerLayer(
                        markers: _userLocations.map((loc) => Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(loc.latitude ?? 0, loc.longitude ?? 0),
                          child: Icon(Icons.location_on, color: Colors.red, size: 40),
                        )).toList(),
                      ),
                      // Marker hijau untuk lokasi yang sedang dipilih
                      if (_selectedLatLng != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: _selectedLatLng!,
                              child: Icon(Icons.location_on, color: Colors.green, size: 40),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Tombol Zoom In/Out
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          heroTag: 'zoomIn',
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: () {
                            _mapController.move(_mapController.camera.center, _mapController.camera.zoom + 1);
                          },
                          child: Icon(Icons.add, color: Colors.green),
                        ),
                        SizedBox(height: 8),
                        FloatingActionButton(
                          heroTag: 'zoomOut',
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: () {
                            _mapController.move(_mapController.camera.center, _mapController.camera.zoom - 1);
                          },
                          child: Icon(Icons.remove, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lokasi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      items: _locationTypes
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedType = val!),
                      decoration: InputDecoration(
                        labelText: 'Tipe Lokasi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _selectedLatLng?.latitude.toStringAsFixed(6) ?? '',
                            ),
                            decoration: InputDecoration(
                              labelText: 'Lat',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: _selectedLatLng?.longitude.toStringAsFixed(6) ?? '',
                            ),
                            decoration: InputDecoration(
                              labelText: 'Long',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _selectedLatLng != null ? _handleAddLocation : null,
                      icon: Icon(Icons.add_location_alt),
                      label: Text('Tambah Lokasi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerLocationPage extends StatefulWidget {
  @override
  _BuyerLocationPageState createState() => _BuyerLocationPageState();
}

class _BuyerLocationPageState extends State<BuyerLocationPage> {
  final MapController _mapController = MapController();

  LatLng? _selectedLatLng;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  List<Location> _allLocations = [];
  Location? _selectedLocation; // Untuk info marker

  @override
  void initState() {
    super.initState();
    _fetchAllLocations();
  }

  Future<void> _fetchAllLocations() async {
    try {
      final locations = await LocationService().getAllLocations();
      setState(() {
        _allLocations = locations;
      });
    } catch (e) {
      // Optional: tampilkan error
    }
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'TPS':
        return Colors.green;
      case 'TPA':
        return Colors.red;
      case 'TPPengelolaan':
        return Colors.yellow[700]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultCenter = LatLng(-7.8004939538709825, 110.36626330079703);

    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Lokasi'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: defaultCenter,
                    initialZoom: 13.0,
                    onTap: (_, __) {
                      setState(() {
                        _selectedLocation = null;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.pungutinid',
                    ),
                    MarkerLayer(
                      markers: _allLocations.map((loc) {
                        final color = _getMarkerColor(loc.type ?? '');
                        return Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(loc.latitude ?? 0, loc.longitude ?? 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLocation = loc;
                              });
                            },
                            child: Icon(Icons.location_on, color: color, size: 40),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Info marker jika dipilih
                if (_selectedLocation != null)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedLocation!.name ?? '-',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Text('Tipe: ${_selectedLocation!.type ?? '-'}'),
                            SizedBox(height: 4),
                            Text('Alamat: ${_selectedLocation!.address ?? '-'}'),
                          ],
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
  }
}
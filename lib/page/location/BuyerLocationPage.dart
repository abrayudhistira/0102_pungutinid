import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:pungutinid/core/controller/authController.dart';
import 'package:pungutinid/core/service/locationService.dart';
import 'package:pungutinid/core/model/location.dart';

class BuyerLocationPage extends StatefulWidget {
  @override
  _BuyerLocationPageState createState() => _BuyerLocationPageState();
}

class _BuyerLocationPageState extends State<BuyerLocationPage> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  List<Location> _allLocations = [];
  Location? _selectedLocation;

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
      print('Error fetching locations: $e');
    }
  }

  Color _getMarkerColor(String? type) {
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

  void _onMarkerTap(Location location) {
    setState(() {
      _selectedLocation = location;
    });
    
    // Animasi pindah ke marker yang dipilih
    _mapController.move(
      LatLng(location.latitude ?? 0, location.longitude ?? 0), 
      _mapController.camera.zoom
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultCenter = LatLng(-7.8004939538709825, 110.36626330079703);
    final authCtrl = Provider.of<AuthController>(context);

    return WillPopScope(
      // onWillPop: () async {
      //   Navigator.pushNamedAndRemoveUntil(context, '/buyerDashboard', (route) => false);
      //   return false; // mencegah pop default
      // },
        onWillPop: () async {
        if (authCtrl.user != null) {
          String route = authCtrl.user!.role == 'buyer'
              ? '/buyerDashboard'
              : '/citizenDashboard';

          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        } else {
          // Jika tidak ada user login, arahkan ke login
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }

        return false; // mencegah back default
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lokasi Bank Sampah'),
          backgroundColor: Colors.green,
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: defaultCenter,
                initialZoom: 13.0,
                minZoom: 5.0,
                maxZoom: 18.0,
                onTap: (tapPosition, point) {
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
                    final color = _getMarkerColor(loc.type);
                    final isSelected = _selectedLocation?.id == loc.id;
                    
                    return Marker(
                      width: 60.0,
                      height: 60.0,
                      point: LatLng(loc.latitude ?? 0, loc.longitude ?? 0),
                      child: GestureDetector(
                        onTap: () => _onMarkerTap(loc),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.bounceOut,
                          transform: Matrix4.identity()
                            ..translate(0.0, isSelected ? -10.0 : 0.0)
                            ..scale(isSelected ? 1.2 : 1.0),
                          child: Icon(
                            Icons.location_on, 
                            color: color, 
                            size: 40,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            
            // Info card ketika marker dipilih
            if (_selectedLocation != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 24,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedLocation!.name ?? '-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 18,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.grey[600]),
                                onPressed: () {
                                  setState(() {
                                    _selectedLocation = null;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.category, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 8),
                              Text(
                                'Tipe: ${_selectedLocation!.type ?? '-'}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_city, size: 16, color: Colors.grey[600]),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Alamat: ${_selectedLocation!.address ?? '-'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            
            // Tombol Zoom In/Out
            Positioned(
              top: 100,
              right: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        final currentZoom = _mapController.camera.zoom;
                        final newZoom = (currentZoom + 1).clamp(5.0, 18.0);
                        _mapController.move(
                          _mapController.camera.center, 
                          newZoom
                        );
                      },
                      icon: Icon(Icons.add, color: Colors.green[700]),
                      iconSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        final currentZoom = _mapController.camera.zoom;
                        final newZoom = (currentZoom - 1).clamp(5.0, 18.0);
                        _mapController.move(
                          _mapController.camera.center, 
                          newZoom
                        );
                      },
                      icon: Icon(Icons.remove, color: Colors.green[700]),
                      iconSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            
            // Legend
            Positioned(
              top: 100,
              left: 16,
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Legend',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildLegendItem('TPS', Colors.green),
                      _buildLegendItem('TPA', Colors.red),
                      _buildLegendItem('TPPengelolaan', Colors.yellow[700]!),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: color, size: 16),
          SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
// feeding_station_locator.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedingStationLocator extends StatefulWidget {
  const FeedingStationLocator({super.key});

  @override
  State<FeedingStationLocator> createState() => _FeedingStationLocatorState();
}

class _FeedingStationLocatorState extends State<FeedingStationLocator> {
  final MapController _mapController = MapController();

  // Default Mindanao center coordinates
  final LatLng _mindanaoCenter = const LatLng(7.5, 125.0);
  final double _defaultZoom = 7.0;
  final double _focusedZoom = 15.0;

  // Track selected station
  int? _selectedIndex;

  // Feeding station data
  final List<Map<String, dynamic>> _stations = [
    // --- Davao City ---
    {
      'name': 'SOUTHERN PHILIPPINES MEDICAL CENTER',
      'address': 'MATERNITY WING / NICU AREA',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Hospital',
      'latitude': 7.09837,
      'longitude': 125.61984,
    },
    {
      'name': 'DAVAO DOCTORS HOSPITAL',
      'address': 'MATERNITY / OB FLOOR',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Hospital',
      'latitude': 7.07028,
      'longitude': 125.60472,
    },
    {
      'name': 'SM LANANG PREMIER',
      'address': '3RD FLOOR – MALL CLINIC AREA',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Mall',
      'latitude': 7.09901,
      'longitude': 125.63152,
    },
    {
      'name': 'SM CITY DAVAO',
      'address': '2ND FLOOR – NEAR COMFORT ROOMS',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Mall',
      'latitude': 7.05061,
      'longitude': 125.58825,
    },
    {
      'name': 'ABREEZA AYALA MALL (FAMILY LOUNGE)',
      'address': '2ND FLOOR – FAMILY LOUNGE',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Mall',
      'latitude': 7.0919,
      'longitude': 125.6131,
    },
    {
      'name': 'GAISANO MALL OF DAVAO',
      'address': 'NEAR COMFORT ROOMS',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Mall',
      'latitude': 7.0849,
      'longitude': 125.6137,
    },
    {
      'name': 'NCCC MALL BUHANGIN',
      'address': 'BUHANGIN, DAVAO CITY',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Mall',
      'latitude': 7.1065,
      'longitude': 125.6325,
    },
    {
      'name': 'DAVAO CITY OVERLAND TRANSPORT TERMINAL',
      'address': 'INSIDE TERMINAL – NEAR WAITING AREA',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'type': 'Public Hub',
      'latitude': 7.0647,
      'longitude': 125.5986,
    },
    // --- Cagayan de Oro ---
    {
      'name': 'SM CITY CAGAYAN DE ORO',
      'address': '3RD FLOOR – BABY CARE / NURSING ROOM',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'type': 'Mall',
      'latitude': 8.4542,
      'longitude': 124.6230,
    },
    {
      'name': 'CENTRIO AYALA MALL',
      'address': '2ND FLOOR – FAMILY / REST AREA',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'type': 'Mall',
      'latitude': 8.4846,
      'longitude': 124.6510,
    },
    {
      'name': 'ORORAMA SUPERCENTER',
      'address': 'CAGAYAN DE ORO CITY',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'type': 'Mall',
      'latitude': 8.4811,
      'longitude': 124.6435,
    },
    {
      'name': 'CONCENTRIX UPTOWN',
      'address': 'CAGAYAN DE ORO CITY',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'type': 'Workplace',
      'latitude': 8.4870,
      'longitude': 124.6563,
    },
    {
      'name': 'BARANGAY HEALTH STATIONS',
      'address': 'GUSA, CAMAMAN-AN, NAZARETH, MAMBUAYA, CANITO-AN',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'type': 'Public Health',
      'latitude': 8.4542,
      'longitude': 124.6319,
    },
    // --- Gingoog City ---
    {
      'name': 'GINGOOG CITY BUS TERMINAL',
      'address': 'GINGOOG CITY',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Gingoog City',
      'type': 'Public Hub',
      'latitude': 8.8206,
      'longitude': 125.1019,
    },
    // --- Camiguin ---
    {
      'name': 'CAMIGUIN AIRPORT',
      'address': 'MAMBAJAO, CAMIGUIN',
      'province': 'CAMIGUIN',
      'city': 'Mambajao',
      'type': 'Public Hub',
      'latitude': 9.2539,
      'longitude': 124.7075,
    },
  ];

  // Filter state
  String _selectedCity = 'All Cities';
  bool _showMilkBank = false;
  bool _showFeedingStation = true;

  List<Map<String, dynamic>> get _filteredStations {
    if (_selectedCity == 'All Cities') {
      return _stations;
    }
    return _stations.where((s) => s['city'] == _selectedCity).toList();
  }

  List<String> get _cities {
    final cities = _stations.map((s) => s['city'] as String).toSet().toList();
    cities.sort();
    cities.insert(0, 'All Cities');
    return cities;
  }

  void _onStationCardTapped(int index) {
    final station = _filteredStations[index];
    final location = LatLng(station['latitude'], station['longitude']);

    setState(() {
      _selectedIndex = index;
    });

    _mapController.move(location, _focusedZoom);
  }

  void _resetMapView() {
    setState(() {
      _selectedIndex = null;
    });
    _mapController.move(_mindanaoCenter, _defaultZoom);
  }

  /// Returns an icon based on the station type
  IconData _typeIcon(String type) {
    switch (type) {
      case 'Hospital':
        return Icons.local_hospital;
      case 'Mall':
        return Icons.shopping_bag;
      case 'Workplace':
        return Icons.business;
      case 'Public Hub':
        return Icons.directions_bus;
      case 'Public Health':
        return Icons.health_and_safety;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE3E8),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            _buildHeader(),

            const SizedBox(height: 8),

            // ================= SUBTITLE =================
            const Text(
              "Donate and Find the Nearest Location",
              style: TextStyle(
                color: Color(0xFFE94E80),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 16),

            // ================= TOGGLE BUTTONS =================
            _buildToggleButtons(),

            const SizedBox(height: 16),

            // ================= SEARCH / FILTER =================
            _buildCitySelector(),

            const SizedBox(height: 16),

            // ================= MAP =================
            _buildMap(),

            const SizedBox(height: 16),

            // ================= TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedCity == 'All Cities'
                      ? "BREASTFEEDING STATIONS:"
                      : "BREASTFEEDING STATIONS IN ${_selectedCity.toUpperCase()}:",
                  style: const TextStyle(
                    color: Color(0xFFE94E80),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================= STATION CARDS =================
            Expanded(
              child: _buildStationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFFFE3E8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFE94E80),
              size: 22,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo.notext.png',
                width: 38,
              ),
              const SizedBox(width: 8),
              Text(
                "MamaBond",
                style: GoogleFonts.lobster(
                  fontSize: 30,
                  color: const Color(0xFFE94E80),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications,
                color: Color(0xFFE94E80),
                size: 26,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE94E80),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate back to milk bank screen or handle routing
                Navigator.pop(context);
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: _showMilkBank
                      ? const Color(0xFFE94E80)
                      : const Color(0xFFF8A8B8),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Milk Bank",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          _showMilkBank ? FontWeight.bold : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showMilkBank = false;
                  _showFeedingStation = true;
                });
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: _showFeedingStation
                      ? const Color(0xFFE94E80)
                      : const Color(0xFFF8A8B8),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Feeding Station",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: _showFeedingStation
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _showCityPicker(),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8A8B8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _selectedCity == 'All Cities' ? 'Select City' : _selectedCity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              const Icon(Icons.tune, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select City',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE94E80),
                ),
              ),
              const SizedBox(height: 16),
              ..._cities.map((city) {
                return ListTile(
                  title: Text(
                    city,
                    style: TextStyle(
                      color: _selectedCity == city
                          ? const Color(0xFFE94E80)
                          : Colors.black87,
                      fontWeight: _selectedCity == city
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: _selectedCity == city
                      ? const Icon(Icons.check, color: Color(0xFFE94E80))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCity = city;
                      _selectedIndex = null;
                    });
                    _resetMapView();
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 280,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _mindanaoCenter,
              initialZoom: _defaultZoom,
              onTap: (_, __) => _resetMapView(),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: "com.example.mamabond",
              ),
              MarkerLayer(
                markers: _filteredStations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final station = entry.value;
                  final isSelected = _selectedIndex == index;

                  return Marker(
                    point: LatLng(station['latitude'], station['longitude']),
                    width: isSelected ? 50 : 40,
                    height: isSelected ? 50 : 40,
                    child: GestureDetector(
                      onTap: () => _onStationCardTapped(index),
                      child: Icon(
                        Icons.location_pin,
                        size: isSelected ? 50 : 40,
                        color:
                            isSelected ? const Color(0xFFE94E80) : Colors.red,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStationList() {
    final filteredList = _filteredStations;

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'No breastfeeding stations found in this area',
          style: TextStyle(
            color: Color(0xFFE94E80),
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final station = filteredList[index];
        final isSelected = _selectedIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _onStationCardTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE94E80),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFFE94E80).withOpacity(0.3)
                        : Colors.black12,
                    blurRadius: isSelected ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type icon badge
                  Container(
                    margin: const EdgeInsets.only(right: 12, top: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE3E8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _typeIcon(station['type']),
                      color: const Color(0xFFE94E80),
                      size: 20,
                    ),
                  ),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station['name'],
                          style: const TextStyle(
                            color: Color(0xFFE94E80),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          station['address'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          station['province'],
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Type chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8A8B8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            station['type'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
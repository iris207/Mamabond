// milkbank_locator.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

class MilkbankLocator extends StatefulWidget {
  const MilkbankLocator({super.key});

  @override
  State<MilkbankLocator> createState() => _MilkbankLocatorState();
}

class _MilkbankLocatorState extends State<MilkbankLocator> {
  final MapController _mapController = MapController();

  // Default Mindanao center coordinates
  final LatLng _mindanaoCenter = const LatLng(7.5, 125.0);
  final double _defaultZoom = 7.0;
  final double _focusedZoom = 15.0;

  // Track selected milkbank
  int? _selectedIndex;

  // Milkbank data
  final List<Map<String, dynamic>> _milkbanks = [
    {
      'name': 'NORTHERN MINDANAO MEDICAL CENTER',
      'address': 'CAPITOL ROAD, CAGAYAN DE ORO CITY',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'latitude': 8.48547,
      'longitude': 124.64965,
      'services': ['ACCEPTS DONATION', 'PROVIDES MILK'],
    },
    {
      'name': 'JR BORJA GENERAL HOSPITAL',
      'address': 'J.R. BORJA ST., CAGAYAN DE ORO CITY',
      'province': 'MISAMIS ORIENTAL',
      'city': 'Cagayan de Oro',
      'latitude': 8.48172,
      'longitude': 124.62808,
      'services': ['ACCEPTS DONATION', 'PROVIDES MILK'],
    },
    {
      'name': 'SOUTHERN PHILIPPINES MEDICAL CENTER',
      'address': 'J.P LAUREL AVE, BAJADA, DAVAO CITY',
      'province': 'DAVAO DEL SUR',
      'city': 'Davao City',
      'latitude': 7.0991,
      'longitude': 125.6196,
      'services': ['ONLY ALLOWS DONATION'],
    },
  ];

  // Filter state
  String _selectedCity = 'All Cities';
  bool _showMilkBank = true;
  bool _showFeedingStation = false;

  List<Map<String, dynamic>> get _filteredMilkbanks {
    if (_selectedCity == 'All Cities') {
      return _milkbanks;
    }
    return _milkbanks.where((mb) => mb['city'] == _selectedCity).toList();
  }

  List<String> get _cities {
    final cities = _milkbanks.map((mb) => mb['city'] as String).toSet().toList();
    cities.insert(0, 'All Cities');
    return cities;
  }

  void _onMilkbankCardTapped(int index) {
    final milkbank = _filteredMilkbanks[index];
    final location = LatLng(milkbank['latitude'], milkbank['longitude']);

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
                      ? "MILKBANKS IN MINDANAO:"
                      : "MILKBANKS IN ${_selectedCity.toUpperCase()}:",
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

            // ================= MILKBANK CARDS =================
            Expanded(
              child: _buildMilkbankList(),
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
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFE94E80),
              size: 22,
            ),
          ),

          // Logo and title
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

          // Notification icon
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
                setState(() {
                  _showMilkBank = true;
                  _showFeedingStation = false;
                });
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
                      fontWeight:
                          _showFeedingStation ? FontWeight.bold : FontWeight.w500,
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
              // Map tiles with dark style
              TileLayer(
                urlTemplate:
                    "[{s}.basemaps.cartocdn.com](https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png)",
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: "com.example.mamabond",
              ),

              // Markers
              MarkerLayer(
                markers: _filteredMilkbanks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final milkbank = entry.value;
                  final isSelected = _selectedIndex == index;

                  return Marker(
                    point: LatLng(milkbank['latitude'], milkbank['longitude']),
                    width: isSelected ? 50 : 40,
                    height: isSelected ? 50 : 40,
                    child: GestureDetector(
                      onTap: () => _onMilkbankCardTapped(index),
                      child: Icon(
                        Icons.location_pin,
                        size: isSelected ? 50 : 40,
                        color: isSelected ? const Color(0xFFE94E80) : Colors.red,
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

  Widget _buildMilkbankList() {
    final filteredList = _filteredMilkbanks;

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'No milkbanks found in this area',
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
        final milkbank = filteredList[index];
        final isSelected = _selectedIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _onMilkbankCardTapped(index),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    milkbank['name'],
                    style: const TextStyle(
                      color: Color(0xFFE94E80),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    milkbank['address'],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    milkbank['province'],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    (milkbank['services'] as List).length,
                    (i) => Text(
                      '•${milkbank['services'][i]}',
                      style: const TextStyle(
                        color: Color(0xFFE94E80),
                        fontSize: 11,
                      ),
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

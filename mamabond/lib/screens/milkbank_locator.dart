import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

class MilkbankLocator extends StatelessWidget {
  const MilkbankLocator({super.key});

  @override
  Widget build(BuildContext context) {

    // 📍 SPMC coordinates
    final LatLng spmcLocation = LatLng(7.0982, 125.6127);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE3E8),

      body: SafeArea(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xFFFFE3E8),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
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

                  const Icon(
                    Icons.notifications,
                    color: Color(0xFFE94E80),
                  )
                ],
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Donate and Find the Nearest Location",
              style: TextStyle(
                color: Color(0xFFE94E80),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            // ================= BUTTONS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE94E80),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Milk Bank"),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59AB5),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text("Feeding Station"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ================= SEARCH =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8A8B8),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Select City",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    Icon(Icons.tune, color: Colors.white)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ================= MAP =================
            SizedBox(
              height: 300,
              child: FlutterMap(

                options: MapOptions(
                  initialCenter: spmcLocation,
                  initialZoom: 16,
                ),

                children: [

                  // 🌍 OpenStreetMap Tiles
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: "com.example.mamabond",
                  ),

                  // 📍 Marker
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: spmcLocation,
                        width: 40,
                        height: 40,

                        child: const Icon(
                          Icons.location_pin,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= TITLE =================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "MILKBANKS IN DAVAO CITY:",
                  style: TextStyle(
                    color: Color(0xFFE94E80),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ================= CARD =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: const Color(0xFFE94E80),
                    width: 2,
                  ),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                    )
                  ],
                ),

                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "SOUTHERN PHILIPPINES MEDICAL CENTER",
                      style: TextStyle(
                        color: Color(0xFFE94E80),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "J.P LAUREL AVE, BAJADA, DAVAO CITY\nDAVAO DEL SUR",
                    ),

                    SizedBox(height: 6),

                    Text("• ONLY ALLOWS DONATION"),
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
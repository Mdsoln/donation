import 'package:donor_app/screen/appointment/screen/slot_selection_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/hospital_model.dart';
import 'dart:math';


class HospitalSelectionScreen extends StatefulWidget {
  const HospitalSelectionScreen({super.key});

  @override
  _HospitalSelectionScreenState createState() => _HospitalSelectionScreenState();
}

class _HospitalSelectionScreenState extends State<HospitalSelectionScreen> {
  final String baseUrl = "http://192.168.78.217:8080/api/v1/donor";

  List<Hospital> hospitals = [];
  bool isLoading = true;
  Position? userPosition;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getUserLocationAndHospitals();
  }

  Future<void> _cacheUserLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_latitude', position.latitude);
    await prefs.setDouble('last_longitude', position.longitude);
  }

  Future<Position?> _getCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_latitude');
    final lon = prefs.getDouble('last_longitude');

    if (lat != null && lon != null) {
      // Get current position to fill in all other fields
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        return Position(
          latitude: lat,
          longitude: lon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    }
    return null;
  }

  double _calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Earth's radius in km
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
                sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }
  double _degToRad(double deg) => deg * (pi / 180);

  Future<void> _getUserLocationAndHospitals() async {
    try {
     // Get cached location first
      userPosition = await _getCachedLocation();
      if (kDebugMode) {
        print("User location: ${userPosition?.latitude}, ${userPosition?.longitude}");
      }
      // Get fresh location if possible
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          final freshPosition = await Geolocator.getCurrentPosition();
          await _cacheUserLocation(freshPosition);
          userPosition = freshPosition;
        }
      }

      await _fetchHospitals();
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchHospitals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(
          '$baseUrl/hospitals/nearby?'
              'userLat=${userPosition?.latitude ?? 0}&'
              'userLon=${userPosition?.longitude ?? 0}&'
              'radiusKm=10',
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          hospitals = data.map((json) {
            final h = Hospital.fromJson(json);
            if (userPosition != null) {
              h.distanceKm = _calculateDistanceKm(
                userPosition!.latitude,
                userPosition!.longitude,
                h.latitude ?? 0.0,
                h.longitude ?? 0.0,
              );
            }
            return h;
          }).toList();
          //Sort by distance
          hospitals.sort((a, b) => a.distanceKm!.compareTo(b.distanceKm!));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load hospitals');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading hospitals: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button & title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Save Life Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Schedule Donation Appointment here',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40), // to balance arrow icon
                ],
              ),
            ),

            // Location selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Select Your Nearby Center",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Google Map
            Container(
              height: 180,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: userPosition == null
                  ? Center(child: Text("Loading map..."))
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      userPosition!.latitude,
                      userPosition!.longitude,
                    ),
                    zoom: 13,
                  ),
                  markers: hospitals.map((h) {
                    return Marker(
                      markerId: MarkerId(h.hospitalId.toString()),
                        position: LatLng(h.latitude ?? 0.0, h.longitude ?? 0.0),
                      infoWindow: InfoWindow(title: h.hospitalName),
                    );
                  }).toSet(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Hospital List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : ListView.separated(
                padding: EdgeInsets.only(bottom: 16),
                itemCount: hospitals.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final hospital = hospitals[index];
                  return _buildHospitalTile(hospital, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalTile(Hospital hospital, int index) {
    final bool isNearby = index == 0 && userPosition != null;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SlotSelectionScreen(hospital: hospital),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.hospitalName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(hospital.hospitalAddress),
                    Text(hospital.hospitalCity),
                    if (hospital.distanceKm != null)
                      Text(
                        '${hospital.distanceKm!.toStringAsFixed(1)} km away',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    if (isNearby)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'Nearest to you',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'See Times',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
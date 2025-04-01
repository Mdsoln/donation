import 'package:donor_app/screen/slot_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/hospital_model.dart';


class HospitalSelectionScreen extends StatefulWidget {
  @override
  _HospitalSelectionScreenState createState() => _HospitalSelectionScreenState();
}

class _HospitalSelectionScreenState extends State<HospitalSelectionScreen> {
  final String baseUrl = "http://192.168.233.49:8080/api/v1/donorapp";

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

  Future<void> _getUserLocationAndHospitals() async {
    try {
     // Get cached location first
      userPosition = await _getCachedLocation();

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
      final response = await http.get(Uri.parse(
          '${baseUrl}/hospitals/nearby?'
              'userLat=${userPosition?.latitude ?? 0}&'
              'userLon=${userPosition?.longitude ?? 0}&'
              'radiusKm=10'
      ));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          hospitals = data.map((json) => Hospital.fromJson(json)).toList();
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
      appBar: AppBar(
        title: Text('Save Life Today'),
        backgroundColor: Colors.red[700],
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Schedule Donation Appointment here',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select Your Nearby Center',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

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
              Icon(Icons.local_hospital, color: Colors.red[700], size: 40),
              SizedBox(width: 16),
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
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'clinicDetailPage.dart';
import '../controller/medicalservicesController.dart';
import 'dart:typed_data';

class MedicalService extends StatefulWidget {
  final LatLng? currentLocation;
  const MedicalService({Key? key, this.currentLocation}) : super(key: key);

  @override
  _MedicalServiceState createState() => _MedicalServiceState();
}

class _MedicalServiceState extends State<MedicalService> {
  bool isLoading = true; // Loading state
  final MedicalServices _medicalServices = MedicalServices();
  late Future<List<Map<String, dynamic>>> futureClinics;

  @override
  void initState() {
    super.initState();
    futureClinics = _medicalServices.fetchNearbyMedicalServices(widget.currentLocation!.latitude, widget.currentLocation!.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureClinics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No clinics available'));
          } else {
            final clinics = snapshot.data!;
            return ListView.builder(
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                //To pass all the fetched data into the Card, which is for onTap specific clinic
                return buildClinicCard(
                  context,
                    clinic['id'],
                    clinic['name'],
                    clinic['address'],
                    clinic['contact_no'],
                    clinic['operating_hours'],
                    clinic['service_description'],
                    clinic['latitude'],
                    clinic['longitude'],
                    clinic['imagePlace'],
                    clinic['isOpen'] ? 'Open Now' : 'Closed',
                    clinic['distance'],
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }

  Widget buildClinicCard(
      BuildContext context,
      String id,
      String name,
      String address,
      String contact,
      String operatingHours,
      String serviceDescription,
      double latitude,
      double longitude,
      Uint8List imageBytes,
      String status,
      String distance,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClinicDetailsPage(
                id: id,
                name: name,
                contact: contact.isNotEmpty ? contact : 'Not available',
                imagePath: imageBytes,
                address: address,
                operationHours: operatingHours.isNotEmpty ? operatingHours : 'Not available',
                serviceDescription: serviceDescription.isNotEmpty ? serviceDescription : 'Not available',
                latitude: latitude,
                longitude: longitude,
                distance: distance,
                status: status,
              ),
            ),
          );
        },
        child: ListTile(
          leading: Image.memory(imageBytes, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(address),
              SizedBox(height: 4),
              Text(distance, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(status, style: TextStyle(color: status == 'Open Now' ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}

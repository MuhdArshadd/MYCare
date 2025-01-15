import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'clinicDetailPage.dart';
import '../controller/medicalservicesController.dart';

class MedicalService extends StatefulWidget {
  final String category;
  final User user;
  final LatLng? currentLocation;
  const MedicalService({Key? key, this.currentLocation, required this.user, required this.category}) : super(key: key);

  @override
  _MedicalServiceState createState() => _MedicalServiceState();
}

class _MedicalServiceState extends State<MedicalService> {
  final MedicalServices _medicalServices = MedicalServices();
  late Future<List<Map<String, dynamic>>> futureClinics;

  @override
  void initState() {
    super.initState();
    futureClinics = _medicalServices.fetchNearbyMedicalServices(
      widget.currentLocation!.latitude,
      widget.currentLocation!.longitude,
      widget.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Medical Services',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                return buildClinicCard(
                  context,
                  clinic['id'],
                  clinic['clinic_name'],
                  clinic['address'],
                  clinic['contact'],
                  clinic['operating_hours'],
                  clinic['service_description'],
                  clinic['latitude'],
                  clinic['longitude'],
                  clinic['image_url'],
                  clinic['distance'],
                  clinic['isOpen'] ? 'Open Now' : 'Closed',
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
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
      String imageUrl,
      String distance,
      String status,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClinicDetailsPage(
                user: widget.user,
                id: id,
                name: name,
                contact: contact.isNotEmpty ? contact : 'Not available',
                imagePath: imageUrl,
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
          leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(address),
              SizedBox(height: 4),
              Text(distance, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Open Now' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}

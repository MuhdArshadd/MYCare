import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'chatbotAI.dart';
import 'clinicDetailPage.dart';
import '../controller/medicalservicesController.dart';
import 'appBar.dart';
import 'categoryMedicalService.dart';

class MedicalService extends StatefulWidget {
  final String category;
  final User user;
  final LatLng? currentLocation;

  const MedicalService({
    Key? key,
    this.currentLocation,
    required this.user,
    required this.category,
  }) : super(key: key);

  @override
  _MedicalServiceState createState() => _MedicalServiceState();
}

class _MedicalServiceState extends State<MedicalService> {
  final MedicalServices _medicalServices = MedicalServices();
  late Future<List<Map<String, dynamic>>> futureClinics;

  @override
  void initState() {
    super.initState();
    if (widget.currentLocation != null) {
      futureClinics = _medicalServices.fetchNearbyMedicalServices(
        widget.currentLocation!.latitude,
        widget.currentLocation!.longitude,
        widget.category,
      );
    } else {
      futureClinics = Future.error('Location not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: widget.user),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryMedicalService(currentLocation: widget.currentLocation, user: widget.user,)));
                  },
                  child: const Icon(Icons.arrow_back, size: 24),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Services',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: futureClinics,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              futureClinics = _medicalServices.fetchNearbyMedicalServices(
                                widget.currentLocation?.latitude ?? 0,
                                widget.currentLocation?.longitude ?? 0,
                                widget.category,
                              );
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No clinics available'));
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Image.asset('assets/icon_chatbot.png', semanticLabel: 'Chatbot'),
        tooltip: 'Open Chatbot',
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
          leading: Image.network(
            imageUrl.isNotEmpty ? imageUrl : 'assets/placeholder_image.png',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/placeholder_image.png', width: 50, height: 50);
            },
          ),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(address),
              const SizedBox(height: 4),
              Text(distance, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
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

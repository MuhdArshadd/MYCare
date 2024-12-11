import 'package:flutter/material.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';
import 'clinicDetailPage.dart';

class MedicalService extends StatefulWidget {
  @override
  _MedicalServiceState createState() => _MedicalServiceState();
}

class _MedicalServiceState extends State<MedicalService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        children: [
          buildClinicCard(
            context,
            'Tzu-Chi Free Clinic (Jalan Pudu)',
            '+60392261673 / +60183783727',
            'assets/tzu_chi_clinic.jpg',
          ),
          buildClinicCard(
            context,
            'HOPE Worldwide Free Clinic',
            '+60340454637',
            'assets/hope_clinic.jpg',
          ),
          buildClinicCard(
            context,
            'Klinik QFFD - Mercy (Ampang)',
            '+60342886364',
            'assets/klinik_qffd.jpg',
          ),
          buildClinicCard(
            context,
            'Klinik Amal Mujahir (Seri Kembangan)',
            '+60389385511',
            'assets/klinik_amal.jpg',
          ),
        ],
      ),
     bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }
  Widget buildClinicCard(
      BuildContext context, String name, String contact, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClinicDetailsPage(
                name: name,
                contact: contact,
                imagePath: imagePath,
                address: '',
                operationHours: '',
              ),
            ),
          );
        },
        child: ListTile(
          leading: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text('Contact No:'),
              Text(
                contact,
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }

}

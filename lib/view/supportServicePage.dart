import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../controller/newsController.dart'; // Import your controller
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'foodbankPage.dart';
import 'skillBuildingPage.dart';
import 'medicalService.dart';

class SupportServicePage extends StatefulWidget {
  final String noIc;
  const SupportServicePage({super.key, required this.noIc});

  @override
  State<SupportServicePage> createState() => _SupportServicePageState();
}

class _SupportServicePageState extends State<SupportServicePage> {
  List<Map<String, dynamic>> _supportServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSupportServices();
  }

  Future<void> _fetchSupportServices() async {
    try {
      News news = News();
      var services = await news.fetchSupportService();
      setState(() {
        _supportServices = services;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching support services: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.arrow_back, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Support Service',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _supportServices.isNotEmpty
                  ? Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _supportServices.map((service) {
                  return ServiceCard(
                    title: service['name'],
                    imageBytes: service['images'],
                  );
                }).toList(),
              )
                  : const Center(child: Text("No support services available.")),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final Uint8List imageBytes;

  const ServiceCard({
    required this.title,
    required this.imageBytes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Foodbank') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodbankPage()),
          );
        } else if (title == 'Medical service') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MedicalService()),
          );
        } else if (title == 'Skill Building Programme') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SkillBuildingPage()),
          );
        } else {
          print('$title tapped');
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                imageBytes,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

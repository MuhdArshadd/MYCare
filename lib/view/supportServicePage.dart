import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';

class SupportServicePage extends StatelessWidget {
  const SupportServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Support Service',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceCard(
                    title: 'Foodbank',
                    imageUrl: 'https://example.com/foodbank.png',
                    onTap: () {
                      // Handle foodbank tap
                      _launchURL('https://example.com/foodbank');
                    },
                  ),
                  ServiceCard(
                    title: 'Medical Service',
                    imageUrl: 'https://example.com/medical.png',
                    onTap: () {
                      // Handle medical service tap
                      _launchURL('https://example.com/medical');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ServiceCard(
                title: 'Skill Building Programme',
                imageUrl: 'https://example.com/skill.png',
                onTap: () {
                  // Handle skill building programme tap
                  _launchURL('https://example.com/skill');
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const ServiceCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.network(imageUrl),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
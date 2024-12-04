import 'package:flutter/material.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';

class FoodbankDetailPage extends StatelessWidget {
  const FoodbankDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Foodbank',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://via.placeholder.com/300x200',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 200,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                title: 'Address',
                content:
                'PETRONAS Durian Tunggal\nM2 Jalan Gangsa, Durian Tunggal, Melaka, Malaysia',
                hasLink: true,
                linkText: 'Click this link for direction:',
                linkButtonText: 'Maps',
                onLinkTap: () {
                  // Handle Maps button tap
                  print('Maps tapped!');
                },
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                title: 'Type of Donations',
                content: 'Makanan Kering',
              ),
              const SizedBox(height: 16),
              _buildSection(
                context,
                title: 'Contact No',
                content: '06-5533054',
                icon: Icons.email,
              ),
            ],
          ),
        ),
      ),
     bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title,
        required String content,
        bool hasLink = false,
        String? linkText,
        String? linkButtonText,
        VoidCallback? onLinkTap,
        IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: Colors.black),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                content,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        if (hasLink && linkText != null && linkButtonText != null) ...[
          const SizedBox(height: 8),
          Text(
            linkText,
            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: onLinkTap,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(linkButtonText),
          ),
        ],
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(home: FoodbankDetailPage()));
}

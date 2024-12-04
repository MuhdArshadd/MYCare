import 'package:flutter/material.dart';
import 'bottomNavigationBar.dart';
import 'appBar.dart';
import 'foodbankPage.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Support service',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceCard(
                    title: 'Foodbank',
                    imageUrl: 'https://via.placeholder.com/150',
                  ),
                  ServiceCard(
                    title: 'Medical service',
                    imageUrl: 'https://via.placeholder.com/150',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ServiceCard(
                  title: 'Skill Building Programme',
                  imageUrl: 'https://via.placeholder.com/150',
                ),
              ),
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
  final String imageUrl;

  const ServiceCard({
    required this.title,
    required this.imageUrl,
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
        }
        else if (title =='Medical service')
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodbankPage()),
          );
        }
        else if (title == 'Skill Building Programme' )
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodbankPage()),
          );
        }
        else
        {
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
            Image.network(
              imageUrl,
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

void main() {
  runApp(const MaterialApp(home: SupportServicePage()));
}

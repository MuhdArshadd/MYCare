import 'package:flutter/material.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';

class SkillDetailsPage extends StatefulWidget {
  const SkillDetailsPage({super.key});

  @override
  State<SkillDetailsPage> createState() => _SkillDetailsPageState();
}

class _SkillDetailsPageState extends State<SkillDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with Back Button at the top of the body
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Technical Skills',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Spacing below the title
            Expanded(
              child: ListView(
                children: [
                  _buildTrainingCard(
                    logoPath: 'assets/ntw_logo.png',
                    title: 'Guard Of Electrical Machinery B0 11kV',
                    venue: 'IKBN Kinarut',
                    date: '29/10/2024',
                  ),
                  _buildTrainingCard(
                    logoPath: 'assets/ntw_logo.png',
                    title: 'Certified Energy Manager Training Course',
                    venue: 'The Katerina Hotel, Batu Pahat',
                    date: '1/6/2024 - 6/6/2024',
                  ),
                  _buildTrainingCard(
                    logoPath: 'assets/ntw_logo.png',
                    title: 'AutoCAD 2024 Training for 4IR PSH',
                    venue: 'Kolej Komuniti Besut, Terengganu',
                    date: '22/7/2024 - 23/7/2024',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle "See All" button press
                  print('See All tapped!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'See All',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2),
    );
  }

  Widget _buildTrainingCard({
    required String logoPath,
    required String title,
    required String venue,
    required String date,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo/Image
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(logoPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Training Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Venue: $venue',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: $date',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Handle "View Link" button press
                      print('View Link tapped for $title!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View Link',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../controller/skillsController.dart';
import '../model/userModel.dart';
import 'appBar.dart';
import 'bottomNavigationBar.dart';

class SkillDetailsPage extends StatefulWidget {
  final String category;
  final User user;

  const SkillDetailsPage({super.key, required this.category, required this.user});

  @override
  State<SkillDetailsPage> createState() => _SkillDetailsPageState();
}

class _SkillDetailsPageState extends State<SkillDetailsPage> {
  final Skills skillController = Skills();

  // Future to hold skill data
  late Future<List<Map<String, dynamic>>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch skills based on criteria
    _skillsFuture = skillController.fetchSkills(widget.category, widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and back button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.category,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display skills dynamically
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _skillsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No skills available.'));
                  } else {
                    final skills = snapshot.data!;
                    return ListView.builder(
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        final skill = skills[index];
                        return _buildTrainingCard(
                          skillsID: skill['id'],
                          companyLogo: skill['imageCompany'],
                          title: skill['name'],
                          organizer: skill['organizer'],
                          venue: skill['venue'],
                          startDate: skill['startDate'],
                          endDate: skill['endDate'],
                          criteria: skill['criteria'],
                          availability: skill['availability'],
                        );
                      },
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 8),

            // "See All" Button
            Center(
              child: ElevatedButton(
                onPressed: () {
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
      bottomNavigationBar: BottomNavWrapper(currentIndex: 2, user: widget.user),
    );
  }

  // Reusable Training Card Widget
  Widget _buildTrainingCard({
    required String skillsID,
    required Uint8List companyLogo,
    required String title,
    required String organizer,
    required String venue,
    required String startDate,
    required String endDate,
    required Map<String, dynamic> criteria, // Change to Map
    required String availability,
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
            // Logo
            if (companyLogo.isNotEmpty) ...[
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: Image.memory(companyLogo).image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ] else ...[
              Container(
                height: 80,
                width: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.image, size: 40),
              ),
            ],
            const SizedBox(width: 16),

            // Details
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
                    'Organizer: $organizer',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Venue: $venue',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: $startDate - $endDate',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: $availability',
                    style: TextStyle(
                      fontSize: 14,
                      color: availability == 'Available' ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Display Criteria if exists
                  if (criteria.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Criteria:',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if (criteria['minAge'] != null) Text('Min Age: ${criteria['minAge']}'),
                    if (criteria['maxAge'] != null) Text('Max Age: ${criteria['maxAge']}'),
                    if (criteria['userCategory'] != null) Text('User Category: ${criteria['userCategory']}'),
                    if (criteria['incomeRange'] != null) Text('Income Range: ${criteria['incomeRange']}'),
                    if (criteria['marriageStatus'] != null) Text('Marriage Status: ${criteria['marriageStatus']}'),
                  ],
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: availability == 'Available'
                        ? () {
                      Navigator.pushNamed(
                        context,
                        '/skillDetailPage',
                        arguments: {'skillsID': skillsID},
                      );
                    }
                        : null, // Disable button if not available
                    style: ElevatedButton.styleFrom(
                      backgroundColor: availability == 'Available' ? Colors.blue : Colors.grey,
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

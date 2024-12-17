import 'package:flutter/material.dart';
import 'package:workshop2dev/view/appBar.dart';
import 'newsPage.dart';
import 'bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Mutable index to track the current page

  final List<Widget> _pages = [
    Center(child: Text('Home Content', style: TextStyle(fontSize: 24))), // Placeholder for Home content
    Center(child: Text('News', style: TextStyle(fontSize: 24))), // Placeholder for News content
    Center(child: Text('Forum', style: TextStyle(fontSize: 24))), // Placeholder for Forum content
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))), // Placeholder for Profile content
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _currentIndex == 0
          ? _buildHomeContent() // Show home content if index is 0
          : _pages[_currentIndex], // Show other pages based on the current index
     bottomNavigationBar: BottomNavWrapper(currentIndex: 0),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipableSectionWidget(
              title: 'News ',
              items: [
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Golongan B40 pelajar IPT di bawah KPT terima peranti siswa 2024',
                ),
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'New initiative for student welfare in 2024',
                ),
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Digital tools for education in rural areas',
                ),
              ],
              onSeeMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
              },
            ),
            SwipableSectionWidget(
              title: 'Support Services',
              items: [
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Food Aid Foundation, Kuala Lumpur',
                ),
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Volunteer opportunities in Malaysia',
                ),
              ],
              onSeeMore: () {
                print('See more support services');
              },
            ),
            SwipableSectionWidget(
              title: 'Forum',
              items: [
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Community discussions and tips',
                ),
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Healthy eating tips for students',
                ),
              ],
              onSeeMore: () {
                print('See more forum');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SwipableSectionWidget extends StatefulWidget {
  final String title;
  final List<SectionItem> items;
  final VoidCallback onSeeMore;

  const SwipableSectionWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onSeeMore,
  });

  @override
  _SwipableSectionWidgetState createState() => _SwipableSectionWidgetState();
}

class _SwipableSectionWidgetState extends State<SwipableSectionWidget> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _currentPage = 0;

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: _currentPage == index ? 12 : 8,
      height: _currentPage == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextButton(
              onPressed: widget.onSeeMore,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.items[index].imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.items[index].description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
                (index) => _buildIndicator(index),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class SectionItem {
  final String imageUrl;
  final String description;

  SectionItem({required this.imageUrl, required this.description});
}

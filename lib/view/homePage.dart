import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyCare App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    Center(child: Text('Global', style: TextStyle(fontSize: 24))),
    Center(child: Text('FAQs', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.menu),
            SizedBox(width: 10),
            Text('MyCare', style: TextStyle(fontSize: 20)),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.grey[8000],
        height: 70, // Set a height to ensure the shape is visible
        decoration: BoxDecoration(
          color: Colors.grey[800], // Dark grey background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60), // Curves the top-left corner
            topRight: Radius.circular(60), // Curves the top-right corner
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.grey[600], // Set the background to transparent
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blue, // Color for selected items
          unselectedItemColor: Colors.grey[500], // Color for unselected items
          showUnselectedLabels: true, // Show labels for unselected items
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'Global',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: 'FAQs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipableSectionWidget(
              title: 'News',
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
                // Navigate to the full news page
                print('See more news');
              },
            ),
            SwipableSectionWidget(
              title: 'Support service',
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
                // Navigate to the support services page
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
                // Navigate to the forum page
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
    _pageController = PageController(viewportFraction: 0.9);
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: widget.onSeeMore,
              child: Row(
                children: [
                  Text('See more', style: TextStyle(fontSize: 16)),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 250, // Adjust height as needed
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
                          style: TextStyle(fontSize: 16),
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
        SizedBox(height: 10),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
                (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class SectionItem {
  final String imageUrl;
  final String description;

  SectionItem({required this.imageUrl, required this.description});
}

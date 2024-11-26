import 'package:flutter/material.dart';
import 'newsPage.dart';

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
    Center(child: Text('News', style: TextStyle(fontSize: 24))),
    Center(child: Text('Forum', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('MyCare', style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {
              if (value == 'Notifications') {
                print('Notifications selected');
              } else if (value == 'Settings') {
                print('Settings selected');
              } else if (value == 'Help') {
                print('Help selected');
              }
            },
            offset: Offset(-100, 50), // Adjust this to control popup position
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Notifications',
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Notifications'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Settings'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Help',
                child: Row(
                  children: [
                    Icon(Icons.help, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Help'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
            bottomRight: Radius.circular(60),
            bottomLeft: Radius.circular(60),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey[400],
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsPage()),
                  );
                } else {
                  _currentIndex = index;
                }
              });
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.public),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.support),
                label: 'Support Service',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Forum',
              ),
            ],
          ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsPage()),
                );
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
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
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
        SizedBox(height: 10),
        Container(
          height: 250,
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

import 'package:flutter/material.dart';
import 'newsPage.dart';
import 'homePage.dart'; // Import the HomePage for navigation

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _currentIndex = 1;  // Set the initial index to 1 as News is at index 1 in the bottom navigation bar

  final List<Widget> _pages = [
    HomeContent(),
    NewsPageContent(),
    Center(child: Text('Forum', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: _pages[_currentIndex],  // Show the page based on the selected tab

      bottomNavigationBar: Container(
        height: 80, // Adjust height to fit the design
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
            backgroundColor: Colors.grey[400], // Matches container background
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  _currentIndex = index; // Update the current index only for other tabs
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
                icon: Icon(Icons.help_outline),
                label: 'Forum',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwipableSectionWidget(
              title: 'Latest News',
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
                // Implement logic to load more news if necessary
                print('See more news');
              },
            ),
            SizedBox(height: 20),
            SwipableSectionWidget(
              title: 'Announcements',
              items: [
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'Updates on student grants for 2024',
                ),
                SectionItem(
                  imageUrl: 'https://via.placeholder.com/400x200',
                  description: 'New scholarship opportunities in Malaysia',
                ),
              ],
              onSeeMore: () {
                // Implement logic for announcements
                print('See more announcements');
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
                padding: EdgeInsets.zero, // Removes default padding
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Adjust padding
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color
                  borderRadius: BorderRadius.circular(8), // Rounded rectangle
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Text color
                      ),
                    ),
                    SizedBox(width: 4), // Space between text and icon
                    Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
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

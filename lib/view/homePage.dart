import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for rootBundle
import 'package:workshop2dev/view/appBar.dart';
import 'newsPage.dart';
import 'bottomNavigationBar.dart';
import 'package:workshop2dev/controller/newsController.dart';
import 'dart:typed_data';
import 'supportServicePage.dart';
import 'forumPage.dart';

class HomePage extends StatefulWidget {
  final String noIc;
  const HomePage({super.key, required this.noIc});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _newsArticles = [];
  List<SectionItem> _supportServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNewsArticles();
    _loadStaticSupportServices();
  }

  Future<void> _fetchNewsArticles() async {
    News news = News();
    var fetchedNews = await news.fetchNews();
    setState(() {
      _newsArticles = fetchedNews.take(3).toList(); // Limit to 3 articles for home page
    });
  }

  Future<void> _loadStaticSupportServices() async {
    _supportServices = [
      SectionItem(
        imageBytes: (await rootBundle.load('assets/foodbank.png')).buffer.asUint8List(),
        description: 'FoodBank',
      ),
      SectionItem(
        imageBytes: (await rootBundle.load('assets/medical.png')).buffer.asUint8List(),
        description: 'Medical Services',
      ),
      SectionItem(
        imageBytes: (await rootBundle.load('assets/skill.png')).buffer.asUint8List(),
        description: 'Skill Building',
      ),
    ];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _currentIndex == 0
          ? _buildHomeContent()
          : Center(
        child: Text(
          'Content for tab $_currentIndex',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: _currentIndex),
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
              title: 'News',
              items: _newsArticles.map((article) {
                return SectionItem(
                  imageBytes: article['images'],
                  description: article['headline'],
                );
              }).toList(),
              onSeeMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsPage(noIc: widget.noIc)),
                );
              },
            ),
            const SizedBox(height: 20),
            SwipableSectionWidget(
              title: 'Support Services',
              items: _supportServices,
              onSeeMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportServicePage(noIc: widget.noIc)),
                );
              },
            ),
            const SizedBox(height: 20),
            SwipableSectionWidget(
              title: 'Forum',
              items: [
                SectionItem(
                  imageBytes: null,
                  description: 'Null',
                ),
                SectionItem(
                  imageBytes: null,
                  description: 'Null',
                ),
                SectionItem(
                  imageBytes: null,
                  description: 'Skill Building Programme',
                ),
              ],
              onSeeMore: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForumPage(user: {},)),
                );
              },
            ),
            // Add more sections if needed
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
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      widget.items[index].imageBytes != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          widget.items[index].imageBytes!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      )
                          : Container(height: 150, color: Colors.grey),
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
  final Uint8List? imageBytes;
  final String description;

  SectionItem({required this.imageBytes, required this.description});
}

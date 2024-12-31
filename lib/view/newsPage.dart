import 'package:flutter/material.dart';
import 'package:workshop2dev/view/appBar.dart';
import '../model/userModel.dart';
import 'bottomNavigationBar.dart';
import 'package:workshop2dev/controller/newsController.dart';
import 'dart:typed_data';
import 'newsDetailPage.dart'; // Import NewsDetailPage

class NewsPage extends StatefulWidget {
  final User user;
  const NewsPage({super.key, required this.user});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Map<String, dynamic>>> newList;
  String _searchText = "";
  String? _selectedFilter;
  String? _selectedCategory;

  List<Map<String, dynamic>> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    News news = News();
    var fetchedNews = await news.fetchNews();
    setState(() {
      _articles = fetchedNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredArticles = _articles.where((article) {
      bool matchesSearch = article['headline']
          .toLowerCase()
          .contains(_searchText.toLowerCase());
      bool matchesCategory = _selectedCategory == null ||
          article['newstype'].toLowerCase() == _selectedCategory?.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar:  CustomAppBar(user: widget.user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "News", // News title
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: const [
                      DropdownMenuItem(
                        value: "latest",
                        child: Text("Latest"),
                      ),
                      DropdownMenuItem(
                        value: "popular",
                        child: Text("Popular"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value;
                      });
                    },
                    hint: const Text("Filter by"),
                  ),
                ],
              ),
              const SizedBox(height: 9), // Space between the row and the search bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildCategoryChip("education", Colors.blue),
                  _buildCategoryChip("healthcare", Colors.green),
                  _buildCategoryChip("financial", Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              for (var article in filteredArticles) _buildNewsCard(article),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 1, user: widget.user),
    );
  }

  Widget _buildCategoryChip(String label, Color color) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      selected: _selectedCategory == label.toLowerCase(),
      onSelected: (isSelected) {
        setState(() {
          _selectedCategory = isSelected ? label.toLowerCase() : null;
        });
      },
      selectedColor: color,
      backgroundColor: color.withOpacity(0.5),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> article) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          article['images'] != null && article['images'] is Uint8List &&
              article['images'].isNotEmpty
              ? GestureDetector(
            onTap: () {
              _navigateToNewsDetailPage(article, widget.user);
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.memory(
                article['images'],
                width: double.infinity,
                fit: BoxFit.contain, // Adjust the image size with BoxFit.contain
              ),
            ),
          )
              : GestureDetector(
            onTap: () {
              _navigateToNewsDetailPage(article, widget.user);
            },
            child: Container(height: 250, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['headline'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _navigateToNewsDetailPage(article, widget.user);
                  },
                  child: const Text(
                    'View More',
                    style: TextStyle(color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNewsDetailPage(Map<String, dynamic> article, User? user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(article: article, user: widget.user),
      ),
    );
  }
}

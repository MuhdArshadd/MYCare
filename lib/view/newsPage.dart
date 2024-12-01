import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import 'package:workshop2dev/view/appBar.dart';
import 'bottomNavigationBar.dart';

class NewsArticle {
  final String imageUrl;
  final String title;
  final String link;
  final String category; // Add category for filtering

  NewsArticle({
    required this.imageUrl,
    required this.title,
    required this.link,
    required this.category,
  });
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final List<NewsArticle> _articles = [
    NewsArticle(
      imageUrl: 'https://via.placeholder.com/400x200',
      title: 'Golongan B40 pelajar IPT di bawah KPT terima peranti siswa 2022',
      link: 'https://perantisiswa.komunikasi.gov.my/login',
      category: 'education',
    ),
    NewsArticle(
      imageUrl: 'https://via.placeholder.com/400x200',
      title: 'Bantuan E-Tunai Belia Rahmah Bernilai RM200 Khusus Untuk Golongan Belia',
      link: 'https://portal.touchngo.com.my/login',
      category: 'financial',
    ),
    NewsArticle(
      imageUrl: 'https://via.placeholder.com/400x200',
      title: 'Permohonan Bantuan Persekolahan RM150 2024',
      link: 'https://marfitalent.gov.my/bozda/rmdtk/bsk',
      category: 'healthcare',
    ),
  ];

  String _searchText = "";
  String? _selectedFilter; // For storing the selected filter value

  @override
  Widget build(BuildContext context) {
    // Filter articles based on search text
    List<NewsArticle> filteredArticles = _articles.where((article) {
      final matchesSearch = article.title.toLowerCase().contains(_searchText.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search and Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchText = value; // Update search text
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: [
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
                        _selectedFilter = value; // Update filter selection
                      });
                    },
                    hint: Text("Filter by"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Category Chips
              Wrap(
                spacing: 8.0,
                children: [
                  _buildCategoryChip("education", Colors.blue),
                  _buildCategoryChip("healthcare", Colors.green),
                  _buildCategoryChip("financial", Colors.orange),
                ],
              ),
              SizedBox(height: 16),
              // News Cards
              for (var article in filteredArticles) // Use filtered articles here
                _buildNewsCard(article),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavWrapper(currentIndex: 1),
    );
  }

  Widget _buildCategoryChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(article.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    // Open the link
                    if (await canLaunch(article.link)) {
                      await launch(article.link);
                    } else {
                      throw 'Could not launch ${article.link}';
                    }
                  },
                  child: Text(
                    'View More',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';

import '../dbConnection/dbConnection.dart'; // Import the necessary package

class News {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<List<Map<String, dynamic>>> fetchNews() async {
    // Store into a list
    List<Map<String, dynamic>> newsList = [];

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      // Query to fetch news
      var results = await dbConnection.connection.query(''' 
        SELECT 
          news_id, 
          headline, 
          author, 
          date, 
          description, 
          newstype, 
          newscriteria,
          images
        FROM news
      ''');

      for (var row in results) {
        newsList.add({
          'news_id': row[0].toString(), // Integer to string conversion
          'headline': row[1] as String,
          'author': row[2] as String,
          'date': row[3] as DateTime,
          'description': row[4] as String,
          'newstype': row[5] as String,
          'newscriteria': row[6] as String,
          'images': row[7] as Uint8List, // Store as String
        });
      }
    } catch (e) {
      print('Error fetching News: $e');
    } finally {
      // Ensure the connection is closed
      dbConnection.closeConnection();
    }

    return newsList;
  }

  Future<List<Map<String, dynamic>>> fetchSupportService() async {
    // Store into a list
    List<Map<String, dynamic>> supportServiceList = [];

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      // Query to fetch news
      var results = await dbConnection.connection.query(''' 
        SELECT 
          id, 
          name, 
          images
        FROM image_data
      ''');

      for (var row in results) {
        supportServiceList.add({
          'id': row[0].toString(), // Integer to string conversion
          'name': row[1] as String,
          'images': row[2] as Uint8List,
        });
      }
    } catch (e) {
      print('Error fetching SupportService: $e');
    } finally {
      // Ensure the connection is closed
      dbConnection.closeConnection();
    }

    return supportServiceList;
  }
}

import 'dart:convert'; //s
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
          id, 
          title, 
          author, 
          description, 
          date, 
          type, 
          image_url
        FROM news
      ''');

      for (var row in results) {
        newsList.add({
          'id': row[0].toString(), // Integer to string conversion
          'title': row[1] as String,
          'author': row[2] as String,
          'description': row[3] as String,
          'date': row[4] as String,
          'type': row[5] ,
          'image_url': row[6] as String, // Store as String
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

  // Future<List<Map<String, dynamic>>> fetchSupportService() async {
  //   // Store into a list
  //   List<Map<String, dynamic>> supportServiceList = [];
  //
  //   try {
  //     // Ensure the database connection is open
  //     await dbConnection.connectToDatabase();
  //
  //     // Query to fetch news
  //     var results = await dbConnection.connection.query('''
  //       SELECT
  //         id,
  //         name,
  //         images
  //       FROM image_data
  //     ''');
  //
  //     for (var row in results) {
  //       supportServiceList.add({
  //         'id': row[0].toString(), // Integer to string conversion
  //         'name': row[1] as String,
  //         'images': row[2] as Uint8List,
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching SupportService: $e');
  //   } finally {
  //     // Ensure the connection is closed
  //     dbConnection.closeConnection();
  //   }
  //
  //   return supportServiceList;
  // }
}

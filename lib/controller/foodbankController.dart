

import 'dart:typed_data';
import 'package:workshop2dev/dbConnection/dbConnection.dart';
import 'package:postgres/postgres.dart';

class FoodBank {
  //initialise database connection controller
  final DatabaseConnection dbConnection = DatabaseConnection();
  // Fetch nearby foodbanks based on user's latitude and longitude
  Future<List<Map<String, dynamic>>> fetchNearbyFoodbanks(double userLatitude, double userLongitude) async {
    // Store into a list
    List<Map<String, dynamic>> nearbyFoodbanks = [];

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      // Query to fetch nearby foodbanks
      var results = await dbConnection.connection.query('''
        SELECT 
          foodbank_ID, 
          foodbankName, 
          address::TEXT, -- Convert JSON to text for easier handling
          contactNo, 
          typeofFood, 
          foodbankStatus, 
          latitude, 
          longitude, 
          imagePlace,
          (6371 * acos(
            cos(radians($userLatitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($userLongitude)) +
            sin(radians($userLatitude)) * sin(radians(latitude))
          )) AS distance
        FROM foodbanks
        WHERE foodbankStatus = 'Aktif' -- Example condition: Only fetch active foodbanks
        ORDER BY distance
      ''');

      for (var row in results) {
        nearbyFoodbanks.add({
          'foodbank_ID': row[0].toString(), // Integer to string conversion
          'foodbankName': row[1] as String,
          'address': row[2] as String, // Address as JSON string
          'contactNo': row[3] as String,
          'typeofFood': row[4] as String,
          'foodbankStatus': row[5] as String,
          'latitude': row[6] as double,
          'longitude': row[7] as double,
          'imagePlace': row[8] as Uint8List, // Assuming this is stored as base64 string
          'distance': '${row[9].toStringAsFixed(2)} KM away', // Calculated distance
        });
        print(nearbyFoodbanks);
      }
    } catch (e) {
      print('Error fetching foodbanks: $e');
    } finally {
      // Ensure the connection is closed
      dbConnection.closeConnection();
    }
    //return nearby foodbanks data
    return nearbyFoodbanks;
  }

}
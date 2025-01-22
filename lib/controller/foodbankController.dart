import 'dart:typed_data';
import 'package:workshop2dev/dbConnection/dbConnection.dart';

//foodbank controller
class FoodBank {
  final DatabaseConnection dbConnection = DatabaseConnection();

  // Fetch nearby foodbanks based on user's latitude and longitude and state
  Future<List<Map<String, dynamic>>> fetchNearbyFoodbanks(double userLatitude, double userLongitude, String state) async {
    // Store into a list
    List<Map<String, dynamic>> nearbyFoodbanks = [];

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      if (state == "All")
        {
            // Query to fetch nearby foodbanks
            var results = await dbConnection.connection.query('''
            SELECT 
              id, 
              foodbankname, 
              address,
              contactno,
              typeoffood,
              foodbankstatus,
              image_url, 
              latitude, 
              longitude, 
              (6371 * acos(
                cos(radians($userLatitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($userLongitude)) +
                sin(radians($userLatitude)) * sin(radians(latitude))
              )) AS distance
            FROM foodbanks_new
            WHERE foodbankstatus = 'Aktif'
            ORDER BY distance
          ''');

            for (var row in results) {
              nearbyFoodbanks.add({
                'id': row[0].toString(), // Integer to string conversion
                'foodbankname': row[1] as String,
                'address': row[2] as String,
                'contactno':row[3] as String,
                'typeoffood':row[4] as String,
                'foodbankstatus':row[5] as String,
                'image_url': row[6] as String,
                'latitude': row[7] as double,
                'longitude': row[8] as double,
                'distance': '${row[9].toStringAsFixed(2)} KM away', // Calculated distance
              });
              print(nearbyFoodbanks);
            }
        } else {
        // Query to fetch nearby foodbanks
        var results = await dbConnection.connection.query('''
            SELECT 
              id, 
              foodbankname, 
              address,
              contactno,
              typeoffood,
              foodbankstatus,
              image_url, 
              latitude, 
              longitude, 
              (6371 * acos(
                cos(radians($userLatitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($userLongitude)) +
                sin(radians($userLatitude)) * sin(radians(latitude))
              )) AS distance
            FROM foodbanks_new
            WHERE foodbankstatus = 'Aktif' AND foodbankstate = '$state'
            ORDER BY distance
          ''');

        for (var row in results) {
          nearbyFoodbanks.add({
            'id': row[0].toString(),
            // Integer to string conversion
            'foodbankname': row[1] as String,
            'address': row[2] as String,
            'contactno': row[3] as String,
            'typeoffood': row[4] as String,
            'foodbankstatus': row[5] as String,
            'image_url': row[6] as String,
            'latitude': row[7] as double,
            'longitude': row[8] as double,
            'distance': '${row[9].toStringAsFixed(2)} KM away',
            // Calculated distance
          });
          print(nearbyFoodbanks);
        }
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

  // Fetch detailed foodbanks based on foodbank id (only one row of data)
  Future<Map<String, dynamic>?> fetchFoodbankDetails(String foodbankID) async {
    Map<String, dynamic>? foodbankDetails;

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      // Query to fetch a single foodbank based on foodbankID
      var results = await dbConnection.connection.query('''
      SELECT
        id,
        foodbankname,
        address,
        contactno,
        typeoffood,
        foodbankstatus,
        image_url,
        latitude,
        longitude
      FROM foodbanks_new
      WHERE id = @id
    ''', substitutionValues: {
        'id': foodbankID,
      });

      // If the result is not empty, map the row data to a map
      if (results.isNotEmpty) {
        var row = results.first;
        foodbankDetails = {
          'id': row[0].toString(), // Integer to string conversion
          'foodbankname': row[1] as String,
          'address': row[2] as String,
          'contactno': row[3] as String,
          'typeoffood': row[4] as String,
          'foodbankstatus': row[5] as String,
          'image_url': row[6] as String,
          'latitude': row[7] as double,
          'longitude': row[8] as double,
        };
      }

    } catch (e) {
      print('Error fetching foodbank details: $e');
    } finally {
      // Ensure the connection is closed
      dbConnection.closeConnection();
    }

    // Return the single foodbank details map
    return foodbankDetails;
  }

}

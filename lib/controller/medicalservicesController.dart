import 'dart:convert';  // Add this import to handle JSON parsing
import 'package:workshop2dev/dbConnection/dbConnection.dart';
import 'dart:typed_data';

class MedicalServices {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<List<Map<String, dynamic>>> fetchNearbyMedicalServices(double userLatitude, double userLongitude) async {
    List<Map<String, dynamic>> nearbyMedical = [];

    try {
      // Connect to the database
      await dbConnection.connectToDatabase();

      // Query to fetch nearby medical services and their operating hours status
      var results = await dbConnection.connection.query('''
        SELECT 
          medical_id, 
          clinic_name, 
          address, 
          contact_no,
          operating_hours,
          service_description,
          latitude,
          longitude,
          imageplace, 
          (6371 * acos(
            cos(radians($userLatitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($userLongitude)) +
            sin(radians($userLatitude)) * sin(radians(latitude))
          )) AS distance,
          CASE
            WHEN (
              SELECT COUNT(*) > 0 
              FROM jsonb_each_text(operating_hours) AS h(day, hours)
              WHERE TRIM(day) = TRIM(to_char(now(), 'Day')) -- Remove padding spaces from both sides
              AND (
                EXISTS (
                  SELECT 1
                  FROM regexp_split_to_table(hours, ',') AS shift
                  WHERE (
                    -- Compare with current time in 24-hour format
                    split_part(shift, '-', 1)::time <= CURRENT_TIME -- Start time (24-hour)
                    AND split_part(shift, '-', 2)::time >= CURRENT_TIME -- End time (24-hour)
                  )
                )
              )
            ) THEN TRUE ELSE FALSE 
          END AS is_open
        FROM medical_services
        ORDER BY distance ASC
      ''');

      // Processing results and adding to nearbyMedical list
      for (var row in results) {
        Map<String, dynamic> operatingHours = {};

        try {
          // Check if operating_hours is a String and decode it to a Map
          if (row[4] is String) {
            operatingHours = jsonDecode(row[4] as String);
          } else if (row[4] is Map) {
            operatingHours = Map<String, dynamic>.from(row[4] as Map); // If it's already a map
          } else {
            operatingHours = {}; // Fallback if it's not a string or map
          }
        } catch (e) {
          print('Error parsing operating hours: $e');
        }

        // Format operating hours into a user-friendly string
        String formattedOperatingHours = formatOperatingHours(operatingHours);

        nearbyMedical.add({
          'id': row[0].toString(),
          'name': row[1] as String,
          'address': row[2] as String,
          'contact_no': row[3] as String, // Adding contact number
          'operating_hours': formattedOperatingHours, // Storing formatted operating_hours as a String
          'service_description': row[5] as String, // Adding service description
          'latitude': row[6] as double,
          'longitude': row[7] as double,
          'imagePlace': row[8] as Uint8List,
          'distance': '${row[9].toStringAsFixed(2)} KM away', // Calculated distance
          'isOpen': row[10] as bool, // Directly cast as bool
        });
      }

    } catch (e) {
      print('Error fetching medical services: $e');
    } finally {
      // Close the database connection
      dbConnection.closeConnection();
    }

    // Return the list of nearby medical services
    return nearbyMedical;
  }

// Helper function to format operating hours into a readable string
  String formatOperatingHours(Map<String, dynamic> operatingHours) {
    List<String> formattedHours = [];
    operatingHours.forEach((day, hours) {
      formattedHours.add('$day: $hours');
    });
    // Join the formatted hours with newline characters instead of commas
    return formattedHours.join('\n');
  }

}

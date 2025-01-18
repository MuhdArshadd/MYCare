import 'dart:convert';  // Add this import to handle JSON parsing
import 'package:workshop2dev/dbConnection/dbConnection.dart';
import 'dart:typed_data';

class MedicalServices {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<List<Map<String, dynamic>>> fetchNearbyMedicalServices(double userLatitude, double userLongitude, String category) async {
    List<Map<String, dynamic>> nearbyMedical = [];

    try {
      // Connect to the database
      await dbConnection.connectToDatabase();

      // Query to fetch nearby medical services and their operating hours status
      var results = await dbConnection.connection.query('''
        SELECT 
        id, 
        clinic_name, 
        address, 
        contact,
        operating_hours,
        service_description,
        latitude,
        longitude,
        image_url, 
        (6371 * acos(
            cos(radians($userLatitude)) * cos(radians(latitude)) * cos(radians(longitude) - radians($userLongitude)) +
            sin(radians($userLatitude)) * sin(radians(latitude))
        )) AS distance,
        CASE
            WHEN (
                SELECT COUNT(*) 
                FROM jsonb_each_text(operating_hours) AS h(day, hours)
                WHERE TRIM(day) = TRIM(to_char((now() AT TIME ZONE 'Asia/Kuala_Lumpur'), 'FMDay')) -- Match current day in the correct timezone
                AND hours IS NOT NULL -- Ensure hours are present
                AND hours != 'Closed' -- Exclude closed days
                AND EXISTS (
                    SELECT 1
                    FROM regexp_split_to_table(hours, ',') AS shift
                    WHERE (
                        -- Extract start and end times, handle midnight shifts correctly
                        trim(split_part(shift, '-', 1))::time <= (now() AT TIME ZONE 'Asia/Kuala_Lumpur')::time
                        AND trim(split_part(shift, '-', 2))::time >= (now() AT TIME ZONE 'Asia/Kuala_Lumpur')::time
                    )
                )
            ) > 0 THEN TRUE ELSE FALSE 
        END AS is_open
    FROM clinics_services
    WHERE clinic_category = '$category' -- Filter by category if needed
    ORDER BY distance ASC;
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

        // Process service_description as an array of strings
        List<String> serviceDescriptionList = List<String>.from(row[5] as List); // Assuming it's a list of strings
        String formattedServiceDescription = serviceDescriptionList.join(', '); // Join array into a string if needed

        nearbyMedical.add({
          'id': row[0].toString(),
          'clinic_name': row[1] as String,
          'address': row[2] as String,
          'contact': row[3] as String, // Adding contact number
          'operating_hours': formattedOperatingHours, // Storing formatted operating_hours as a String
          'service_description': formattedServiceDescription, // Store the formatted service descriptions as a string
          'latitude': row[6] as double,
          'longitude': row[7] as double,
          'image_url': row[8] as String,
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

import 'dart:typed_data';
import 'package:workshop2dev/dbConnection/dbConnection.dart';
import 'dart:convert';
import '../model/userModel.dart';

class Skills {
  final DatabaseConnection dbConnection = DatabaseConnection();

  // Updated fetchSkills to accept User model
  Future<List<Map<String, dynamic>>> fetchSkills(String category, User user) async {
    List<Map<String, dynamic>> skills = [];

    try {
      await dbConnection.connectToDatabase();

      // SQL Query to fetch and filter skills based on User model criteria
      var results = await dbConnection.connection.query('''
        SELECT 
            s.skills_ID,
            s.skillsName,
            s.skillsOrganizer,
            s.skillVenueAddress,
            s.startDate,
            s.endDate,
            s.skillsCriteria,
            s.imageCompany,
            CASE 
                WHEN 
                    CAST(s.skillsCriteria->>'minAge' AS INT) <= @age
                    AND CAST(s.skillsCriteria->>'maxAge' AS INT) >= @age
                    AND s.skillsCriteria->>'userCategory' LIKE '%' || @userCategory || '%'
                    AND s.skillsCriteria->>'incomeRange' LIKE '%' || @incomeRange || '%'
                THEN 'Available'
                ELSE 'Not Available'
            END AS availability
        FROM 
            SKILLS s
        WHERE 
            s.skillsCategory = @category
            AND s.startDate <= CURRENT_DATE
            AND s.endDate >= CURRENT_DATE;
      ''', substitutionValues: {
        'category': category,
        'age': user.age.toString(), // Use age from User model
        'userCategory': user.userCategory, // User category
        'incomeRange': user.incomeRange // Income range
      });

      // Process results
      for (var row in results) {
        skills.add({
          'id': row[0].toString(),
          'name': row[1] as String,
          'organizer': row[2] as String,
          'venue': row[3] as String,
          'startDate': row[4].toString(),
          'endDate': row[5].toString(),
          'criteria': row[6] as Map<String, dynamic>, // FIX: No decoding required
          'availability': row[8] as String, // 'Available' or 'Not Available'
          'imageCompany': row[7] as Uint8List,
        });
      }

      print(skills); // Debugging output
    } catch (e) {
      print('Error fetching skills: $e'); // Error handling
    } finally {
      dbConnection.closeConnection();
    }

    return skills; // Return processed skills data
  }
}

import 'dart:convert';
import 'package:workshop2dev/dbConnection/dbConnection.dart';

class SkillsController {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<List<Map<String, dynamic>>> fetchSkills(String learningType, String category) async {
    List<Map<String, dynamic>> skills = [];

    try {
      await dbConnection.connectToDatabase();

      // SQL Query to fetch and filter skills based on User model criteria
      var results = await dbConnection.connection.query('''
      SELECT
        skills_id,
        skillsname,
        sourceslink,
        image,
        skillseducator,
        skillvenueaddress,
        skillsorganizer,
        skillscriteria,
        skilllevel,
        skillduration
      FROM skills_building
      WHERE skillstype = @learning_type
        AND skillscategory = @category
      ''', substitutionValues: {
        'learning_type': learningType,  // Dynamically passed learning type (e.g., 'Online')
        'category': category,          // Dynamically passed category (e.g., 'Business')
      });

      // Process results
      for (var row in results) {
        List<String> criteria = [];

        try {
          // Decode the JSONB field (row[7]) if it's not null or empty
          var criteriaJson = row[7];
          if (criteriaJson is String && criteriaJson.isNotEmpty) {
            dynamic decodedJson = jsonDecode(criteriaJson);

            // If it's a list, assign it to criteria
            if (decodedJson is List) {
              criteria = List<String>.from(decodedJson);
            }
          } else if (criteriaJson is List) {
            criteria = List<String>.from(criteriaJson);
          }
        } catch (e) {
          print('Error decoding criteria JSON: $e');
        }

        // Format criteria into a numbered list
        String formattedCriteria = criteria.asMap().entries.map((entry) {
          int index = entry.key + 1;
          String value = entry.value;
          return "$index. $value";
        }).join('\n');

        // Add the processed skill to the skills list
        skills.add({
          'id': row[0].toString(),
          'name': row[1] as String,
          'link': row[2] as String,
          'image': row[3] as String,
          'educator': row[4] as String,
          'venue': row[5] as String,
          'organizer': row[6] as String,
          'criteria': formattedCriteria, // Numbered list of criteria
          'level': row[8] as String,
          'duration': row[9] as String,
        });

        print(skills);
      }

    } catch (e) {
      print('Error fetching skills: $e');
    } finally {
      dbConnection.closeConnection();
    }

    return skills; // Return processed skills data
  }

  Future<List<Map<String, dynamic>>> fetchSkillsOnline() async {
    List<Map<String, dynamic>> skillsOnline = [];

    try {
      await dbConnection.connectToDatabase();

      // SQL Query to fetch and filter skills based on User model criteria
      var results = await dbConnection.connection.query('''
       SELECT
          skills_id,
          skillsname,
          sourceslink,
          image,
          skillseducator,
          skillvenueaddress,
          skillsorganizer,
          skillscriteria,
          skilllevel,
          skillduration
        FROM skills_building
        WHERE skillstype = 'Online'
      ''');         // Dynamically passed category (e.g., 'Business')


      // Process results
      for (var row in results) {
        List<String> criteria = [];

        try {
          // Decode the JSONB field (row[7]) if it's not null or empty
          var criteriaJson = row[7];
          if (criteriaJson is String && criteriaJson.isNotEmpty) {
            dynamic decodedJson = jsonDecode(criteriaJson);

            // If it's a list, assign it to criteria
            if (decodedJson is List) {
              criteria = List<String>.from(decodedJson);
            }
          } else if (criteriaJson is List) {
            criteria = List<String>.from(criteriaJson);
          }
        } catch (e) {
          print('Error decoding criteria JSON: $e');
        }

        // Format criteria into a numbered list
        String formattedCriteria = criteria.asMap().entries.map((entry) {
          int index = entry.key + 1;
          String value = entry.value;
          return "$index. $value";
        }).join('\n');

        // Add the processed skill to the skills list
        skillsOnline.add({
          'id': row[0].toString(),
          'name': row[1] as String,
          'link': row[2] as String,
          'image': row[3] as String,
          'educator': row[4] as String,
          'venue': row[5] as String,
          'organizer': row[6] as String,
          'criteria': formattedCriteria, // Numbered list of criteria
          'level': row[8] as String,
          'duration': row[9] as String,
        });

        print(skillsOnline);
      }

    } catch (e) {
      print('Error fetching skills: $e');
    } finally {
      dbConnection.closeConnection();
    }

    return skillsOnline; // Return processed skills data
  }
}

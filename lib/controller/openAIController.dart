import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dbConnection/dbConnection.dart';

class OpenAIService {
  final DatabaseConnection databaseConnection = DatabaseConnection();

  OpenAIService() {
    // Initialize the database connection
    databaseConnection.connectToDatabase().then((_) {
      print('Database connected');
    }).catchError((e) {
      print('Error connecting to database: $e');
    });
  }

  // Function to process user query and interact with OpenAI
  Future<String> processUserQuery(String userQuery) async {
    String openaiApiKey = openAIkey; // Replace with your OpenAI API key
    String skillstype = "Online"; // Default skill type

    // Fetch courses related to the skill type
    List<Map<String, dynamic>> coursesList = await extract_online_courses_from_database(skillstype);

    if (coursesList.isEmpty) {
      return "No courses found for the specified skill type.";
    }

    // Format courses for the prompt
    String formattedCourses = coursesList.map((course) {
      return "${course['skillsname']}";
    }).join("\n");

    // Create prompt for OpenAI
    String prompt = '''
      The following are a list of online courses to learn:
      $formattedCourses

      Please rank and summarize the benefits of the courses for users in the area of developing their market value for a job. Give the answer in short sentences.
    ''';

    // Send the prompt to OpenAI API
    try {
      final response = await openaiChatCompletion(openaiApiKey, prompt);
      return response;
    } catch (e) {
      print("Error during OpenAI API call: $e");
      return "Failed to generate a summary";
    }
  }

  // Function to connect to the Azure PostgreSQL database
  Future<List<Map<String, dynamic>>> extract_online_courses_from_database(String skillstype) async {
    // Wait for database connection initialization
    await databaseConnection.connectToDatabase();
    var connection = databaseConnection.connection;

    try {
      // Using LIKE for partial matching with skillstype
      final result = await connection.query(
          "SELECT skillsname FROM skills_building WHERE skillstype LIKE @skillstype LIMIT 6",
          substitutionValues: {"skillstype": "%$skillstype%"}  // Ensure skillstype is used with LIKE
      );

      List<Map<String, dynamic>> courses = result.map((row) {
        return {
          "skillsname": row[0]
        };
      }).toList();

      return courses;
    } catch (e) {
      print("Error fetching data from database: $e");
      return [];
    }
  }

  // Function to interact with OpenAI API (chat completion)
  Future<String> openaiChatCompletion(String apiKey, String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = json.encode({
      'model': 'gpt-4o-mini', // Replace with your model choice
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant for an application. All the information are retrieved from the database and related to the application.'
        },
        {
          'role': 'user',
          'content': prompt
        }
      ],
      'functions': [
        {
          'name': 'extract_online_courses_from_database',
          'description': 'Retrieve a list of courses that the learning method is online',
          'parameters': {
            'type': 'object',
            'properties': {
              'learningType': {
                'type': 'string',
                'description': 'The skill\'s learning type the user seeks to learn'
              }
            },
            'required': ['learningType']
          }
        }
      ],
      'function_call': 'auto',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Response status code: ${response
          .statusCode}'); // Log status code for debugging
      print('Response body: ${response.body}'); // Log response body

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Check for valid choices in the response
        if (responseData['choices'] != null &&
            responseData['choices'].isNotEmpty) {
          return responseData['choices'][0]['message']['content'] ??
              "No content available from OpenAI response";
        } else {
          return "No valid response from OpenAI";
        }
      } else {
        return "Failed to get a valid response from OpenAI API";
      }
    } catch (e) {
      print("Error during OpenAI API call: $e");
      return "Failed to generate a summary"; // Ensure a valid string is returned
    }
  }
}
import 'dart:convert';
import 'dart:io';
import '../dbConnection/dbConnection.dart';
import 'package:http/http.dart' as http;


class OpenAIService {
  final DatabaseConnection databaseConnection = DatabaseConnection();
  String openaiApiKey = openAIkey;
  Map<String, Map<String, Map<String, String>>> tablesInfo = {
    // Skills Building Table
    "skills_building": {
      "skillstype": {"description": "The mode of delivery for the skill (Online or Physical only)"},
      "skillscategory": {"description": "The domain or area of the skill (e.g., Business, Computer Science, Personal Development)"},
      "skillsname": {"description": "The specific name of the skill or course (e.g., Python, Data Science, Project Management)"},
      "sourceslink": {"description": "The URL or link to the source or website offering the course"},
      "skillseducator": {"description": "The instructor, platform, or organization delivering the course (e.g., Udemy, Coursera)"},
      "skillvenueaddress": {"description": "The physical location or address where the course is conducted, if applicable"},
      "skillsorganizer": {"description": "The organization or entity responsible for organizing the course (Coursera and FMSDC only)"},
      "skillscriteria": {"description": "The prerequisites or qualifications required to enroll in the course (e.g., basic programming knowledge)"},
      "skilllevel": {"description": "The complexity or difficulty level of the course (e.g., Beginner, Intermediate, Advanced)"},
      "skillduration": {"description": "The total duration of the course or program (e.g., 3 months, 1 year)"},
    },
    // News Table
    "news": {
      "title": {"description": "The headline or title of the news article"},
      "author": {"description": "The person or entity that authored the news article"},
      "description": {"description": "A brief summary or overview of the news content"},
      "date": {"description": "The publication date of the news article"},
      "type": {"description": "The category or genre of the news article (e.g., Politics, Technology, Sports)"},
    },
    // Clinic Services Table
    "clinics_services": {
      "clinic_category": {"description": "The type or category of the clinic (NGO and Government only)"},
      "clinic_name": {"description": "The name of the clinic service provider"},
      "address": {"description": "The physical location or address of the clinic"},
      "service_description": {"description": "Details about the services offered by the clinic"},
      "contact": {"description": "The contact number of the clinic for inquiries or appointments"},
      "operating_hours": {"description": "The operating hours of the clinic for each day of the week, with timings in 24 hours format specified for each day (e.g., Monday: 08:00 - 21:30, Sunday: Closed)"},
    },
    // Foodbank Table
    "foodbanks_new": {
      "foodbankname": {"description": "The name of the foodbank"},
      "address": {"description": "The physical address of the foodbank"},
      "contactno": {"description": "The contact number for the foodbank for inquiries"},
      "typeoffood": {"description": "The types of food items offered by the foodbank"},
      "foodbankstatus": {"description": "The current operational status of the foodbank (e.g., Aktif, Tidak Aktif)"},
    },
  };


  // Main conversation logic
  Future<String> runConversation(String content) async {
    // Define the tools
    final List<Map<String, dynamic>> tools = [
      {
        "name": "handle_general_question",
        "description":
        "Answer general questions about the app, such as its purpose, features, or how it works.",
        "parameters": {
          "type": "object",
          "properties": {
            "content": {
              "type": "string",
              "description": "The user's question."
            }
          },
          "required": ["content"]
        }
      },
      {
        "name": "handle_data_question",
        "description":
        "Retrieve relevant data from the app's database in response to user queries. This function is specifically for questions that require fetching structured information stored in the database, such as skill-building courses, clinic services, foodbanks, or news. Use this function when the question involves specific topics or needs up-to-date, factual information from the app.",
        "parameters": {
          "type": "object",
          "properties": {
            "content": {
              "type": "string",
              "description":
              "The user's question that requires database retrieval for structured and relevant information."
            }
          },
          "required": ["content"]
        }
      }
    ];

    // Prepare the request payload for OpenAI API
    final Map<String, dynamic> payload = {
      'model': 'ft:gpt-4o-mini-2024-07-18:personal:intromycare:Akp8wm4b',
      "messages": [
        {"role": "user", "content": content}
      ],
      "functions": tools,
      "function_call": "auto"
    };

    try {
      // Send the API request
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $openaiApiKey',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final responseMessage = responseData['choices'][0]['message'];

        // Check if a function was called
        if (responseMessage.containsKey('function_call')) {
          final String functionName = responseMessage['function_call']['name'];
          final Map<String, dynamic> functionArguments = jsonDecode(responseMessage['function_call']['arguments']);

          // Debugging: Print function name and arguments
          print('Function called: $functionName');
          print('Function arguments: ${jsonEncode(functionArguments, toEncodable: (e) => e.toString())}');

          // Map functions to their implementations
          final Map<String, Function> availableFunctions = {
            "handle_general_question": handleGeneralQuestion,
            "handle_data_question": handleDataQuestion,
          };

          // Call the selected function if available
          if (availableFunctions.containsKey(functionName)) {
            return availableFunctions[functionName]!(functionArguments['content']);
          }
        }

        // Default response if no function call
        return "Sorry, I couldn't understand your request. Please try rephrasing.";
      } else {
        // Handle HTTP errors
        return "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      // Handle network or other errors
      return "An error occurred: $e";
    }
  }

  // Function to handle general questions
  Future<String> handleGeneralQuestion(String content) async {
    String prompt = """
    The user asked: "$content"
    You are a helpful assistant. Please provide a concise and accurate response about this app.
    """;

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $openaiApiKey',
      },
      body: json.encode({
        'model': 'ft:gpt-4o-mini-2024-07-18:personal:intromycare:Akp8wm4b',
        'messages': [{'role': 'system', 'content': prompt}],
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['choices'][0]['message']['content'];
    } else {
      return 'Error in fetching response from OpenAI.';
    }
  }

  // Function to handle database-related questions
  Future<String> handleDataQuestion(String content) async {
    String prompt = """
    You are given a list of tables in a database. Your task is to convert the user's question into an SQL query to fetch the relevant data from the database.
    
    Tables and their attributes from the database:
    ${json.encode(tablesInfo)}
    
    User's question: "$content"
    
    Please return only the SQL query in plain text, without any Markdown formatting or additional explanation. The query should be written specifically for Azure PostgreSQL, ensuring compatibility with its syntax.
    
    - If the user's question involves operation hours or date, generate a query that retrieves all relevant data from the table without using WHERE clauses. This approach allows for analyzing the data programmatically, ensuring accuracy when the data is dynamic or frequently changing.
    
    - For other types of questions, include appropriate WHERE clauses to filter the data as per the user's request, ensuring the conditions are relevant and accurate.
    
    Limit the results to a maximum of 2 entries, unless the nature of the question specifically requires a broader dataset.
    """;


    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $openaiApiKey',
      },
      body: json.encode({
        'model': 'ft:gpt-4o-mini-2024-07-18:personal:intromycare:Akp8wm4b',
        'messages': [{'role': 'system', 'content': prompt}],
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String sqlQuery = responseBody['choices'][0]['message']['content'].trim();
      print('SQL query: $sqlQuery');

      // Fetch data based on the generated SQL query
      List<List> data = await fetchData(sqlQuery);

      String finalPrompt = """
      You are a chatbot for a mobile app designed to provide users with information from its database. 
      The following data has been retrieved from the app's database: $data

      Using ONLY this data, respond conversationally to the user's request. Summarize and describe the most relevant information in a friendly and engaging manner. Do not add any information that is not present in the provided data. Respond in very short sentences.
      """;


      // Get final response from OpenAI using the database data
      final finalResponse = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $openaiApiKey',
        },
        body: json.encode({
          'model': 'ft:gpt-4o-mini-2024-07-18:personal:intromycare:Akp8wm4b',
          'messages': [{'role': 'user', 'content': finalPrompt}],
        }),
      );

      if (finalResponse.statusCode == 200) {
        final finalResponseBody = json.decode(finalResponse.body);
        return finalResponseBody['choices'][0]['message']['content'];
      } else {
        return 'Error in final response.';
      }
    } else {
      return 'Error in generating SQL query.';
    }
  }

// Function to fetch data from the database
  Future<List<List<dynamic>>> fetchData(String query) async {
    try {
      // Ensure the database connection is open
      await databaseConnection.connectToDatabase();

      // Execute the query and fetch the results
      var results = await databaseConnection.connection.query(query);

      // Return the raw data (list of rows as lists)
      return results.toList();
    } catch (e) {
      // Handle error, you can either return an empty list or rethrow the error
      print("Error fetching data: $e");
      return [];
    }
  }

}

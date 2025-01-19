import 'dart:convert';
import 'dart:io';
import '../dbConnection/dbConnection.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



class OpenAIService {
  final DatabaseConnection databaseConnection = DatabaseConnection();
  String openaiApiKey = openAIkey;
  Map<String, Map<String, Map<String, String>>> tablesInfo = {
    // Skills Building Table
    "skills_building": {
      "skillstype": {"description": "The mode of delivery for the skill (Online or Physical only)"},
      "skillscategory": {"description": "The domain or area of the skill, where for Online mode are Business, Computer Science, Personal Development, Information Technology only. While Physical mode are skill, SPEED, and information technology only.)"},
      "skillsname": {"description": "The specific name of the skill or course (e.g., Python, Data Science, Project Management)"},
      "sourceslink": {"description": "The URL or link to the source or website offering the course"},
      "skillseducator": {"description": "The instructor, platform, or organization delivering the course (e.g., Udemy, Coursera)"},
      "skillvenueaddress": {"description": "The physical location or address where the course is conducted, if applicable"},
      "skillsorganizer": {"description": "The organization or entity responsible for organizing the course (Coursera and FMSDC only)"},
      "skillscriteria": {"description": "The prerequisites or qualifications required to enroll in the course (e.g., basic programming knowledge)"},
      "skilllevel": {"description": "The complexity or difficulty level of the course (Online mode only have Beginner level, while Physical mode only have Professional level)"},
      "skillduration": {"description": "The total duration of the course or program (e.g., 3 months, 1 year)"},
    },
    // News Table
    "news": {
      "title": {"description": "The headline or title of the news article"},
      "author": {"description": "The person or entity that authored the news article"},
      "description": {"description": "A brief summary or overview of the news content"},
      "date": {"description": "The date and time the news article was published, expressed in Malaysian time zone (e.g., 18/10/2024 18:20 MYT)."},
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
      "foodbankstatus": {"description": "Indicates whether the foodbank is currently operational, with possible values: 'Aktif' (Active) or 'Tidak Aktif' (Inactive) only."}
    },
  };


  // Main conversation logic
  Future<String> runConversation(String content) async {
    // Define the tools
    final List<Map<String, dynamic>> tools = [
      {
        "name": "handle_general_question",
        "description":
        "Handle general conversational questions and interactions about the app. This includes: Greetings (e.g., 'Hello!', 'Thank you!'). Questions about the app's purpose, features (non-data specific), or functionality. Do not use this function for questions requiring database retrieval or factual, structured information",
        "parameters": {
          "type": "object",
          "properties": {
            "content": {
              "type": "string",
              "description": "The user's question or interaction."
            }
          },
          "required": ["content"]
        }
      },
      {
        "name": "handle_data_question",
        "description":
        "Retrieve specific, factual data from the app's database. Use this function ONLY for questions that: Mention specific topics like skill-building courses, clinic, foodbanks, or news. Require up-to-date, structured information stored in the app's database. Do not use this function for general conversational inquiries or questions unrelated to database content.",
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

    // System prompt to guide function usage
    const String systemPrompt = """
    You are a chatbot for the MYCare mobile app, designed to provide structured information about clinics, skill-building, foodbanks, and news.
    
    Follow these rules:
    1. Use the 'handle_general_question' function for general app-related queries, greetings, or casual interactions about the app's purpose and features.
    2. Use the 'handle_data_question' function ONLY for database-related queries requiring factual or structured information (e.g., clinics, skill-building programs, foodbanks, or news).
    3. Ensure the user's question aligns with the function arguments before calling the function.
    4. If the question is ambiguous or doesn't clearly match a function, prioritize user clarity over function calls, and ask for clarification if needed.
    5. Do not mix up function names or arguments. Be strict in differentiating between general and database-specific queries.
    """;


    // Prepare the request payload for OpenAI API
    final Map<String, dynamic> payload = {

      'model': 'ft:gpt-4o-mini-2024-07-18:personal:intromycare:Akp8wm4b',
      "messages": [
        {"role": "system", "content": systemPrompt},
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
        return "I'm sorry, I can only assist with questions related to the app's features and functionalities only.";

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
    You are a helpful assistant specifically designed to answer questions about this MYCare app.
    - If the question is related to the app, provide a concise and accurate response specific to the app.
        
    The user asked: "$content"
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
    
    - If the user's question involves operation hours or date (especially related to news or clinic), generate a query that retrieves all relevant data from the table where the values are not null only. This approach ensures the data is fetched for further analysis, leaving it up you to analyze and interpret the dynamic or frequently changing data.
    
    - For other types of questions, include appropriate WHERE clauses to filter the data based on the user's request, ensuring that the conditions are relevant and accurate.
    
    - Always limit the results to a maximum of 8 entries to avoid excessive token consumption.
    
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

      // Fetching the current date and time
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);


      String finalPrompt = """
      You are a chatbot for a MYCare mobile app designed to provide users with information from its database. 
      
      The following data has been retrieved from the app's database: $data
      
      User's current date and time: $formattedDateTime
      User's question: "$content"

      Using ONLY this data, respond conversationally to the user's question. Summarize and describe the most relevant information in a friendly and engaging manner. You may use bullet points to respond in a more structured manner. Do not add any information that is not present in the provided data. Respond in very short sentences.
      
      If the data is empty, respond with something like:
      - "Please check for updates!"
      - "We're sorry, no information available at the moment. Please try again later."
      - "We’re still waiting for the latest data to be updated."

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

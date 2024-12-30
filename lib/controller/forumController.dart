import 'package:postgres/src/execution_context.dart';
import 'package:workshop2dev/dbConnection/dbConnection.dart';
import 'dart:convert';
import 'dart:typed_data';

class ForumController {
  final DatabaseConnection dbConnection = DatabaseConnection();

  Future<List<Map<String, dynamic>>> fetchFeeds(String selection) async {
    // Initialize an empty list to store the fetched feeds
    List<Map<String, dynamic>> feeds = [];

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      String query;

      // Determine the query based on the selection criteria
      if (selection == "latest") {
        query = '''
        SELECT 
          f.feedforum_ID, 
          f.caption, 
          f.creation_dateTime, 
          f.total_like, 
          f.total_dislike, 
          u.fullname, 
          f.images,
          COALESCE(c.total_comments, 0) AS total_comments
        FROM FEED_FORUM f
        JOIN USERS u ON f.user_ic = u.user_ic
        LEFT JOIN (
          SELECT feedforum_ID, COUNT(*) AS total_comments
          FROM FEED_COMMENT
          GROUP BY feedforum_ID
        ) c ON f.feedforum_ID = c.feedforum_ID
        ORDER BY f.creation_dateTime DESC
        LIMIT 10
      ''';
      } else if (selection == "trending") {
        query = '''
        SELECT 
          f.feedforum_ID, 
          f.caption, 
          f.creation_dateTime, 
          f.total_like, 
          f.total_dislike, 
          u.fullname, 
          f.images,
          COALESCE(c.total_comments, 0) AS total_comments
        FROM FEED_FORUM f
        JOIN USERS u ON f.user_ic = u.user_ic
        LEFT JOIN (
          SELECT feedforum_ID, COUNT(*) AS total_comments
          FROM FEED_COMMENT
          GROUP BY feedforum_ID
        ) c ON f.feedforum_ID = c.feedforum_ID
        ORDER BY f.total_like DESC, f.total_dislike ASC
        LIMIT 10
      ''';
      } else if (selection == "popular this week") {
        query = '''
        SELECT 
          f.feedforum_ID, 
          f.caption, 
          f.creation_dateTime, 
          f.total_like, 
          f.total_dislike, 
          u.fullname, 
          f.images,
          COALESCE(c.total_comments, 0) AS total_comments
        FROM FEED_FORUM f
        JOIN USERS u ON f.user_ic = u.user_ic
        LEFT JOIN (
          SELECT feedforum_ID, COUNT(*) AS total_comments
          FROM FEED_COMMENT
          GROUP BY feedforum_ID
        ) c ON f.feedforum_ID = c.feedforum_ID
        WHERE f.creation_dateTime >= CURRENT_DATE - INTERVAL '7 days'
        ORDER BY f.total_like DESC
        LIMIT 10
      ''';
      } else {
        return []; // Return empty list if the selection is invalid
      }

      // Execute the query and process the results
      var results = await dbConnection.connection.query(query);

      for (var row in results) {
        feeds.add({
          'feedforum_ID': row[0].toString(), // Integer to string conversion
          'caption': row[1] as String,
          'creation_dateTime': row[2].toString(),
          'total_like': row[3] as int,
          'total_dislike': row[4] as int,
          'user_name': row[5] as String,
          'images': row[6] != null ? row[6] as Uint8List : Uint8List(0),
          'total_comments': row[7] as int, // Total number of comments
        });
      }
    } catch (e) {
      print('Error fetching feeds: $e');
    } finally {
      // Ensure the database connection is closed
      dbConnection.closeConnection();
    }

    // Return the fetched feeds
    return feeds;
  }

  Future<List<Map<String, dynamic>>> fetchFeedComments(String feedForumID) async {
    // Initialize an empty list to store the fetched feed comments
    List<Map<String, dynamic>> feedComments = [];

    try {
      // Ensure the database connection is open
      await dbConnection.connectToDatabase();

      // Define the SQL query
      String query = '''
    SELECT 
        fc.comment,
        fc.comment_dateTime,
        u.fullname AS comment_author
    FROM 
        FEED_FORUM ff
    LEFT JOIN 
        FEED_COMMENT fc
    ON 
        ff.feedforum_ID = fc.feedforum_ID
    LEFT JOIN 
        USERS u
    ON 
        fc.user_IC = u.user_IC
    WHERE 
        ff.feedforum_ID = @feedForumID
    ORDER BY 
        fc.comment_ID ASC;
    ''';

      // Execute the query and pass parameters
      var results = await dbConnection.connection.query(query, substitutionValues: {
        'feedForumID': feedForumID, // Bind the feedForumID parameter
      });

      // Process the results
      for (var row in results) {
        feedComments.add({
          'comment': row[0] as String,
          'comment_dateTime': row[1].toString(),
          'comment_author': row[2] as String,
        });
      }
    } catch (e) {
      print('Error fetching feed comments: $e');
    } finally {
      // Ensure the database connection is closed
      dbConnection.closeConnection();
    }

    // Return the fetched feed comments
    return feedComments;
  }



  Future<String> postFeed(String noIc, String caption, Uint8List? imageBytes) async {
    await dbConnection.connectToDatabase();

    try {
      if (imageBytes != null) {
        // Convert image bytes to base64 string
        final base64Image = base64Encode(imageBytes);

        // Perform the insert operation with image
        await dbConnection.connection.query(
          '''
        INSERT INTO FEED_FORUM (caption, images, user_ic, creation_dateTime) 
        VALUES (@caption, decode(@images, 'base64'), @user_ic, CURRENT_TIMESTAMP)
        ''',
          substitutionValues: {
            'caption': caption,
            'images': base64Image, // Base64 encoded image
            'user_ic': noIc,       // User's identification code
          },
        );
      } else {
        // Perform the insert operation without image
        await dbConnection.connection.query(
          '''
        INSERT INTO FEED_FORUM (caption, user_ic, creation_dateTime) 
        VALUES (@caption, @user_ic, CURRENT_TIMESTAMP)
        ''',
          substitutionValues: {
            'caption': caption,
            'user_ic': noIc,       // User's identification code
          },
        );
      }

      return "Post successful";
    } catch (e) {
      // Catch any exceptions and return the error message
      return "Error posting: $e";
    } finally {
      // Close the database connection after the operation
      dbConnection.closeConnection();
    }
  }


  Future<String> updateFeedLikes(int selection, String feedforumID, String userID) async {
    await dbConnection.connectToDatabase();

    try {
      // Step 1: Retrieve current user_interactions as TEXT, total_like, and total_dislike
      final result = await dbConnection.connection.query(
        '''
      SELECT user_interactions::TEXT, total_like, total_dislike
      FROM FEED_FORUM
      WHERE feedforum_ID = @feedforumID
      ''',
        substitutionValues: {'feedforumID': feedforumID},
      );

      if (result.isEmpty) {
        return "Feed not found.";
      }

      final row = result[0];
      final userInteractionsJson = row[0]?.toString() ?? '{}'; // Ensure it's treated as a string
      final currentLikes = row[1] as int;
      final currentDislikes = row[2] as int;

      // Debugging: Print retrieved data
      print('Retrieved user_interactions JSON: $userInteractionsJson');
      print('Current Likes: $currentLikes, Current Dislikes: $currentDislikes');

      Map<String, dynamic> currentInteractions;
      try {
        currentInteractions = jsonDecode(userInteractionsJson) as Map<String, dynamic>;
        print('Decoded currentInteractions: $currentInteractions');
      } catch (e) {
        print('Error decoding JSON: $e');
        return "Error decoding user interactions JSON.";
      }

      // Step 2: Determine user's current action
      final currentAction = currentInteractions[userID] ?? 0;
      print('User action: $currentAction (selection: $selection)');

      // Step 3: Update likes/dislikes and user_interactions
      String updateQuery = '';
      Map<String, dynamic> substitutionValues = {'feedforumID': feedforumID};
      if (currentAction == selection) {
        // Toggle off (remove the user's action)
        currentInteractions.remove(userID);
        print('Toggled off: Updated interactions: $currentInteractions');

        if (selection == 1) {
          updateQuery = '''
        UPDATE FEED_FORUM
        SET total_like = total_like - 1,
            user_interactions = @userInteractions
        WHERE feedforum_ID = @feedforumID
        ''';
        } else if (selection == 2) {
          updateQuery = '''
        UPDATE FEED_FORUM
        SET total_dislike = total_dislike - 1,
            user_interactions = @userInteractions
        WHERE feedforum_ID = @feedforumID
        ''';
        }
      } else {
        // Add or switch the user's action
        currentInteractions[userID] = selection;
        print('Added/Switched action: Updated interactions: $currentInteractions');

        if (currentAction == 1) {
          updateQuery = '''
        UPDATE FEED_FORUM
        SET total_like = total_like - 1,
            total_dislike = total_dislike + 1,
            user_interactions = @userInteractions
        WHERE feedforum_ID = @feedforumID
        ''';
        } else if (currentAction == 2) {
          updateQuery = '''
        UPDATE FEED_FORUM
        SET total_like = total_like + 1,
            total_dislike = total_dislike - 1,
            user_interactions = @userInteractions
        WHERE feedforum_ID = @feedforumID
        ''';
        } else {
          // New action
          if (selection == 1) {
            updateQuery = '''
          UPDATE FEED_FORUM
          SET total_like = total_like + 1,
              user_interactions = @userInteractions
          WHERE feedforum_ID = @feedforumID
          ''';
          } else if (selection == 2) {
            updateQuery = '''
          UPDATE FEED_FORUM
          SET total_dislike = total_dislike + 1,
              user_interactions = @userInteractions
          WHERE feedforum_ID = @feedforumID
          ''';
          }
        }
      }

      // Debugging: Print the final update query and values
      print('Update Query: $updateQuery');
      print('Substitution Values: $substitutionValues');

      // Step 5: Perform the update
      await dbConnection.connection.query(
        updateQuery,
        substitutionValues: {
          'feedforumID': feedforumID,
          'userInteractions': jsonEncode(currentInteractions),
        },
      );

      return "Update likes/dislikes successful.";
    } catch (e) {
      print('Error: $e');
      return "Error updating likes/dislikes: $e";
    } finally {
      dbConnection.closeConnection();
    }
  }

  Future<String> deleteFeed(String feedforumID, String noIC) async {
    await dbConnection.connectToDatabase();

    try {
      // Query to delete the feed, ensuring the user is the one who created the feed (user_ic)
      String query = '''
      DELETE FROM FEED_FORUM
      WHERE feedforum_ID = @feedforumID AND user_ic = @user_ic
    ''';

      // Perform the delete operation
      var result = await dbConnection.connection.query(
        query,
        substitutionValues: {
          'feedforumID': feedforumID, // The feed's ID to delete
          'user_ic': noIC,            // The user's IC to verify they created the feed
        },
      );

      // Check if the delete was successful (affected rows > 0)
      if (result.affectedRows > 0) {
        return "Feed deleted successfully";
      } else {
        return "Feed not found or you are not authorized to delete this feed";
      }
    } catch (e) {
      // Catch any exceptions and return the error message
      return "Error deleting feed: $e";
    } finally {
      // Close the database connection after the operation
      dbConnection.closeConnection();
    }
  }

  Future<String> commentFeed(String feedforumID, String noIC, String comment) async {
    await dbConnection.connectToDatabase();

    try {
      // Query to insert the comment into the COMMENTS table
      String query = '''
      INSERT INTO FEED_COMMENT (feedforum_id, user_ic, comment, comment_dateTime)
      VALUES (@feedforumID, @user_ic, @comment, CURRENT_TIMESTAMP)
    ''';

      // Perform the insert operation
      await dbConnection.connection.query(
        query,
        substitutionValues: {
          'feedforumID': feedforumID, // The feed's ID to link the comment
          'user_ic': noIC,            // The user's IC who is commenting
          'comment': comment,         // The comment content
        },
      );
      return "Comment posted successfully";
    } catch (e) {
      // Catch any exceptions and return the error message
      return "Error posting comment: $e";
    } finally {
      // Close the database connection after the operation
      dbConnection.closeConnection();
    }
  }

}

extension on PostgreSQLResult {
  get affectedRows => null;
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  // static const String baseUrl = 'https://edpal.online/edpal.admin/public/api';
  static const String baseUrl =
      'https://theprimoapp.com/EdPalMusicApp/public/api';

  /// API Paths
  static const String register = "$baseUrl/new_register";
  static const String login = "$baseUrl/login";
  static const String socialLogin = "$baseUrl/social_login";
  static const String editPofile = "$baseUrl/edit-profile";
  static const String allCategory = "$baseUrl/allCategory";
  static const String addPlayList = "$baseUrl/addPlayList";
  static const String myPlayList = "$baseUrl/myPlayList";
  static const String addSongInList = "$baseUrl/addSongInList";
  static const String addSongList = "$baseUrl/allSongsList";
  static const String playlistSongs = "$baseUrl/songInPlayList";
  static const String removeSongPlaylist = "$baseUrl/remove_songplaylist";
  static const String addDownloadSong = "$baseUrl/download_song";
  static const String downloadSongList = "$baseUrl/download_songlist";
  static const String likeUnlikedSongs = "$baseUrl/likeUnlikeSong";
  static const String addQueueSongs = "$baseUrl/add_queue_songs";
  static const String queueSongList = "$baseUrl/queue_songlist";
  static const String favoriteSongList = "$baseUrl/like_songlist";
  static const String addRecentlySong = "$baseUrl/add_recentlysong";
  static const String recentSongList = "$baseUrl/recently_songlist";
  static const String queueSongListWithoutPlaylist = "$baseUrl/queue_songlist_without_playlist";



  // API Paths with no auth
  static const String noAuthAddSongList = "$baseUrl/noauthallSongsList";

    Future<Map<String, dynamic>> fetchHomeCategoryData(String endpoint) async {
        // Future.delayed(const Duration(seconds: 5));
      try {
        final prefs = await SharedPreferences.getInstance();
        final authToken = prefs.getString('token');
        
        log("$authToken",name: 'authToken home data');
        final headers = {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        };
        final response = await http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
        );
        

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          return jsonData;
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    }

  // fetchHomeCategoryData(String endpoint) async {
  //   final client = http.Client();
  //   int maxRetryCount = 3; // Set the maximum number of retries
  //   int currentRetry = 0;
  //   Duration initialTimeout = const Duration(seconds: 5);
  //   while (currentRetry < maxRetryCount) {
  //     try {
  //       final prefs = await SharedPreferences.getInstance();
  //       final authToken = prefs.getString('token') ?? '';
  //       final headers = {
  //         'Authorization': 'Bearer $authToken',
  //         'Content-Type': 'application/json',
  //       };
  //       final response = await http
  //           .get(
  //             Uri.parse('$baseUrl/$endpoint'),
  //             headers: headers,
  //           )
  //           .timeout(initialTimeout + Duration(seconds: currentRetry * 5));

  //       if (response.statusCode == 200) {
  //         final jsonData = json.decode(response.body);
  //         return jsonData;
  //       } else {
  //         throw Exception('Failed to load data');
  //       }
  //     } on TimeoutException catch (_) {
  //       print('Timeout error: Request took too long to complete.');
  //     } catch (e) {
  //       client.close();
  //       throw Exception('Error: $e');
  //     }
  //   }
  //   currentRetry++;
  // }


  Future<Map<String, dynamic>> noAuthFetchHomeCategoryData(
      String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> registerUser(
    String userName,
    String email,
    String password,
    String mobileNo,
  ) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'user_name': userName,
      'email': email,
      'password': password,
      'mobile_no': mobileNo,
    });

    final response = await http.post(
      Uri.parse(register),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email_or_user_name': email,
      'password': password,
    });

    final response = await http.post(
      Uri.parse(login),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to login user');
    }
  }

  Future<Map<String, dynamic>> socialLoginUser(
    String email,
    String userName,
    String loginType,
  ) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'user_name': userName,
      'login_type': loginType,
    });

    final response = await http.post(
      Uri.parse(socialLogin),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to social login user');
    }
  }

  fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      log(authToken,name: 'fetch profile authtoken');
      final response = await http.post(
        Uri.parse(editPofile),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<Map<String, dynamic>> editProfile(
    String authToken,
    String name,
    String email,
    String mobileNo,
    String age,
    String gender,
    // ignore: non_constant_identifier_names
    File profile_pic,
  ) async {
    final uri = Uri.parse(editPofile);

    try {
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $authToken'
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['mobile_no'] = mobileNo
        ..fields['age'] = age
        ..fields['gender'] = gender
        ..files.add(
          http.MultipartFile(
            'profile_pic',
            profile_pic.readAsBytes().asStream(),
            profile_pic.lengthSync(),
            filename:
                'profile_pic.jpg', // You can change the filename as needed
            contentType: MediaType('image',
                'jpg'), // Adjust the content type based on your image type
          ),
        );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return {}; // Return an empty map or an appropriate response in case of an error
    }
  }

  Future<Map<String, dynamic>> fetchAllCategoryData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        Uri.parse(allCategory),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> addPlaylist(
      String authToken, String playlistTitle) async {
    final headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'pl_title': playlistTitle,
    });

    final response = await http.post(
      Uri.parse(addPlayList),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to add playlist');
    }
  }

  Future<Map<String, dynamic>> fetchMyPlaylistData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        Uri.parse(myPlayList),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> cheackInMyPlaylistSongAvailable(
      String musicid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        Uri.parse('$myPlayList?musicId=$musicid'),
        headers: headers,
      );
      // print('$baseUrl/myPlayList?musicId=$musicid');
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> addSongInPlaylist(
      {String? playlistId, songsId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'playlist_id': playlistId,
        'songs_id': "$songsId",
      });

      final response = await http.post(
        Uri.parse(addSongInList),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception(
            'Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> allSongsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final response = await http.get(
        Uri.parse(addSongList),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> noAuthAllSongsList() async {
    try {
      final response = await http.get(
        Uri.parse(noAuthAddSongList),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> songsInPlaylist(String playlistId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token') ?? '';
    final headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'playList_id': playlistId,
    });

    final response = await http.post(
      Uri.parse(playlistSongs),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch playlist songs');
    }
  }

  Future<Map<String, dynamic>> removeSongsFromPlaylist(
      String musicId, String plylistId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token') ?? '';
    final headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'music_id': musicId,
      'playlist_id': plylistId,
    });

    final response = await http.post(
      Uri.parse(removeSongPlaylist),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to remove songs from playlist');
    }
  }

  Future<Map<String, dynamic>> addSongInDownloadList({String? musicId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'song_id': musicId,
      });

      final response = await http.post(
        Uri.parse(addDownloadSong),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to add song in download list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> downloadSongsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(downloadSongList),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch download song list');
      }
    } catch (e) {
       if (e is SocketException) {
      throw Exception('Network error: Unable to connect to the server.');
    } else {
      throw Exception('Error: $e');
    }
    }
  }

  Future<Map<String, dynamic>> likeUnlikedSong({String? musicId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'song_id': musicId,
      });

      final response = await http.post(
        Uri.parse(likeUnlikedSongs),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to like unlike song');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<Map<String, dynamic>> addQueueSong({String? musicId,String? playlisId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'song_id': musicId,
        'playlist_id': playlisId,
      });

      final response = await http.post(
        Uri.parse(addQueueSongs),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to add queue song');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> queueSongsList({String? playlisId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'playlist_id': playlisId,
      });

      final response = await http.post(
        Uri.parse(queueSongList),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to queue song list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> favoriteSongsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(favoriteSongList),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch favorite song list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

   Future<Map<String, dynamic>> addRecentlySongs({String? musicId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'song_id': musicId,
      });

      final response = await http.post(
        Uri.parse(addRecentlySong),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to add recent song');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> recentSongsList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(recentSongList),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch recent song list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  Future<Map<String, dynamic>> queueSongsListWithoutPlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token') ?? '';
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse(queueSongListWithoutPlaylist),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to fetch queue song list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

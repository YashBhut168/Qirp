
// ignore_for_file: file_names

class GlobVar {

  ///bool
  static bool? login = false;

  /// forgot pass (forgot pass screen) 
  static bool forgotPasswordApiSuccess = false;

  /// verifyotp (otp screen)
  static bool verifyOtpApiSuccess = false;


  /// int
  
  /// see all
  static int currentCategoryIndex = -1;

  /// home category
  // static int homeCateIndex = -1;
  // static int homeCateSongIndex = -1;
  




  ///String

  // init screeen
  static String deviceToken = '';

  static String playlistId = '';

  /// forgot pass (forgot pass screen)
  static String forgotPasswordApiMessage = '';

  /// verifyotp (otp screen)
  static String verifyOtpApiMessage = '';

  /// library screen
  static String userId = '';

  /// addvideoPost screen
  static String addPostSuccess = "";

  //likeunlike reel (reels screen)
  // static String likeUnlikeMessage = '';
  // ignore: prefer_typing_uninitialized_variables
  static var reelIndex;


  // album screen
  static String albumId = '';

  // artist screen
  static String artistId = '';


  // search screen
  static String searchText = '';


  // admin and user playlist song 
  static String adminOrUserPlaylist = '';
  static String adminPlaylistTapped = '';


  ///Array
  // reels screen
  static var reelVideoList = [];
  static var likeReelList = [];
  static var likeUnlikeMessage = [];



}
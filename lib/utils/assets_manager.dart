const String imagePath = 'assets/images';

const String jsonPath = 'assets/json';

class ImageAssets {
  //splash screen
  static const String lightModeSplashLogo = '$imagePath/logo.png';
  static const String darkModeSplashLogo = '$imagePath/logo.png';
  static const String onBoardingLogo = '$imagePath/onboarding_logo.png';
  static const String loginDarkModeLoginLogo =
      '$imagePath/login_dark_mode_logo.png';
  static const String loginBackground = '$imagePath/login_background.png';
  static const String profile = '$imagePath/home/profile.png';
  static const String inProgress = '$imagePath/home/inProgress.png';
  static const String timeSent = '$imagePath/home/time.png';
  static const String finished = '$imagePath/home/workouts_icon.png';
  static const String cardio = '$imagePath/home/cardio.png';

  //Workouts
  static const String yoga = 'assets/icons/workouts/yoga.png';
  static const String pilates = 'assets/icons/workouts/pilates.png';
  static const String fullBody = 'assets/icons/workouts/full_body.png';
  static const String stretching = 'assets/icons/workouts/stretching.png';
}

class JsonAssets {
  //onboarding screen
  static const List<String> onBoardingLogos = [
    "$jsonPath/on_boarding_sell.json",
    "$jsonPath/on_boarding_exchange.json",
    "$jsonPath/on_boarding_donate.json",
  ];
  //state renderer
  static const String loading = "$jsonPath/loading.json";
  static const String error = "$jsonPath/error.json";
  static const String empty = "$jsonPath/empty.json";
  static const String success = "$jsonPath/success.json";
}
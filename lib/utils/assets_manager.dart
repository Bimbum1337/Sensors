const String imagePath = 'assets/images';

const String jsonPath = 'assets/json';

class ImageAssets {
  //splash screen
  static const String lightModeSplashLogo = '$imagePath/light_mode_logo.png';
  static const String darkModeSplashLogo = '$imagePath/dark_mode_logo.png';
  static const String onBoardingLogo = '$imagePath/onboarding_logo.png';
  static const String loginDarkModeLoginLogo =
      '$imagePath/login_dark_mode_logo.png';
  static const String loginBackground = '$imagePath/login_background.png';
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
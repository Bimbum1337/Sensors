import 'package:flutter/material.dart';
import 'package:untitled5/Utils/app_strings.dart';
import 'package:untitled5/screens/home_view.dart';
import 'package:untitled5/screens/sensor_view.dart';
import '../screens/settings_view.dart';
import '../screens/splash/splash_view.dart';
import '../screens/heart_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String mainRoute = "/main";
  static const String sensorRoute = "/sensor";
  static const String homeRoute = "/home";
  static const String settingsRoute = "/settings";
  static const String heartRoute = "/heart";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.sensorRoute:
        return MaterialPageRoute(builder: (context) => const SensorView());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case Routes.settingsRoute:
        return MaterialPageRoute(builder: (context) => const SettingsView());
      case Routes.heartRoute:
        return MaterialPageRoute(builder: (context) => const HeartView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteTitle),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}

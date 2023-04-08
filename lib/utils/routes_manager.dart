import 'package:flutter/material.dart';
import 'package:untitled5/Utils/app_strings.dart';
import 'package:untitled5/screens/main_view.dart';
import 'package:untitled5/screens/sensor_view.dart';

import '../screens/splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String mainRoute = "/main";
  static const String sensorRoute = "/sensor";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (context) => MainScreen());
      case Routes.sensorRoute:
        return MaterialPageRoute(builder: (context) => SensorView());
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

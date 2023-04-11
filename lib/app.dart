import 'package:flutter/material.dart';
import 'package:untitled5/utils/colors_manager.dart';
import 'package:untitled5/utils/styles_manager.dart';
import 'Utils/routes_manager.dart';

class MyApp extends StatefulWidget {
  //this approach is to make a singleton out of a class. same concept of static. so that every time we initialize the class we get the same instance
  // ignore: prefer_const_constructors_in_immutables
  MyApp._internal(); //named constructor

  static final MyApp _instance =
  MyApp._internal(); //singleton or single instance

  //factory whether to return a new instance or just ( return the static instance we created as shown here )
  factory MyApp() => _instance; //factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //starting the flow of the application by defining the onGenerateRoute function and initialize it with the first route the application would start with.
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: ThemeData(
        textTheme: TextTheme(
            displayLarge:
            getLightStyle(color: ColorsManager.white, fontSize: 24),
            headlineLarge:
            getSemiBoldStyle(color: ColorsManager.white, fontSize: 16),
            headlineMedium:
            getRegularStyle(color: ColorsManager.white, fontSize: 14),
            titleMedium: getMediumStyle(
                color: ColorsManager.secondaryText, fontSize: 14),
            bodyLarge: getRegularStyle(color: ColorsManager.grey1),
            bodySmall: getRegularStyle(color: ColorsManager.grey)),
      ),
    );
  }
}

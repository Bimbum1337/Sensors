import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:untitled5/Utils/routes_manager.dart';
import 'package:untitled5/utils/assets_manager.dart';
import 'package:untitled5/utils/colors_manager.dart';
import 'package:untitled5/utils/constants_manager.dart';

import '../../utils/app_strings.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initTimers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 60.0,
            ),
            const Expanded(
              child: Image(
                height: 250.0,
                image: AssetImage(ImageAssets.darkModeSplashLogo),
              ),
            ),
            const Spacer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  children: [
                    SpinKitSquareCircle(
                      color: ColorsManager.primaryColor,
                      size: 50.0,
                    ),
                    Text(
                      AppStrings.poweredBy,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      AppStrings.eagles,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initTimers() {
    _timer = Timer(
        const Duration(
          milliseconds: AppConstants.splashLoadingDelay,
        ),
        _onFinishLoading);
  }

  void _onFinishLoading() async {
    Navigator.pushReplacementNamed(context, Routes.settingsRoute);
  }
}

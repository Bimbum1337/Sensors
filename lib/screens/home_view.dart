// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:untitled5/screens/app_pref.dart';
import 'package:untitled5/screens/data_view.dart';
import 'package:untitled5/utils/colors_manager.dart';
import 'dart:math'; // Import the math library
import '../Utils/routes_manager.dart';
import '../utils/assets_manager.dart';
import '../utils/constants_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<double>? _accelerometerValues;
  List<double>? _previousAccelerometerValues;
  int _stepCount = 0;
  Position? _currentPosition;
  double _distanceTraveled = 0;
  double _caloriesBurned = 0;
  StreamController<Position> locationStream = StreamController<Position>();
  StreamSubscription<Position>? locationSubscription;
  Timer? _timer;
  Timer? _timer2;

  int counter = 0;
  bool isRunning = false;
  String activity = 'Idle';
  int lastShown = 1;
  int standUp = 0;
  bool _isStanding = false;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  double altitude = 0.0;
  BarometerValue _currentPressure = const BarometerValue(0.0);

  @override
  void initState() {
    super.initState();

    _initTimers();

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
            _calculateSteps();
            _calculateCaloriesBurned();

            double magnitude =
                sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
            if (magnitude > 30 && !_isStanding) {
              setState(() {
                _isStanding = true;
                if (isRunning) {
                  standUp += 1;
                }
              });
            } else if (magnitude < 10 && _isStanding) {
              setState(() {
                _isStanding = false;
              });
            }
          });
        },
      ),
    );

    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            double acceleration =
                sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

            if (acceleration > 0.5 && acceleration < 3) {
              activity = "Walking";
            } else if (acceleration >= 4) {
              activity = "Running";
            } else {
              activity = "Idle";
            }
          });
        },
      ),
    );

    FlutterBarometer.currentPressureEvent.listen((event) {
      _currentPressure = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 5),
          children: [
            _createProfileData(context),
            const SizedBox(height: 35),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _createComletedWorkouts(context),
                  _createColumnStatistics(),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DataWorkouts(
                icon: ImageAssets.activity,
                title: "Realtime Activity Detection",
                count: -1,
                text: activity,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DataWorkouts(
                icon: ImageAssets.train,
                title: "Training Recommend",
                count: -1,
                text: _trainingRecommendation(),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DataWorkouts(
                icon: ImageAssets.timeSent,
                title: "Timer",
                count: -1,
                text: getRunningTime(),
                btn: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryColor,
                    ),
                    onPressed: () {
                      if (isRunning) {
                        stopTimer();
                      } else {
                        startTimer();
                      }
                    },
                    child: Text(isRunning ? 'Stop' : 'Start')),
              ),
            ),
            const SizedBox(height: 15),
            _createRowStatistics(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var element in _streamSubscriptions) {
      element.cancel();
    }

    if (locationSubscription != null) {
      locationSubscription!.cancel();
    }

    FlutterBarometer.currentPressureEvent.drain();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (_currentPosition != null && isRunning) {
        double distanceInMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude.abs(),
            _currentPosition!.longitude.abs(),
            position.latitude.abs(),
            position.longitude.abs());

        _distanceTraveled += distanceInMeters;
      }

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  double _altitudeInMeters() {
    // ignore: unnecessary_null_comparison
    if (_currentPressure != null) {
      double pressure = (_currentPressure.hectpascal * 1000).round() / 1000;
      double altitudeInMeters = (1 - pow(pressure / 1013.25, 0.190284)) * 44330;
      return altitudeInMeters;
    } else {
      return 0.0;
    }
  }

  String _trainingRecommendation() {
    altitude = _altitudeInMeters();
    if (altitude < 1000) {
      return "Train hard, low altitude.";
    } else if (altitude < 2000) {
      return "Adjust intensity, moderate altitude.";
    } else {
      return "Decrease intensity, high altitude .";
    }
  }

  void _calculateSteps() {
    double oldValueSum = 0;
    double newValueSum = 0;
    double threshold = 10.0;
    //x , y  , z
    if (_previousAccelerometerValues != null) {
      oldValueSum = _previousAccelerometerValues!
          .map((value) => value.abs())
          .reduce((a, b) {
        return a + b;
      });

      newValueSum = _accelerometerValues!
          .map((value) => value.abs())
          .reduce((a, b) => a + b);

      if (newValueSum - oldValueSum > threshold) {
        _stepCount++;
      }
    }

    _previousAccelerometerValues = List.from(_accelerometerValues!);
  }

  void _calculateCaloriesBurned() {
    double weightInKg = AppPreferences.getInt("Weight").toDouble();
    double heightInCm = AppPreferences.getInt("Height").toDouble();
    double ageInYears = AppPreferences.getInt("Age").toDouble();

    // Calculate Basal Metabolic Rate (BMR) using the Mifflin-St Jeor equation
    // ignore: non_constant_identifier_names
    double BMR = 10 * weightInKg + 6.25 * heightInCm - 5 * ageInYears;

    if (AppPreferences.getString("Gender") == "Male") {
      BMR += 5;
    }

    // Calculate Total Daily Energy Expenditure (TDEE) using the Harris-Benedict equation
    // ignore: non_constant_identifier_names, unused_local_variable
    double TDEE = 0;
    if (AppPreferences.getString("Gender") == "Male") {
      TDEE = 1.3 * BMR;
    } else {
      TDEE = 1.2 * BMR;
    }

    // Calculate calories burned from walking
    double caloriesBurnedWalkingPerMile = weightInKg *
        0.57; // 1 mile = 1609.344 meters, 1 kg = 2.20462 lbs, 1 lb = 0.453592 kg, 1 MET = 3.5 ml/kg/min, 1 ml/kg/min = 0.0833 cal/kg/min
    double caloriesBurnedWalking =
        caloriesBurnedWalkingPerMile * _distanceTraveled / 1609.344;

    // Calculate calories burned from steps
    double caloriesBurnedSteps = 0.04 * _stepCount;

    // Calculate total calories burned
    double totalCaloriesBurned = caloriesBurnedWalking + caloriesBurnedSteps;
    setState(() {
      _caloriesBurned = totalCaloriesBurned;
    });
  }

  void _initTimers() {
    _timer = Timer.periodic(
        const Duration(
          milliseconds: 5000,
        ),
        _onTick);
  }

  void _onTick(timer) async {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    await _getCurrentLocation();

    _timer = Timer.periodic(
        const Duration(
          milliseconds: 5000,
        ),
        _onTick);
  }

  Widget _createProfileData(BuildContext context) {
    String displayName = AppPreferences.getString("Name");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $displayName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Check Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.primaryText,
                ),
              ),
            ],
          ),
          GestureDetector(
            child: CircleAvatar(
                backgroundColor: ColorsManager.primaryColor,
                backgroundImage:
                    const AssetImage(ImageAssets.lightModeSplashLogo),
                radius: 50),
          ),
        ],
      ),
    );
  }

  Widget _createComletedWorkouts(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(15),
      height: 200,
      width: screenWidth * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsManager.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.secondaryBackground.withOpacity(0.12),
            blurRadius: 5.0,
            spreadRadius: 1.1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Image(
                image: AssetImage(
                  ImageAssets.footstep,
                ),
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Walked",
                  style: TextStyle(
                    color: ColorsManager.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          ),
          Text(
            '$_stepCount',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: ColorsManager.primaryText,
            ),
          ),
          Text(
            "Steps",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorsManager.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createColumnStatistics() {
    return Column(
      children: [
        DataWorkouts(
          icon: ImageAssets.finished,
          title: "Calories",
          count: _caloriesBurned.toInt(),
          text: 'KCal',
        ),
        const SizedBox(height: 20),
        InkWell(
          child: DataWorkouts(
            icon: ImageAssets.heart,
            title: "Heart Rate",
            count: -1,
            text: AppConstants.HeartBeats,
          ),
          onTap: () => Navigator.pushNamed(context, Routes.heartRoute),
        ),
      ],
    );
  }

  Widget _createRowStatistics() {
    return Row(
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: DataWorkouts(
              icon: ImageAssets.standUp,
              title: "Stand Ups",
              count: standUp,
              text: "Times",
            ),
          ),
        ),
        Flexible(
          child: InkWell(
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: DataWorkouts(
                icon: ImageAssets.distance,
                title: "Distance",
                count: _distanceTraveled.toInt(),
                text: "Meters",
              ),
            ),
            onTap: () => Navigator.pushNamed(context, Routes.heartRoute),
          ),
        ),
      ],
    );
  }

  void startTimer() {
    _timer2 = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        counter++;
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    _timer2!.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String getRunningTime() {
    if (counter < 60) {
      return '$counter Seconds';
    } else if (counter < 3600) {
      return '${counter ~/ 60} Minutes ${counter % 60} Seconds';
    } else {
      return '${counter ~/ 3600} Hours ${(counter % 3600) ~/ 60} Minutes ${(counter % 3600) % 60} Seconds';
    }
  }
}

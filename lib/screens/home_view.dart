import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:untitled5/utils/colors_manager.dart';
import 'dart:math'; // Import the math library

import '../utils/assets_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _previousAccelerometerValues;
  List<double>? _userAccelerometerValues;
  int _stepCount = 0;
  Position? _currentPosition;
  double _distanceTraveled = 0;
  double _caloriesBurned = 0;
  int _weight = 70; // in kilograms
  int _height = 170; // in centimeters
  int _age = 30;
  bool _isMale = true;
  StreamController<Position> locationStream = StreamController<Position>();
  StreamSubscription<Position>? locationSubscription;
  Timer? _timer;
  String activity = 'Idle';
  int lastShown = 1;
  int standUp = 0;
  bool _isStanding = false;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  double altitude = 0.0;
  BarometerValue _currentPressure = BarometerValue(0.0);

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();

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
                icon: ImageAssets.inProgress,
                title: "Stand Ups",
                count: standUp,
                text: "Times",
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DataWorkouts(
                icon: ImageAssets.inProgress,
                title: "Realtime Activity Detection",
                count: -1,
                text: activity,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: DataWorkouts(
                icon: ImageAssets.inProgress,
                title: "Training Recommend",
                count: -1,
                text: _trainingRecommendation(),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              print(magnitude);

              setState(() {
                _isStanding = true;
                standUp += 1;
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
            _gyroscopeValues = <double>[event.x, event.y, event.z];

            double acceleration =
                sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

            if (acceleration > 9.8 && acceleration < 12) {
              activity = "Walking";
            } else if (acceleration >= 12 && acceleration < 20) {
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
  void dispose() {
    _streamSubscriptions.forEach((element) {
      element.cancel();
    });

    if(locationSubscription != null) {
      locationSubscription!.cancel();
    }

    FlutterBarometer.currentPressureEvent.drain();
    super.dispose();
  }
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (_currentPosition != null) {
        double distanceInMeters = await Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            position.latitude,
            position.longitude);

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
      return "Decrease intensity, high altitude.";
    }
  }

  void _calculateSteps() {
    double oldValueSum = 0;
    double newValueSum = 0;
    double threshold = 10.0;

    if (_previousAccelerometerValues != null) {
      oldValueSum = _previousAccelerometerValues!
          .map((value) => value.abs())
          .reduce((a, b) => a + b);

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
    double weightInKg = _weight.toDouble();
    double heightInCm = _height.toDouble();
    double ageInYears = _age.toDouble();

    // Calculate Basal Metabolic Rate (BMR) using the Mifflin-St Jeor equation
    double BMR = 10 * weightInKg + 6.25 * heightInCm - 5 * ageInYears;
    if (_isMale) {
      BMR += 5;
    } else {
      BMR -= 161;
    }

    // Calculate Total Daily Energy Expenditure (TDEE) using the Harris-Benedict equation
    double TDEE = 0;
    if (_isMale) {
      TDEE = 1.2 * BMR;
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
    const displayName = "No Username";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Hi, $displayName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Check Activity",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            child: const CircleAvatar(
                backgroundImage: AssetImage(ImageAssets.profile), radius: 60),
            onTap: () async {},
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
        color: ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.12),
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
                  ImageAssets.finished,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Walked",
                  style: TextStyle(
                    color: ColorsManager.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
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
              color: ColorsManager.black,
            ),
          ),
          Text(
            "Steps",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorsManager.grey,
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
          icon: ImageAssets.inProgress,
          title: "Calories",
          count: _caloriesBurned.toInt(),
          text: 'KCal',
        ),
        const SizedBox(height: 20),
        DataWorkouts(
          icon: ImageAssets.timeSent,
          title: "Distance",
          count: _distanceTraveled.toInt(),
          text: "Meters",
        ),
      ],
    );
  }
}

class DataWorkouts extends StatelessWidget {
  final String icon;
  final String title;
  final int count;
  final String text;

  DataWorkouts({
    required this.icon,
    required this.title,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 90,
      width: screenWidth * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.12),
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
              Image(image: AssetImage(icon)),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (count > -1)
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.black,
                  ),
                )
              else
                SizedBox(
                  width: 35,
                ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ColorsManager.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

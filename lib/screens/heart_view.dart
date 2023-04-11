import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/utils/colors_manager.dart';
import 'package:wakelock/wakelock.dart';

import '../utils/constants_manager.dart';
import 'chart_view.dart';

class HeartView extends StatefulWidget {
  const HeartView({super.key});

  @override
  HeartViewView createState() {
    return HeartViewView();
  }
}

class HeartViewView extends State<HeartView> {
  bool _toggled = false;
  bool _processing = false;
  final List<SensorValue> _data = [];
  CameraController? _controller;
  final double _alpha = 0.3;
  int _bpm = 0;

  _toggle() {
    _initController().then((onValue) {
      Wakelock.enable();
      setState(() {
        _toggled = true;
        _processing = false;
      });
      _updateBPM();
    });
  }

  _untoggle() {
    _disposeController();
    Wakelock.disable();
    setState(() {
      _toggled = false;
      _processing = false;
    });
  }

  Future<void> _initController() async {
    try {
      List cameras = await availableCameras();
      _controller = CameraController(cameras.first, ResolutionPreset.low);
      await _controller?.initialize();
      Future.delayed(const Duration(milliseconds: 500)).then((onValue) {
        _controller?.setFlashMode(FlashMode.torch);
      });
      _controller?.startImageStream((CameraImage image) {
        if (!_processing) {
          setState(() {
            _processing = true;
          });
          _scanImage(image);
        }
      });
    } on Exception {
      print(Exception);
    }
  }

  _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data);
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            bpm += 60000 / (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        bpm = bpm / _counter;
        setState(() {
          _bpm = ((1 - _alpha) * bpm + _alpha * bpm).toInt();
          if(_bpm > 30 && _bpm < 150) {
            AppConstants.HeartBeats = _bpm.round().toString();
          }
        });
      }
      await Future.delayed(Duration(milliseconds: (1000 * 50 / 30).round()));
    }
  }

  _scanImage(CameraImage image) {
    double _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;

    if (_data.length >= 50) {
      _data.removeAt(0);
    }

    setState(() {
      _data.add(SensorValue(DateTime.now(), _avg));
    });

    Future.delayed(const Duration(milliseconds: 1000 ~/ 30)).then((onValue) {
      setState(() {
        _processing = false;
      });
    });
  }

  _disposeController() {
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryBackground,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: _controller == null
                          ? Container()
                          : CameraPreview(_controller!),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        (_bpm > 30 && _bpm < 150
                            ? _bpm.round().toString()
                            : "--"),
                        style: TextStyle(
                            color: ColorsManager.secondaryBackground,
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: IconButton(
                  icon: Icon(_toggled ? Icons.favorite : Icons.favorite_border),
                  color: Colors.red,
                  iconSize: 128,
                  onPressed: () {
                    if (_toggled) {
                      _untoggle();
                    } else {
                      _toggle();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: ColorsManager.secondaryBackground),
                child: Chart(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}

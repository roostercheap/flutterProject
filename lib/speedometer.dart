import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Speedometer extends StatefulWidget {
  final Function(double) onSpeedChanged;

  Speedometer({required this.onSpeedChanged});

  @override
  _SpeedometerState createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer> {
  int _speed = 0;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        _speed = (position.speed * 2.23694).round();
        widget.onSpeedChanged(_speed.toDouble()); // Call callback function
      });
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
              'Speed: $_speed mph',
              style: TextStyle(fontSize: 24),
            ),
        // Row(
        //   children: [
        //     Text(
        //       'Speed: $_speed mph',
        //       style: TextStyle(fontSize: 24),
        //     ),
            // ElevatedButton(
            //   onPressed: () => _startTracking(),
            //   child: Text('Reset'),
            // ),
          // ],
        // )
      ),
    );
  }
}

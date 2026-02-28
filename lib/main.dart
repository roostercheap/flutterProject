import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'miles-log.dart';
import 'dart:math';
import 'speedometer.dart';
import 'altitude.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speedometer App'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (BuildContext context, AsyncSnapshot<CompassEvent> snapshot) {
                      if (snapshot.hasData) {
                        final heading = snapshot.data!.heading;
                        if (heading == null) {
                          return Text('Heading is not available');
                        }
                        return Transform.rotate(
                          angle: heading * (pi / 180),
                          child: Icon(Icons.north, size: 50, color: Colors.red),
                        );
                      } else {
                        return CircularProgressIndicator(); // Show a loading spinner while waiting for data
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationWidget(),
                    Expanded(
                      child: Center(
                        child: Speedometer(
                          onSpeedChanged: (velocity) {
                            // Callback function to update velocity in MilesLogWidget
                            MilesLogWidget.updateVelocity(velocity);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              MilesLogWidget()
            ],
          );
        },
      ),
    );
  }
}

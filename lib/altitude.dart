
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationWidget extends StatefulWidget {
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  double _latitude = 0.0;
  double _longitude = 0.0;
  bool _isFetching = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    bool hasPermission = await _requestLocationPermission();
    if (hasPermission) {
      _fetchLocation();
    }
  }

  Future<bool> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _statusMessage = 'Location services are disabled.';
      });
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _statusMessage = 'Location permissions are denied.';
        });
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _statusMessage = 'Location permissions are permanently denied.';
      });
      return false;
    }

    // Permissions are granted
    return true;
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetching = true;
      _statusMessage = 'Fetching location...';
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _statusMessage = 'Location fetched successfully';
      });
    } catch (e) {
      setState(() {
        _latitude = 0.0;
        _longitude = 0.0;
        _statusMessage = 'Error fetching location: $e';
      });
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isFetching)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                Text(
                  'Latitude: ${_latitude.toStringAsFixed(6)}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  'Longitude: ${_longitude.toStringAsFixed(6)}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _statusMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}


// CODE GRAVEYARD

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class AltitudeScaleWidget extends StatefulWidget {
//   @override
//   _AltitudeScaleWidgetState createState() => _AltitudeScaleWidgetState();
// }

// class _AltitudeScaleWidgetState extends State<AltitudeScaleWidget> {
//   double _altitude = 0.0;
//   bool _isFetching = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAltitude();
//   }

//   Future<void> _fetchAltitude() async {
//     setState(() {
//       _isFetching = true;
//     });

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _altitude = position.latitude;
//         print('Altitude: ');
//         print(position.altitude);
//         print(position.latitude);
//         print('Altitude: end');
//       });
//     } catch (e) {
//       setState(() {
//         _altitude = 1.0;
//       });
//     } finally {
//       setState(() {
//         _isFetching = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double maxHeight = 300.0; // Set the max height for the scale
//     double altitudeHeight = (_altitude / 10000) *
//         maxHeight; // Assuming 1000 meters as the max altitude for scaling
//     //print(altitudeHeight);

//     return Container(
//       width: 100,
//       height: maxHeight,
//       padding: EdgeInsets.all(8.0),
//       margin: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           if (_isFetching)
//             Center(child: CircularProgressIndicator())
//           else
//             Container(
//               width: 80,
//               height: altitudeHeight,
//               color: Colors.blue,
//             ),
//           Positioned(
//             bottom: altitudeHeight + 5,
//             child: Text(
//               '${_altitude.toStringAsFixed(2)} m',
//               style: TextStyle(color: Colors.black, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

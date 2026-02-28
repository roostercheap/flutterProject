import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MilesLogWidget extends StatefulWidget {
  @override
  _MilesLogWidgetState createState() => _MilesLogWidgetState();

  static void updateVelocity(double velocity) {
    // Update velocity value here
    _MilesLogWidgetState? _currentState = _MilesLogWidgetState();
    _currentState._updateMiles(velocity);
  }
}

class _MilesLogWidgetState extends State<MilesLogWidget> {
  late SharedPreferences _prefs;
  double milesSinceStart = 0.0;
  double milesSinceRefuel = 0.0;
  double milesSinceMaintenance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMiles();
  }

  void updateVelocity(double velocity) {
    setState(() {
      this._updateMiles(velocity);
    });
  }

  Future<void> _loadMiles() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      milesSinceStart = _prefs.getDouble('milesSinceStart') ?? 0.0;
      milesSinceRefuel = _prefs.getDouble('milesSinceRefuel') ?? 0.0;
      milesSinceMaintenance = _prefs.getDouble('milesSinceMaintenance') ?? 0.0;
    });
  }

  Future<void> _updateMiles(double velocity) async {
    double value = velocity / 3600.0;
    setState(() {
      milesSinceStart += value;
      milesSinceRefuel += value;
      milesSinceMaintenance += value;
    });
    
    await _prefs.setDouble('milesSinceStart', milesSinceStart);
    await _prefs.setDouble('milesSinceRefuel', milesSinceRefuel);
    await _prefs.setDouble('milesSinceMaintenance', milesSinceMaintenance);
  }

  Future<void> _resetMiles(String key) async {
    setState(() {
      if (key == 'milesSinceStart') {
        milesSinceStart = 0.0;
      } else if (key == 'milesSinceRefuel') {
        milesSinceRefuel = 0.0;
      } else if (key == 'milesSinceMaintenance') {
        milesSinceMaintenance = 0.0;
      }
    });
    await _prefs.setDouble(key, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          padding: EdgeInsets.all(16.0),
          width: orientation == Orientation.portrait ? double.infinity : 200.0,
          child: Column(
            children: [
              _buildMilesRow('Miles Since Start', milesSinceStart, 'milesSinceStart'),
              _buildMilesRow('Refuel', milesSinceRefuel, 'milesSinceRefuel'),
              _buildMilesRow('Maintenance', milesSinceMaintenance, 'milesSinceMaintenance'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMilesRow(String label, double miles, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: ${miles.toStringAsFixed(1)}miles',
            style: TextStyle(fontSize: 14.0),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _updateMiles(3600),
                child: Text('+1'),
              ),
              SizedBox(width: 6.0),
              ElevatedButton(
                onPressed: () => _resetMiles(key),
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

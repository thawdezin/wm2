import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      home: TimeTrackerScreen(),
    );
  }
}

class TimeTrackerScreen extends StatefulWidget {
  @override
  _TimeTrackerScreenState createState() => _TimeTrackerScreenState();
}

class _TimeTrackerScreenState extends State<TimeTrackerScreen> {
  List<String> savedTimes = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTimes();
    _startBackgroundTimer();
  }

  void _loadSavedTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? times = prefs.getStringList('savedTimes');
    if (times != null) {
      setState(() {
        savedTimes = times;
      });
    }
  }

  void _startBackgroundTimer() {
    const Duration interval = Duration(seconds: 13);
    Timer.periodic(interval, (Timer timer) async {
      String currentTime = DateTime.now().toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      savedTimes.add(currentTime);
      prefs.setStringList('savedTimes', savedTimes);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: savedTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savedTimes[index]),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveCurrentTime();
            },
            child: Text('Save Current Time'),
          ),
        ],
      ),
    );
  }

  void _saveCurrentTime() async {
    String currentTime = DateTime.now().toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedTimes.add(currentTime);
    prefs.setStringList('savedTimes', savedTimes);
    setState(() {});
  }
}

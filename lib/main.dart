import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<Event> _events = [];
  final List<DateTime> _selectedDays = [];
  List<dynamic> _eventsForSelectedDays = [];
  DateTime _rangeStartDay = DateTime.now();
  DateTime _rangeEndDay = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _events.addAll(List.generate(10, (index) => generateRandomEvent()));
  }

  Event generateRandomEvent() {
    final random = Random();
    final title = 'Event ${random.nextInt(1000)}'; // Generate a unique title
    final startTime = DateTime.now().add(Duration(hours: random.nextInt(24)));
    final endTime = startTime.add(Duration(
        hours: random.nextInt(4))); // End time within 4 hours of start time
    return Event(title, startTime, endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          TextButton(
            onPressed: () =>
                setState(() => _calendarFormat = CalendarFormat.month),
            child: const Text(
              'Month',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () =>
                setState(() => _calendarFormat = CalendarFormat.week),
            child: const Text('Week', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Center(
        child: TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: (365 * 10))),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => _selectedDays.contains(day),
          onDaySelected: _handleDaySelected,
          rangeStartDay:  _rangeStartDay,
          rangeEndDay: _rangeEndDay,

          onRangeSelected: (start, end, focusedDay) {
            print('object');
            _rangeStartDay =start!;
            _rangeEndDay = end!;
          },
        ),
      ),
    );
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {

      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
        _eventsForSelectedDays = _fetchEventsForDays(_selectedDays);
        // _showEventBottomSheet();
      }
      _rangeEndDay = _selectedDays.last;
      _rangeStartDay = _selectedDays.first;
      _focusedDay = focusedDay;
    });
  }

  List<Event> _fetchEventsForDays(List<DateTime> days) {
    return _events.where((event) => days.contains(event.startTime)).toList();
  }

  void _showEventBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _eventsForSelectedDays.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  _eventsForSelectedDays[index].title), // Adjust for your model
              // ... other event details
            );
          },
        );
      },
    );
  }
}

class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  Event(this.title, this.startTime, this.endTime);
}

import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final List<Event> _events = [];
  final List<DateTime> _selectedDays = [];
  List<Event> _eventsForSelectedDays = [];
  DateTime _rangeStartDay = DateTime.now();
  DateTime _rangeEndDay = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateRandomEvent(DateTime(2024, 1, 1), DateTime(2024, 1, 31));
  }

  void generateRandomEvent(DateTime startDate, DateTime endDate) {
    for (var date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      String title = "${date.day}";
      String subtitle = date.prettyMonth();
      _events.add(Event(
          title,
          date,
          date.add(const Duration(hours: 1)),
          Random().nextInt(11),
          Random().nextInt(11),
          Random().nextInt(11),
          subtitle));
    }
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
          calendarBuilders: const CalendarBuilders(),
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: (365 * 10))),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => _selectedDays.contains(day),
          onDaySelected: _handleDaySelected,
          rangeStartDay: _rangeStartDay,
          rangeEndDay: _rangeEndDay,
        ),
      ),
    );
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.length == 2) {
        _selectedDays.clear();
      }
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
        if (_selectedDays.first.compareTo(_selectedDays.last) == -1) {
          _rangeEndDay = _selectedDays.last;
          _rangeStartDay = _selectedDays.first;
        } else {
          _rangeEndDay = _selectedDays.first;
          _rangeStartDay = _selectedDays.last;
        }

        _eventsForSelectedDays = _fetchEventsForDays(
            _selectedDays.map((e) => e.prettyDate()).toList());
        _selectedDays.length == 2 ? _showEventBottomSheet() : null;
      }

      _focusedDay = focusedDay;
    });
  }

  List<Event> _fetchEventsForDays(List<DateTime> days) {
    final startDate = days.first;
    final endDate = days.last;
    final dates = <DateTime>[];
    var currentDate = startDate;
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      dates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return _events
        .where((event) => dates.contains(event.startTime.prettyDate()))
        .toList();
  }

  void _showEventBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'All (${_eventsForSelectedDays.totalCountForAll()}) ',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'HRD (${_eventsForSelectedDays.getTotalCountForHR()}) ',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Tech 1 (${_eventsForSelectedDays.getTotalCountForIT()}) ',
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  'Follow up (${_eventsForSelectedDays.getTotalCountForFollowUp()}) ',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _eventsForSelectedDays.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Card(
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      _eventsForSelectedDays[index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      _eventsForSelectedDays[index]
                                          .subtitle
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CircleNumberWidget(
                                        number: _eventsForSelectedDays[index]
                                            .countOfHR),
                                    CircleNumberWidget(
                                        number: _eventsForSelectedDays[index]
                                            .countOfIt),
                                    CircleNumberWidget(
                                        number: _eventsForSelectedDays[index]
                                            .countOfFollowUp),
                                    CircleNumberWidget(
                                        number: _eventsForSelectedDays[index]
                                            .totalCountOfDepartment,isTotal: true,)
                                  ],
                                )
                              ],
                            ), // Adjust for your model
                            // ... other event details
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class Event {
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final int countOfHR;
  final int countOfIt;
  final int countOfFollowUp;

  const Event(this.title, this.startTime, this.endTime, this.countOfHR,
      this.countOfIt, this.countOfFollowUp, this.subtitle);

  int get totalCountOfDepartment {
    return countOfFollowUp + countOfIt + countOfHR;
  }
}

extension DateFormatter on DateTime {
  DateTime prettyDate() {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.parse(formatter.format(this));
  }

  String prettyMonth() {
    final formatter = DateFormat('MMM');
    return formatter.format(this);
  }
}

extension TotalCounts on List<Event> {
  int getTotalCountForHR() {
    int totalCountForHr = 0;
    for (Event element in this) {
      totalCountForHr += element.countOfHR;
    }

    return totalCountForHr;
  }

  int getTotalCountForFollowUp() {
    int totalCountForHr = 0;

    for (Event element in this) {
      totalCountForHr += element.countOfFollowUp;
    }

    return totalCountForHr;
  }

  int getTotalCountForIT() {
    int totalCountForHr = 0;
    for (Event element in this) {
      totalCountForHr += element.countOfIt;
    }

    return totalCountForHr;
  }

  int totalCountForAll() {
    return getTotalCountForFollowUp() +
        getTotalCountForHR() +
        getTotalCountForIT();
  }
}

class CircleNumberWidget extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final bool isTotal;

  const CircleNumberWidget({
    super.key,
    required this.number,
    this.size = 50,
    this.color = Colors.white,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isTotal ?  Colors.black45 : color,
        border: Border.all(
          color: Colors.grey, // Customize grey shade as needed
          width: 2.0, // Adjust border width as desired
        ),

      ),
      child: Center(
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

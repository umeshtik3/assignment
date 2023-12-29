
import 'package:assignment/utils/utils.dart';
import 'package:assignment/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/events.dart';
import '../widgets/month_bottom_modal_sheet.dart';
import '../widgets/week_bottom_modal_sheet.dart';

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
  DateTime? _rangeStartDay;
  DateTime? _rangeEndDay;
  @override
  void initState() {
    super.initState();
    generateRandomEvent(DateTime(1945, 1, 1), DateTime(2050, 1, 31), _events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          CustomTextButton(
              onPressed: () => setState(() {
                    _rangeStartDay = null;
                    _rangeEndDay = null;
                    _selectedDays.clear();
                    _calendarFormat = CalendarFormat.month;
                  }),
              text: 'Month'),
          CustomTextButton(
            onPressed: () => setState(() {
              _rangeStartDay = null;
              _rangeEndDay = null;
              _selectedDays.clear();
              _calendarFormat = CalendarFormat.week;
            }),
            text: 'Week',
          ),
        ],
      ),
      body: Center(
        child: TableCalendar(
          calendarBuilders: const CalendarBuilders(),
          firstDay: DateTime.now().subtract(const Duration(days: (365 * 10))),
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
    if (_calendarFormat == CalendarFormat.week) {
      _selectRangeOfStartAndEndDate(selectedDay, focusedDay);
    } else {
      _selectDateForModalSheet(selectedDay, focusedDay);
    }
  }

  void _selectDateForModalSheet(
      DateTime selectedDay, DateTime focusedDay) {
    _eventsForSelectedDays = _events
        .where(
            (event) => selectedDay.prettyDate() == event.startTime.prettyDate())
        .toList();
    setState(() {
      if (_selectedDays.isNotEmpty) {
        _selectedDays.clear();
      }
      _selectedDays.add(selectedDay);

      _buildMonthModalSheet();

      _focusedDay = focusedDay;
    });
  }

  void _buildMonthModalSheet() {
      showModalBottomSheet(
      context: context,
      builder: (context) {
        return MonthBottomModalSheet(
            eventsForSelectedDays: _eventsForSelectedDays);
      },
    );
  }

  void _selectRangeOfStartAndEndDate(
      DateTime selectedDay, DateTime focusedDay) {
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
        _buildWeekBottomModalSheet();
      }

      _focusedDay = focusedDay;
    });
  }

  void _buildWeekBottomModalSheet() {
     _selectedDays.length == 2
        ? _showWeekBottomModalSheet()
        : () {
            setState(() {
              _rangeStartDay = null;
              _rangeEndDay = null;
            });
          };
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

  void _showWeekBottomModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return WeekBottomModalSheet(
            eventsForSelectedDays: _eventsForSelectedDays);
      },
    );
  }
}

import 'dart:math';

import '../models/events.dart';
import 'package:intl/intl.dart';

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

extension ReadableString on Priority {

 String toStringPriority(){
   switch(this){
     case Priority.mediumPriority:
       return 'Medium Priority';
     case Priority.highPriority:
       return 'High Priority';
     default :
       return 'Unknown';
   }

  }
}

String generateRandomString(int length) {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  final result = String.fromCharCodes(Iterable.generate(
    length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
  return result;
}

List<Event> generateRandomEvent(DateTime startDate, DateTime endDate, List<Event> events) {
  for (var date = startDate;
  date.isBefore(endDate.add(const Duration(days: 1)));
  date = date.add(const Duration(days: 1))) {
    String title = "${date.day}";
    String subtitle = date.prettyMonth();
    events.add(Event(
        title,
        date,
        date.add(const Duration(hours: 1)),
        Random().nextInt(11),
        Random().nextInt(11),
        Random().nextInt(11),
        subtitle,
        PersonalDetails(
          generateRandomString(10),
          generateRandomString(15),
          Random().nextDouble(),
          Random().nextDouble(),
          Priority.highPriority,
          DateTime.now(),
          Random().nextInt(11),
          DateTime.now(),
        )));
  }
  return events;
}
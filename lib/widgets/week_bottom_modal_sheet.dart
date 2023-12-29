import 'package:assignment/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/events.dart';
import '../utils/constants.dart';
import 'circular_number.dart';

class WeekBottomModalSheet extends StatelessWidget {
  const WeekBottomModalSheet({
    super.key,
    required List<Event> eventsForSelectedDays,
  }) : _eventsForSelectedDays = eventsForSelectedDays;

  final List<Event> _eventsForSelectedDays;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '$kAllText (${_eventsForSelectedDays.totalCountForAll()}) ',
              style: textStyleColorBlack,
            ),
            Text(
              '$kHRDText (${_eventsForSelectedDays.getTotalCountForHR()}) ',
              style: textStyleColorBlack,
            ),
            Text(
              '$kTech1Text (${_eventsForSelectedDays.getTotalCountForIT()}) ',
              style: textStyleColorBlack,
            ),
            Text(
              '$kFollowUPText (${_eventsForSelectedDays.getTotalCountForFollowUp()}) ',
              style: textStyleColorBlack,
            ),
          ],
        ),
        Expanded(
          child: Padding(
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    _eventsForSelectedDays[index].title,
                                    style: textStyleFont18Weight600,
                                  ),
                                  Text(
                                    _eventsForSelectedDays[index]
                                        .subtitle
                                        .toUpperCase(),
                                    style: textStyleFont15Weight300,
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleNumberWidget(
                                        text: kHRDText,
                                        number:
                                        _eventsForSelectedDays[index]
                                            .countOfHR),
                                    CircleNumberWidget(
                                        text: kTech1Text,
                                        number:
                                        _eventsForSelectedDays[index]
                                            .countOfIt),
                                    CircleNumberWidget(
                                        text: kFollowUPText,
                                        number:
                                        _eventsForSelectedDays[index]
                                            .countOfFollowUp),
                                    CircleNumberWidget(
                                      text: kTotalText,
                                      number: _eventsForSelectedDays[index]
                                          .totalCountOfDepartment,
                                      isTotal: true,
                                    )
                                  ],
                                ),
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
        ),
      ],
    );
  }
}
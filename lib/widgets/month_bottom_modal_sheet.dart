import 'package:assignment/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/events.dart';
import '../utils/constants.dart';
import 'dialar_icon_widget.dart';

class MonthBottomModalSheet extends StatelessWidget {
  const MonthBottomModalSheet({
    super.key,
    required List<Event> eventsForSelectedDays,
  }) : _eventsForSelectedDays = eventsForSelectedDays;

  final List<Event> _eventsForSelectedDays;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 50,
              color: Colors.grey[200],
              child: TabBar(
                tabs: [
                  Tab(
                      child: Text(
                          '$kAllText (${_eventsForSelectedDays.totalCountForAll()}) ')),
                  Tab(
                      child: Text(
                          '$kHRDText (${_eventsForSelectedDays.getTotalCountForHR()}) ')),
                  Tab(
                      child: Text(
                          '$kTech1Text (${_eventsForSelectedDays.getTotalCountForIT()}) ')),
                  Tab(
                      child: Text(
                          '$kFollowUPText (${_eventsForSelectedDays.getTotalCountForFollowUp()}) ')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content for All tab
                  ListView.builder(
                    itemCount: _eventsForSelectedDays
                        .length, // Replace with your actual events
                    itemBuilder: (context, index) {
                      return Card(
                          elevation: 8,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _eventsForSelectedDays[
                                              index]
                                                  .personalDetails
                                                  .fullName,
                                              style:
                                              textStyleFont14Weight600,
                                            ),
                                            Text(
                                                '$kIdText ${_eventsForSelectedDays[index].personalDetails.pID}'),
                                          ],
                                        ),
                                      ),
                                      const DialerIcon(),
                                    ],
                                  ),
                                  Text(
                                    '$kOffered ${_eventsForSelectedDays[index].personalDetails.offeredAmount}',
                                    style: textStyleFont14Weight600,
                                  ),
                                  Text(
                                    '$kCurrent ${_eventsForSelectedDays[index].personalDetails.offeredAmount}',
                                    style: textStyleFont14Weight600,
                                  ),
                                  Text(
                                    _eventsForSelectedDays[index]
                                        .personalDetails
                                        .priority
                                        .toStringPriority(),
                                    style: textStyleFont14Weight600,
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            kDueDate,
                                          ),
                                          Text(
                                            '${_eventsForSelectedDays[index].personalDetails.dueDate.prettyDate()}',
                                            style:
                                            textStyleFont14Weight600,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            kLevel,
                                          ),
                                          Text(
                                            '${_eventsForSelectedDays[index].personalDetails.level}',
                                            style:
                                            textStyleFont14Weight600,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            kDaysLeft,
                                          ),
                                          Text(
                                            '${_eventsForSelectedDays[index].personalDetails.daysLeft.prettyDate()}',
                                            style:
                                            textStyleFont14Weight600,
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              // ... other event details
                            ),
                          ));
                    },
                  ),
                  // Content for HRD tab
                  // ...
                  // Content for Tech 1 tab
                  // ...
                  // Content for Follow Up tab
                  // ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
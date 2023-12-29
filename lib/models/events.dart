class Event {
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final int countOfHR;
  final int countOfIt;
  final int countOfFollowUp;
  final PersonalDetails personalDetails;

  const Event(this.title, this.startTime, this.endTime, this.countOfHR,
      this.countOfIt, this.countOfFollowUp, this.subtitle,
      this.personalDetails,
      );

  int get totalCountOfDepartment {
    return countOfFollowUp + countOfIt + countOfHR;
  }
}

enum Priority { mediumPriority, highPriority }

class PersonalDetails {
  final String fullName;
  final String pID;
  final double offeredAmount;
  final double currentAmount;
  final Priority priority;
  final DateTime dueDate;
  final int level;
  final DateTime daysLeft;

  const PersonalDetails(
      this.fullName,
      this.pID,
      this.offeredAmount,
      this.currentAmount,
      this.priority,
      this.dueDate,
      this.level,
      this.daysLeft);
}

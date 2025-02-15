enum Timer {
  none(0, "No timer"),
  fiveMins(5, "5 Minutes"),
  fifteenMins(15, "15 Minutes"),
  thirtyMins(30, "30 Minutes"),
  oneHour(60, "1 Hour"),
  twoHours(120, "2 Hours"),
  threeHours(180, "3 Hours"),
  fiveHours(300, "5 Hours");

  const Timer(this.value, this.name);
  final int value;
  final String name;
}

Timer intToTimer(int timer) {
  if (timer <= 0) {
    return Timer.none;
  } else if (timer <= 5) {
    return Timer.fiveMins;
  } else if (timer <= 15) {
    return Timer.fifteenMins;
  } else if (timer <= 30) {
    return Timer.thirtyMins;
  } else if (timer <= 60) {
    return Timer.oneHour;
  } else if (timer <= 120) {
    return Timer.twoHours;
  } else if (timer <= 180) {
    return Timer.threeHours;
  } else {
    return Timer.fiveHours;
  }
}

class TimerModel {
  final String name;
  final Timer timer;

  TimerModel({required this.timer}) : name = timer.name;
}

List<TimerModel> getList() {
  List<TimerModel> list = [];
  for (Timer timerValue in Timer.values) {
    list.add(TimerModel(timer: timerValue));
  }
  return list;
}

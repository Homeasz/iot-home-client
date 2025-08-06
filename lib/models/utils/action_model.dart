enum Action {
  turnOff(false),
  turnOn(true);

  const Action(this.value);
  final bool value;
}

class ActionModel {
  final String name;
  final Action action;

  ActionModel({required this.action})
      : name = (action == Action.turnOn) ? "Turn On" : "Turn Off";
}

List<ActionModel> getList() {
  return [
    ActionModel(action: Action.turnOff),
    ActionModel(action: Action.turnOn)
  ];
}

import 'package:flutter/material.dart';
import 'package:homeasz/models/switch_model.dart';
import 'package:homeasz/providers/data_provider.dart';
import 'package:provider/provider.dart';

class SwitchTile extends StatelessWidget {
  const SwitchTile({
    super.key,
    required this.index,
    required this.switchName,
    required this.switchState,
  });

  final int index;
  final String switchName;
  final bool switchState;

  void _toggleSwitch(int switchIndex, DataProvider dataProvider) async {
    await dataProvider.toggleSwitch(switchIndex.toString(), !switchState);
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    return Card(
      child: ListTile(
        onTap: () => _toggleSwitch(index, dataProvider),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 8),
          child: Center(
            child: Text(
              switchName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineSmall!.color,
              ),
            ),
          ),
        ),
        enabled: true,
        tileColor: Theme.of(context).cardColor,
        trailing: Icon(
          switchState ? Icons.lightbulb : Icons.lightbulb_outline,
          color: switchState ? Colors.yellow : Colors.grey,
        ),
      ),
    );
  }
}

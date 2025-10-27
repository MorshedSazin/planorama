import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'data/app_data.dart';
import 'utils/day_utils.dart';

const String androidWidgetProvider = 'RoutineWidgetProvider';
const String iOSWidgetName = 'RoutineWidget';

@pragma('vm:entry-point')
Future<void> updateWidget() async {
  final appData = AppData();
  final routines = await appData.loadRoutines();

  await HomeWidget.saveWidgetData<String>('routines', jsonEncode(routines));
  await HomeWidget.updateWidget(
    name: iOSWidgetName,
    androidName: androidWidgetProvider,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine Widget',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      home: const RoutineHome(),
    );
  }
}

class RoutineHome extends StatefulWidget {
  const RoutineHome({super.key});

  @override
  State<RoutineHome> createState() => _RoutineHomeState();
}

class _RoutineHomeState extends State<RoutineHome> {
  final AppData _appData = AppData();
  Map<String, List<String>> _routines = {};
  String _selectedDay = weekdayToName(DateTime.now().weekday);

  @override
  void initState() {
    super.initState();
    _loadRoutines();
    updateWidget();
  }

  Future<void> _loadRoutines() async {
    final routines = await _appData.loadRoutines();
    setState(() {
      _routines = routines;
    });
  }

  Future<void> _addRoutine(String routine) async {
    await _appData.addRoutine(_selectedDay, routine);
    _loadRoutines();
    updateWidget();
  }

  Future<void> _removeRoutine(String routine) async {
    await _appData.removeRoutine(_selectedDay, routine);
    _loadRoutines();
    updateWidget();
  }

  Future<void> _updateRoutine(String oldRoutine, String newRoutine) async {
    await _appData.updateRoutine(_selectedDay, oldRoutine, newRoutine);
    _loadRoutines();
    updateWidget();
  }

  void _showAddRoutineDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Routine', style: Theme.of(context).textTheme.headlineSmall),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Routine'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _addRoutine(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditRoutineDialog(String oldRoutine) {
    final controller = TextEditingController(text: oldRoutine);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Routine', style: Theme.of(context).textTheme.headlineSmall),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Routine'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _updateRoutine(oldRoutine, controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routinesForDay = _routines[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Routine',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedDay,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedDay = newValue;
                });
              }
            },
            items: weekOrder.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value, style: Theme.of(context).textTheme.bodyLarge));
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: ListView.builder(
          itemCount: routinesForDay.length,
          itemBuilder: (context, index) {
            final routine = routinesForDay[index];
            // ignore: deprecated_member_use
            final color = Colors.blue.withOpacity(0.1 * (index % 10));
            var fittedBox = FittedBox(
              child: Text(
                routine,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
            return Card(
              color: color,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: ListTile(
                  title: fittedBox,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditRoutineDialog(routine),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeRoutine(routine),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRoutineDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

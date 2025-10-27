import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../main.dart';

class AppData {
  static const String _fileName = 'routines.json';

  final Map<String, List<String>> _defaultRoutines = {
    'Saturday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Commute / Light review → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '🕙 Class | 10:40 am – 12:45 pm | 📚 CSC 440 (B) | Comlab3',
      '🍽 Namaz / Lunch → 12:45 pm – 2:15 pm',
      '🕑 Class | 2:15 pm – 3:15 pm | 📚 CSC 215 (D) | 505',
      '📖 Review → CSC 215',
      '🕓 Class | 4:25 pm – 5:25 pm | 📚 ART 202 (E) | 903',
      '🧠 University → Home → 5:25 pm – 6:00 pm',
      '🛌 Nap / Rest → 6:00 pm – 8:00 pm',
      '💻 Flutter → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
    'Monday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Light review → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '🕙 Class | 10:40 am – 11:40 am | 📚 CSC 439 (B) | 1006',
      '🍽 Namaz / Lunch → 11:45 am – 1:45 pm',
      '📚 Library / University Study → 2:00 pm – 4:00 pm (CSE 4309)',
      '🕓 Class | 4:25 pm – 5:25 pm | 📚 CSE 4309 (C) | 503',
      '🧠 University → Home → 5:25 pm – 6:00 pm',
      '🛌 Nap / Rest → 6:00 pm – 8:00 pm',
      '💻 Flutter → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
    'Tuesday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Light review → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '🕙 Class | 10:40 am – 11:40 am | 📚 CSC 439 (B) | 708',
      '🍽 Namaz / Lunch → 11:45 am – 1:45 pm',
      '🧠 Problem Solving / Library → 2:00 pm – 4:00 pm',
      '🕓 Class | 4:25 pm – 5:25 pm | 📚 CSE 4309 (C) | 520',
      '🧠 University → Home → 5:25 pm – 6:00 pm',
      '🛌 Nap / Rest → 6:00 pm – 8:00 pm',
      '💻 Flutter Project Work → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
    'Wednesday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Light review → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '🕙 Class | 10:40 am – 11:40 am | 📚 CSC 439 (B) | 708',
      '🍽 Namaz / Lunch → 11:45 am – 1:45 pm',
      '🧠 Problem Solving / Library → 2:00 pm – 4:00 pm',
      '🕓 Class | 4:25 pm – 5:25 pm | 📚 CSE 4309 (C) | 508',
      '🧠 University → Home → 5:25 pm – 6:00 pm',
      '🛌 Nap / Rest → 6:00 pm – 8:00 pm',
      '💻 Flutter Backend / API → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
    'Thursday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Relax → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '💻 Flutter (Deep Learning / Features) → 10:40 am – 12:40 pm',
      '🍽 Namaz / Lunch → 12:45 pm – 2:15 pm',
      '🛌 Nap / Rest → 2:20 pm – 4:20 pm',
      '⏸ Hang Out → 4:25 pm – 6:00 pm',
      '🧠 Problem Solving → 6:00 pm – 8:00 pm',
      '🛡 Cyber Security / CTF → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
    'Friday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Relax → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '💻 Flutter (Project Sprint) → 10:40 am – 12:40 pm',
      '🍽 Namaz / Lunch → 12:45 pm – 2:15 pm',
      '🛌 Nap / Rest → 2:20 pm – 4:20 pm',
      '⏸ Hang Out → 4:25 pm – 6:00 pm',
      '🧠 Problem Solving → 6:00 pm – 8:00 pm',
      '🛡 Cyber Security / CTF → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
    'Sunday': [
      '🌅 Morning run + freshen up → 6:30 am – 7:30 am',
      '🍽 Light Breakfast → 7:30 am – 8:30 am',
      '⏸ Free / Relax → 8:30 am – 10:00 am',
      '🍽 Breakfast → 10:00 am – 10:40 am',
      '💻 Flutter (Capstone Work) → 10:40 am – 12:40 pm',
      '🍽 Namaz / Lunch → 12:45 pm – 2:15 pm',
      '🛌 Nap / Rest → 2:20 pm – 4:20 pm',
      '⏸ Hang Out → 4:25 pm – 6:00 pm',
      '🧠 Problem Solving → 6:00 pm – 8:00 pm',
      '🛡 Cyber Security / CTF → 8:00 pm – 10:00 pm',
      '🍽 Dinner + Rest → 10:00 pm – 11:00 pm',
      '🎮 Gaming → 11:00 pm – 12:00 am',
    ],
  };

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<Map<String, List<String>>> loadRoutines() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final json = jsonDecode(contents) as Map<String, dynamic>;
        return json.map((key, value) => MapEntry(key, List<String>.from(value)));
      } else {
        await saveRoutines(_defaultRoutines);
        return _defaultRoutines;
      }
    } catch (e) {
      print('Error loading routines: $e');
    }
    return _defaultRoutines;
  }

  Future<void> saveRoutines(Map<String, List<String>> routines) async {
    try {
      final file = await _localFile;
      final json = jsonEncode(routines);
      await file.writeAsString(json);
      await updateWidget();
    } catch (e) {
      print('Error saving routines: $e');
    }
  }

  Future<void> addRoutine(String day, String routine) async {
    final routines = await loadRoutines();
    routines.putIfAbsent(day, () => []).add(routine);
    await saveRoutines(routines);
  }

  Future<void> removeRoutine(String day, String routine) async {
    final routines = await loadRoutines();
    if (routines.containsKey(day)) {
      routines[day]!.remove(routine);
      await saveRoutines(routines);
    }
  }

  Future<void> updateRoutine(
      String day, String oldRoutine, String newRoutine) async {
    final routines = await loadRoutines();
    if (routines.containsKey(day)) {
      final index = routines[day]!.indexOf(oldRoutine);
      if (index != -1) {
        routines[day]![index] = newRoutine;
        await saveRoutines(routines);
      }
    }
  }
}

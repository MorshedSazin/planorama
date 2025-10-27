import 'package:flutter/material.dart';

class RoutineWidget extends StatelessWidget {
  final String day;
  final List<String> routine;

  const RoutineWidget({super.key, required this.day, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsetsGeometry.all(15)),
          Text(
            day,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          if (routine.isEmpty)
            const Text(
              'No routine for today.',
              style: TextStyle(color: Colors.white),
            )
          else
            Column(
              children: routine.asMap().entries.map((entry) {
                final item = entry.value;
                return Card(
                  color: Colors.transparent,
                  child: ListTile(
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(item, style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

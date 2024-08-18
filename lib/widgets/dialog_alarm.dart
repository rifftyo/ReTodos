import 'package:flutter/material.dart';

Future<void> showAlarmDialog(BuildContext context) async {
  final TimeOfDay? pickedTime =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());

  if (pickedTime != null) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Setel Pengingat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$pickedTime.format(context)"),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: "Jangan",
                  items: <String>['Jangan', 'Setiap Hari', 'Setiap Minggu']
                      .map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Oke')),
                  ],
                ),
              ],
            ),
          );
        });
  } else {
    Navigator.pop(context);
  }
}

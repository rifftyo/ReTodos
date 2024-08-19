import 'package:flutter/material.dart';

class TimePickerProvider extends ChangeNotifier {
  DateTime? _selectedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

  void selectDateTime(BuildContext context) async {
    // Pilih Tanggal
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      // Pilih Waktu
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        notifyListeners();
      }
    }
  }

  void resetSelectedDateTime() {
    _selectedDateTime = null;
    notifyListeners();
  }
}

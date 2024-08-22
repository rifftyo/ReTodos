import 'package:flutter/material.dart';

class TimePickerProvider extends ChangeNotifier {
  DateTime? _selectedDateTime;

  DateTime? get selectedDateTime => _selectedDateTime;

  void selectDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();

    // Pilih Tanggal
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime != null && _selectedDateTime!.isAfter(now)
          ? _selectedDateTime
          : now,
      firstDate: now,
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      // Pilih Waktu
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            _selectedDateTime != null && _selectedDateTime!.isAfter(now)
                ? TimeOfDay.fromDateTime(_selectedDateTime!)
                : TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (selectedDateTime.isAfter(now)) {
          _selectedDateTime = selectedDateTime;
          notifyListeners();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Waktu yang dipilih sudah berlalu.')),
          );
        }
      }
    }
  }

  void resetSelectedDateTime() {
    _selectedDateTime = null;
    notifyListeners();
  }
}

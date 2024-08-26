import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';

class EndModeSelector extends StatefulWidget {
  final String selectedEndMode;
  final DateTime selectedDate;
  final int days;
  const EndModeSelector(
      {super.key,
      required this.selectedEndMode,
      required this.selectedDate,
      required this.days});

  @override
  _EndModeSelectorState createState() => _EndModeSelectorState();
}

class _EndModeSelectorState extends State<EndModeSelector> {
  String? _selectedEndMode;
  DateTime? _selectedDate;
  int? _days;
  @override
  void initState() {
    super.initState();
    _selectedEndMode = widget.selectedEndMode;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildModeContainer('Off', 'assets/off_icon.png'),
            _buildModeContainer('Date', 'assets/date_icon.png'),
            _buildModeContainer('Days', 'assets/days_icon.png'),
          ],
        ),
        if (_selectedEndMode == 'Date')
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                const Text('Select Date:'),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(_selectedDate == null
                      ? 'Pick Date'
                      : _selectedDate!.toLocal().toShortDateString()),
                ),
              ],
            ),
          ),
        if (_selectedEndMode == 'Days')
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                const Text('Enter Days:'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Number of days',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _days = int.tryParse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildModeContainer(String mode, String iconPath) {
    bool isSelected = _selectedEndMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEndMode = mode;
        });
      },
      child: CustomContainer(
        width: 120,
        height: 60,
        color: isSelected ? Colors.blue.withOpacity(0.6) : null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              TextDef(
                mode,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension DateFormatting on DateTime {
  String toShortDateString() {
    return "$day/$month/$year";
  }
}

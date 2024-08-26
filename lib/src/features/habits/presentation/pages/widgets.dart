import 'package:flutter/material.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/update_value.dart';
import 'package:provider/provider.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({
    super.key,
  });

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color? _selectedColor;
  final List<Color> availableColors = [
    const Color.fromARGB(255, 252, 235, 233),
    const Color.fromARGB(255, 211, 248, 212),
    const Color.fromARGB(255, 221, 236, 249),
    const Color.fromARGB(255, 243, 240, 210),
    const Color.fromARGB(255, 238, 200, 245),
    const Color.fromARGB(255, 249, 233, 209),
    const Color.fromARGB(255, 199, 254, 249),
    const Color.fromARGB(255, 250, 211, 224),
  ];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: availableColors.map((color) {
        return GestureDetector(
          onTap: () {
            context.read<HUProvider>().updateColor(color.toString());
          },
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: context.watch<HUProvider>().habitData.color ==
                      color.toString()
                  ? Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      width: 2.0)
                  : null,
            ),
            width: 40,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              width: 40,
              height: 40,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class IconSelector extends StatelessWidget {
  final List<String> availableIcons;

  const IconSelector({
    super.key,
    required this.availableIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: availableIcons.map((icon) {
        return GestureDetector(
          onTap: () {
            context.read<HUProvider>().updateIcon(icon);
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    Theme.of(context).splashColor,
                    Colors.transparent,
                  ],
                  stops: const [0.3, 1.0],
                ),
                image: DecorationImage(image: AssetImage(icon)),
                borderRadius: BorderRadius.circular(20),
                border: context.watch<HUProvider>().habitData.icon == icon
                    ? Border.all(
                        color:
                            Theme.of(context).indicatorColor.withOpacity(0.5),
                        width: 3.0)
                    : null,
              ),
              width: 80,
              height: 80,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DaySelector extends StatelessWidget {
  DaySelector({
    super.key,
  });

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void _toggleDaySelection(String day) {}

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.map((day) {
        bool isSelected =
            context.watch<HUProvider>().habitData.days.contains(day);
        return GestureDetector(
          onTap: () {
            isSelected
                ? context.read<HUProvider>().deleteDays(day)
                : context.read<HUProvider>().updateDays(day);
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              day.substring(0, 1),
              style: TextStyle(
                color: isSelected ? Theme.of(context).hoverColor : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class EndSelecter extends StatefulWidget {
  final List<String> ends;
  final void Function(List<String>) onEndSelectSelected;

  const EndSelecter({
    super.key,
    required this.ends,
    required this.onEndSelectSelected,
  });

  @override
  _EndSelecterState createState() => _EndSelecterState();
}

class _EndSelecterState extends State<EndSelecter> {
  final List<String> _selectedDays = [];

  void _toggleDaySelection(String end) {
    setState(() {
      if (_selectedDays.contains(end)) {
        _selectedDays.remove(end);
      } else {
        _selectedDays.add(end);
      }
    });

    widget.onEndSelectSelected(_selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.ends.map((day) {
        bool isSelected = _selectedDays.contains(day);
        return GestureDetector(
          onTap: () => _toggleDaySelection(day),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

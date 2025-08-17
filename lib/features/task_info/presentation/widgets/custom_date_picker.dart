import 'package:flutter/material.dart';
import 'package:fire_todo/features/main/index.dart';

class CustomDatePicker {
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? title,
    Color? primaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    Color? selectedColor,
    Color? todayColor,
  }) async {
    return await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor ?? const Color(0xFF0E0E0E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomDatePickerWidget(
              initialDate: initialDate,
              firstDate: firstDate ?? DateTime(2000),
              lastDate: lastDate ?? DateTime(2100),
              title: title,
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              textColor: textColor,
              selectedColor: selectedColor,
              todayColor: todayColor,
              onDateSelected: (date) {
                Navigator.of(context).pop(date);
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}

class CustomDatePickerWidget extends StatefulWidget {
  const CustomDatePickerWidget({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.title,
    this.primaryColor,
    this.backgroundColor,
    this.surfaceColor,
    this.textColor,
    this.selectedColor,
    this.todayColor,
    required this.onDateSelected,
    this.onCancel,
  });

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? title;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? surfaceColor;
  final Color? textColor;
  final Color? selectedColor;
  final Color? todayColor;
  final Function(DateTime) onDateSelected;
  final VoidCallback? onCancel;

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  late DateTime currentMonth;
  DateTime? selectedDate;

  // Default colors
  Color get primaryColor => widget.primaryColor ?? const Color(0xFFF8CD7A);
  Color get backgroundColor =>
      widget.backgroundColor ?? const Color(0xFF0E0E0E);
  Color get surfaceColor => widget.surfaceColor ?? const Color(0xFF292929);
  Color get textColor => widget.textColor ?? const Color(0xFFFFFFFF);
  Color get selectedColor => widget.selectedColor ?? const Color(0xFF9B60F7);
  Color get todayColor => widget.todayColor ?? const Color(0xFF3A3A3A);

  @override
  void initState() {
    super.initState();
    currentMonth = widget.initialDate ?? DateTime.now();
    selectedDate = widget.initialDate;
  }

  void _previousMonth() {
    final newMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    if (newMonth.isAfter(
      DateTime(widget.firstDate.year, widget.firstDate.month - 1),
    )) {
      setState(() {
        currentMonth = newMonth;
      });
    }
  }

  void _nextMonth() {
    final newMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    if (newMonth.isBefore(
      DateTime(widget.lastDate.year, widget.lastDate.month + 1),
    )) {
      setState(() {
        currentMonth = newMonth;
      });
    }
  }

  List<String> get _weekDays => [
    AppStrings.monday,
    AppStrings.tuesday,
    AppStrings.wednesday,
    AppStrings.thursday,
    AppStrings.friday,
    AppStrings.saturday,
    AppStrings.sunday,
  ];

  List<String> get _monthNames => [
    AppStrings.january,
    AppStrings.february,
    AppStrings.march,
    AppStrings.april,
    AppStrings.may,
    AppStrings.june,
    AppStrings.july,
    AppStrings.august,
    AppStrings.september,
    AppStrings.october,
    AppStrings.november,
    AppStrings.december,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        if (widget.title != null) ...[
          GlobalText(
            widget.title!,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
            useTranslation: false,
          ),
          const SizedBox(height: 16),
        ],

        // Month navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_left, color: textColor, size: 20),
              ),
            ),
            GlobalText(
              '${_monthNames[currentMonth.month - 1].tr()} ${currentMonth.year}',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
              useTranslation: false,
            ),
            IconButton(
              onPressed: _nextMonth,
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right, color: textColor, size: 20),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Week days header
        Row(
          children: _weekDays.asMap().entries.map((entry) {
            int index = entry.key;
            String day = entry.value;

            return Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: GlobalText(
                  day,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Calendar days
        ..._buildCalendarWeeks(),

        const SizedBox(height: 20),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.onCancel != null)
              TextButton(
                onPressed: widget.onCancel,
                child: GlobalText(
                  AppStrings.cancel,
                  fontSize: 16,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ElevatedButton(
              onPressed: selectedDate != null
                  ? () => widget.onDateSelected(selectedDate!)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: GlobalText(
                AppStrings.select,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: backgroundColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildCalendarWeeks() {
    List<Widget> weeks = [];

    DateTime firstDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );
    DateTime lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );

    int firstWeekday = firstDayOfMonth.weekday;
    DateTime startDate = firstDayOfMonth.subtract(
      Duration(days: firstWeekday - 1),
    );

    DateTime currentDate = startDate;

    while (currentDate.isBefore(lastDayOfMonth) ||
        currentDate.month == currentMonth.month) {
      List<Widget> weekDays = [];

      for (int i = 0; i < 7; i++) {
        bool isCurrentMonth = currentDate.month == currentMonth.month;
        bool isSelected =
            selectedDate != null &&
            selectedDate!.year == currentDate.year &&
            selectedDate!.month == currentDate.month &&
            selectedDate!.day == currentDate.day;
        bool isToday =
            DateTime.now().year == currentDate.year &&
            DateTime.now().month == currentDate.month &&
            DateTime.now().day == currentDate.day;

        bool isEnabled =
            isCurrentMonth &&
            currentDate.isAfter(
              widget.firstDate.subtract(const Duration(days: 1)),
            ) &&
            currentDate.isBefore(widget.lastDate.add(const Duration(days: 1)));

        DateTime dayToAdd = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

        weekDays.add(
          Expanded(
            child: GestureDetector(
              onTap: isEnabled
                  ? () {
                      setState(() {
                        selectedDate = dayToAdd;
                      });
                    }
                  : null,
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor
                      : isToday && isCurrentMonth
                      ? todayColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isSelected
                      ? Border.all(color: primaryColor, width: 1)
                      : null,
                ),
                alignment: Alignment.center,
                child: GlobalText(
                  '${currentDate.day}',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: !isEnabled
                      ? textColor.withOpacity(0.3)
                      : isSelected
                      ? backgroundColor
                      : textColor,
                  useTranslation: false,
                ),
              ),
            ),
          ),
        );

        currentDate = currentDate.add(const Duration(days: 1));
      }

      weeks.add(Row(children: weekDays));

      if (currentDate.month != currentMonth.month && weeks.length >= 4) {
        break;
      }
    }

    return weeks;
  }
}

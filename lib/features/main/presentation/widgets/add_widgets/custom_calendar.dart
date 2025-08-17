import 'package:flutter/material.dart';
import 'package:fire_todo/features/main/index.dart';

class CustomCalendarWidget extends StatefulWidget {
  const CustomCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  @override
  State<CustomCalendarWidget> createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime currentMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    currentMonth = widget.selectedDate ?? DateTime.now();
    selectedDate = widget.selectedDate;
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.grey700, // grey700
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.white, // white
                  size: 20,
                ),
              ),
            ),
            GlobalText(
              '${_monthNames[currentMonth.month - 1].tr()} ${currentMonth.year}',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
              useTranslation: false,
            ),
            IconButton(
              onPressed: _nextMonth,
              icon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.grey700, // grey700
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          children: _weekDays.asMap().entries.map((entry) {
            int index = entry.key;
            String day = entry.value;
            bool isThursday = index == 3;

            return Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isThursday ? AppColors.gold : const Color(0xFF292929),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: GlobalText(
                  day,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isThursday ? AppColors.background : AppColors.white,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        ..._buildCalendarWeeks(),
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

        DateTime dayToAdd = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

        weekDays.add(
          Expanded(
            child: GestureDetector(
              onTap: isCurrentMonth
                  ? () {
                      setState(() {
                        selectedDate = dayToAdd;
                      });
                      widget.onDateSelected(dayToAdd);
                    }
                  : null,
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.purple
                      : isToday && isCurrentMonth
                      ? AppColors.grey700
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isSelected
                      ? Border.all(color: AppColors.gold, width: 1)
                      : null,
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GlobalText(
                      '${currentDate.day}',
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: !isCurrentMonth
                          ? AppColors
                                .grey400 // grey400
                          : AppColors.white,
                      useTranslation: false,
                    ),
                    if (isCurrentMonth &&
                        currentDate.day % 3 == 0 &&
                        !isSelected)
                      Positioned(
                        bottom: 8,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
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

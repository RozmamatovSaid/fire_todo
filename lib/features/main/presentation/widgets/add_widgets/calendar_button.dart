import 'package:flutter/material.dart';
import 'package:fire_todo/features/main/index.dart';
import '../../../../task_info/presentation/widgets/custom_date_picker.dart';
import '../../../../task_info/presentation/widgets/custom_time_picker.dart';

class CalendarButton extends StatefulWidget {
  const CalendarButton({
    super.key,
    required this.onDateTimeSelected,
    required this.onNotificationSelected,
    this.primaryColor,
    this.backgroundColor,
    this.surfaceColor,
    this.textColor,
  });

  final Function(DateTime?) onDateTimeSelected;
  final Function(bool) onNotificationSelected;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? surfaceColor;
  final Color? textColor;

  @override
  State<CalendarButton> createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool notificationEnabled = false;

  // Default colors
  Color get primaryColor => widget.primaryColor ?? AppColors.gold;
  Color get backgroundColor => widget.backgroundColor ?? AppColors.background;
  Color get surfaceColor => widget.surfaceColor ?? AppColors.darkGrey;
  Color get textColor => widget.textColor ?? AppColors.white;

  Future<void> _showCustomCalendar(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final DateTime? pickedDate = await CustomDatePicker.show(
      context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      title: AppStrings.selectDate.tr(),
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      surfaceColor: surfaceColor,
      textColor: textColor,
      selectedColor: AppColors.purple,
      todayColor: AppColors.grey500,
    );

    if (pickedDate != null && mounted) {
      setState(() {
        selectedDate = pickedDate;
      });

      await _showTimePicker(context);
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await CustomTimePicker.show(
      context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      title: AppStrings.selectTime.tr(),
      primaryColor: primaryColor,
      backgroundColor: AppColors.darkGrey,
      surfaceColor: AppColors.grey700,
      textColor: textColor,
      use24HourFormat: false,
    );

    if (pickedTime != null && selectedDate != null && mounted) {
      setState(() {
        selectedTime = pickedTime;
        notificationEnabled = true;
      });

      final combinedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      widget.onDateTimeSelected(combinedDateTime);
      widget.onNotificationSelected(true);
    } else if (pickedTime == null) {
      setState(() {
        selectedDate = null;
        selectedTime = null;
        notificationEnabled = false;
      });

      widget.onDateTimeSelected(null);
      widget.onNotificationSelected(false);
    }
  }

  void _clearSelection() {
    setState(() {
      selectedDate = null;
      selectedTime = null;
      notificationEnabled = false;
    });

    widget.onDateTimeSelected(null);
    widget.onNotificationSelected(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCustomCalendar(context),
      onLongPress: selectedDate != null || selectedTime != null
          ? _clearSelection
          : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedDate != null || selectedTime != null
              ? primaryColor.withOpacity(0.3)
              : surfaceColor,
          borderRadius: BorderRadius.circular(50),
          border: notificationEnabled
              ? Border.all(color: primaryColor, width: 1)
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalImage(
              AppAssets.calendar,
              color: selectedDate != null ? primaryColor : textColor,
            ),
            if (selectedDate != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.access_time,
                color: selectedTime != null
                    ? primaryColor
                    : textColor.withOpacity(0.7),
                size: 16,
              ),
            ],
            if (notificationEnabled) ...[
              const SizedBox(width: 4),
              Icon(Icons.notifications_active, color: primaryColor, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}

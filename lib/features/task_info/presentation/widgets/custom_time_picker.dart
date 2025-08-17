import 'package:flutter/material.dart';
import 'package:fire_todo/features/main/index.dart';

class CustomTimePicker {
  static Future<TimeOfDay?> show(
    BuildContext context, {
    TimeOfDay? initialTime,
    String? title,
    Color? primaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    bool use24HourFormat = false,
  }) async {
    return await showModalBottomSheet<TimeOfDay>(
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
              color: backgroundColor ?? const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomTimePickerWidget(
              initialTime: initialTime ?? TimeOfDay.now(),
              title: title ?? AppStrings.selectTime.tr(),
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
              surfaceColor: surfaceColor,
              textColor: textColor,
              use24HourFormat: use24HourFormat,
              onTimeSelected: (time) {
                Navigator.of(context).pop(time);
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

class CustomTimePickerWidget extends StatefulWidget {
  const CustomTimePickerWidget({
    super.key,
    required this.initialTime,
    this.title = 'Select Time',
    this.primaryColor,
    this.backgroundColor,
    this.surfaceColor,
    this.textColor,
    this.use24HourFormat = false,
    required this.onTimeSelected,
    this.onCancel,
  });

  final TimeOfDay initialTime;
  final String title;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? surfaceColor;
  final Color? textColor;
  final bool use24HourFormat;
  final Function(TimeOfDay) onTimeSelected;
  final VoidCallback? onCancel;

  @override
  State<CustomTimePickerWidget> createState() => _CustomTimePickerWidgetState();
}

class _CustomTimePickerWidgetState extends State<CustomTimePickerWidget> {
  late TimeOfDay selectedTime;

  // Default colors
  Color get primaryColor =>
      widget.primaryColor ?? const Color(0xFFF8CD7A); // AppColors.gold
  Color get backgroundColor =>
      widget.backgroundColor ?? const Color(0xFF191919); // AppColors.darkGrey
  Color get surfaceColor =>
      widget.surfaceColor ?? const Color(0xFF292929); // AppColors.grey700
  Color get textColor =>
      widget.textColor ?? const Color(0xFFFFFFFF); // AppColors.white

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        GlobalText(
          widget.title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
          useTranslation: false,
        ),

        const SizedBox(height: 20),

        // Time display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GlobalText(
            _formatTime(selectedTime),
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
            useTranslation: false,
          ),
        ),

        const SizedBox(height: 24),

        // Custom time picker wheels
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Hours
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GlobalText(
                        AppStrings.hour,
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 40,
                        perspective: 0.005,
                        diameterRatio: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        controller: FixedExtentScrollController(
                          initialItem: widget.use24HourFormat
                              ? selectedTime.hour
                              : (selectedTime.hourOfPeriod == 0
                                    ? 11
                                    : selectedTime.hourOfPeriod - 1),
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            if (widget.use24HourFormat) {
                              selectedTime = selectedTime.replacing(
                                hour: index,
                              );
                            } else {
                              int hour = index + 1;
                              if (hour == 12) hour = 0;
                              if (selectedTime.period == DayPeriod.pm)
                                hour += 12;
                              selectedTime = selectedTime.replacing(hour: hour);
                            }
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: widget.use24HourFormat ? 24 : 12,
                          builder: (context, index) {
                            final hour = widget.use24HourFormat
                                ? index
                                : index + 1;
                            final currentHour = widget.use24HourFormat
                                ? selectedTime.hour
                                : (selectedTime.hourOfPeriod == 0
                                      ? 12
                                      : selectedTime.hourOfPeriod);
                            final isSelected = currentHour == hour;
                            return Container(
                              alignment: Alignment.center,
                              child: GlobalText(
                                hour.toString().padLeft(2, '0'),
                                fontSize: isSelected ? 20 : 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? primaryColor
                                    : textColor.withOpacity(0.7),
                                useTranslation: false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Separator
              GlobalText(
                ':',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
                useTranslation: false,
              ),

              // Minutes
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GlobalText(
                        AppStrings.minute,
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        itemExtent: 40,
                        perspective: 0.005,
                        diameterRatio: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        controller: FixedExtentScrollController(
                          initialItem: selectedTime.minute,
                        ),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedTime = selectedTime.replacing(
                              minute: index,
                            );
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 60,
                          builder: (context, index) {
                            final isSelected = selectedTime.minute == index;
                            return Container(
                              alignment: Alignment.center,
                              child: GlobalText(
                                index.toString().padLeft(2, '0'),
                                fontSize: isSelected ? 20 : 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? primaryColor
                                    : textColor.withOpacity(0.7),
                                useTranslation: false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // AM/PM for 12-hour format
              if (!widget.use24HourFormat) ...[
                const SizedBox(width: 10),
                SizedBox(
                  width: 60,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlobalText(
                          AppStrings.period,
                          fontSize: 12,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          perspective: 0.005,
                          diameterRatio: 1.2,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                            initialItem: selectedTime.period == DayPeriod.am
                                ? 0
                                : 1,
                          ),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              final newPeriod = index == 0
                                  ? DayPeriod.am
                                  : DayPeriod.pm;
                              int hour = selectedTime.hourOfPeriod;
                              if (hour == 0) hour = 12;
                              if (newPeriod == DayPeriod.pm && hour != 12) {
                                hour += 12;
                              } else if (newPeriod == DayPeriod.am &&
                                  hour == 12) {
                                hour = 0;
                              } else if (newPeriod == DayPeriod.am &&
                                  hour > 12) {
                                hour -= 12;
                              }
                              selectedTime = TimeOfDay(
                                hour: hour,
                                minute: selectedTime.minute,
                              );
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 2,
                            builder: (context, index) {
                              final period = index == 0 ? 'AM' : 'PM';
                              final isSelected =
                                  (selectedTime.period == DayPeriod.am
                                      ? 0
                                      : 1) ==
                                  index;
                              return Container(
                                alignment: Alignment.center,
                                child: GlobalText(
                                  period,
                                  fontSize: isSelected ? 16 : 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? primaryColor
                                      : textColor.withOpacity(0.7),
                                  useTranslation: false,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.onCancel != null)
              TextButton(
                onPressed: widget.onCancel,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: GlobalText(
                  AppStrings.cancel,
                  fontSize: 16,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ElevatedButton(
              onPressed: () => widget.onTimeSelected(selectedTime),
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

  String _formatTime(TimeOfDay time) {
    if (widget.use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }
}

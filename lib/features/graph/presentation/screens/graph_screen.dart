import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fire_todo/core/constants/app_colors.dart';
import 'package:fire_todo/core/constants/app_fonts.dart';
import 'package:fire_todo/core/constants/app_strings.dart';
import 'package:fire_todo/core/constants/app_assets.dart';
import 'package:fire_todo/core/injection/dp_injection.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_all_tasks.dart';
import 'package:fire_todo/shared/global/domain/entity/task_entity.dart';
import 'package:fire_todo/features/home/presentation/bloc/tasks/task_bloc.dart';
import 'package:fire_todo/shared/dialogs/coming_soon.dart';
import 'package:fire_todo/shared/widgets/action_button.dart';
import 'package:fire_todo/shared/widgets/global_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/graph_cubit.dart';
import '../cubit/graph_state.dart';

mixin GraphScreenMixin {
  List<double> calculateWeekData(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final offset = now.weekday == 7 ? 0 : now.weekday;
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: offset));

    final counts = List<double>.filled(7, 0.0);
    for (final task in tasks) {
      if (task.check) {
        final taskDate = task.dueAt ?? task.createdAt;
        final difference = taskDate.difference(startOfWeek).inDays;
        if (difference >= 0 && difference < 7) {
          counts[difference] += 1.0;
        }
      }
    }
    return counts;
  }

  List<double> calculateMonthData(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final counts = List<double>.filled(4, 0.0);

    for (final task in tasks) {
      if (task.check) {
        final taskDate = task.dueAt ?? task.createdAt;
        if (taskDate.year == now.year && taskDate.month == now.month) {
          final weekIndex = (taskDate.day - 1) ~/ 7;
          if (weekIndex >= 0 && weekIndex < 4) {
            counts[weekIndex] += 1.0;
          } else if (weekIndex >= 4) {
            counts[3] += 1.0;
          }
        }
      }
    }
    return counts;
  }

  List<double> calculateYearData(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final counts = List<double>.filled(12, 0.0);

    for (final task in tasks) {
      if (task.check) {
        final taskDate = task.dueAt ?? task.createdAt;
        if (taskDate.year == now.year) {
          final monthIndex = taskDate.month - 1;
          if (monthIndex >= 0 && monthIndex < 12) {
            counts[monthIndex] += 1.0;
          }
        }
      }
    }
    return counts;
  }

  List<double> getChartData(GraphFilter filter, List<TaskEntity> tasks) {
    return switch (filter) {
      GraphFilter.week => calculateWeekData(tasks),
      GraphFilter.month => calculateMonthData(tasks),
      GraphFilter.year => calculateYearData(tasks),
    };
  }

  String _shortWeekday(String key) {
    final str = key.tr();
    return str.length <= 3 ? str : str.substring(0, 3);
  }

  List<String> getBottomLabels(GraphFilter filter, BuildContext context) {
    return switch (filter) {
      GraphFilter.week => [
          _shortWeekday(AppStrings.sunday),
          _shortWeekday(AppStrings.monday),
          _shortWeekday(AppStrings.tuesday),
          _shortWeekday(AppStrings.wednesday),
          _shortWeekday(AppStrings.thursday),
          _shortWeekday(AppStrings.friday),
          _shortWeekday(AppStrings.saturday),
        ],
      GraphFilter.month => ['W1', 'W2', 'W3', 'W4'],
      GraphFilter.year => [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ],
    };
  }
}

class GraphScreen extends StatelessWidget with GraphScreenMixin {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GraphCubit(
        getAllTasks: getIt<GetAllTasksUsecase>(),
      )..loadTasks(),
      child: const GraphView(),
    );
  }
}

class GraphView extends StatelessWidget with GraphScreenMixin {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TasksLoadedState) {
          context.read<GraphCubit>().loadTasks();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GlobalText(
                    AppStrings.graph,
                    fontSize: 28,
                    fontFamily: AppFonts.recoleta,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  ActionButton(
                    icon: AppAssets.settings,
                    onTap: () => showComingSoonDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<GraphCubit, GraphState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      );
                    }

                    final completedTasksCount =
                        state.tasks.where((t) => t.check).length;
                    final pendingTasksCount =
                        state.tasks.where((t) => !t.check).length;

                    return ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        _buildChartCard(context, state),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                value: completedTasksCount,
                                labelKey: AppStrings.completedTasks,
                                hasBorder: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMetricCard(
                                value: pendingTasksCount,
                                labelKey: AppStrings.pendingTasks,
                                hasBorder: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildChartCard(BuildContext context, GraphState state) {
    final values = getChartData(state.filter, state.tasks);
    final labels = getBottomLabels(state.filter, context);
    final maxVal = values.isEmpty
        ? 10.0
        : values.reduce((a, b) => a > b ? a : b);
    final maxY = maxVal < 10.0 ? 10.0 : ((maxVal / 2).ceil() * 2).toDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalText(
                AppStrings.completedTask,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
              _buildFilterDropdown(context, state.filter),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.grey500.withValues(alpha: 0.5),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final valStr = value.toInt().toString().padLeft(2, '0');
                        return SideTitleWidget(
                          meta: meta,
                          space: 4,
                          child: Text(
                            valStr,
                            style: const TextStyle(
                              color: AppColors.grey300,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < labels.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              labels[index],
                              style: const TextStyle(
                                color: AppColors.grey300,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.white,
                    tooltipBorderRadius: const BorderRadius.all(Radius.circular(8)),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final val = rod.toY.toInt();
                      return BarTooltipItem(
                        "$val ${AppStrings.taskSuffix.tr()}",
                        const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      context.read<GraphCubit>().touchBar(null);
                      return;
                    }
                    final touchedIndex =
                        barTouchResponse.spot!.touchedBarGroupIndex;
                    context.read<GraphCubit>().touchBar(touchedIndex);
                  },
                ),
                barGroups: List.generate(values.length, (index) {
                  final val = values[index];
                  final isTouched = state.touchedBarIndex == index;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: val,
                        color: isTouched
                            ? AppColors.purple
                            : AppColors.white.withValues(alpha: 0.9),
                        width: 18,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: false,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext context, GraphFilter currentFilter) {
    final Map<GraphFilter, String> filterNames = {
      GraphFilter.week: AppStrings.thisWeek,
      GraphFilter.month: AppStrings.thisMonth,
      GraphFilter.year: AppStrings.thisYear,
    };

    return PopupMenuButton<GraphFilter>(
      onSelected: (filter) => context.read<GraphCubit>().changeFilter(filter),
      color: AppColors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlobalText(
              filterNames[currentFilter]!,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.white,
              size: 18,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => filterNames.entries.map((entry) {
        return PopupMenuItem<GraphFilter>(
          value: entry.key,
          child: GlobalText(
            entry.value,
            color: AppColors.white,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricCard({
    required int value,
    required String labelKey,
    required bool hasBorder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(24),
        border: hasBorder
            ? Border.all(color: AppColors.blue, width: 2)
            : Border.all(color: Colors.transparent, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlobalText(
            value.toString(),
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            useTranslation: false,
          ),
          const SizedBox(height: 8),
          GlobalText(
            labelKey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey300,
          ),
        ],
      ),
    );
  }
}

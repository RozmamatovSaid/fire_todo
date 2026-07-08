import 'package:fire_todo/features/home/presentation/bloc/tasks/task_bloc.dart';
import 'package:fire_todo/features/search/presentation/bloc/bloc/search_bloc.dart';
import 'package:fire_todo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:fire_todo/features/home/domain/repository/category_repository.dart';
import 'package:fire_todo/features/home/domain/repository/task_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/presentation/bloc/category/category_bloc.dart';
import '../injection/dp_injection.dart';

abstract class Providers {
  static List<BlocProvider> bloc = [
    BlocProvider<CategoryBloc>(create: (context) => getIt<CategoryBloc>()),
    BlocProvider<TaskBloc>(create: (context) => getIt<TaskBloc>()),
    BlocProvider<SearchBloc>(create: (context) => getIt<SearchBloc>()),
    BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(
        taskBloc: context.read<TaskBloc>(),
        categoryBloc: context.read<CategoryBloc>(),
        categoryRepository: getIt<CategoryRepository>(),
        taskRepository: getIt<TaskRepository>(),
      )..init(),
    ),
  ];
}

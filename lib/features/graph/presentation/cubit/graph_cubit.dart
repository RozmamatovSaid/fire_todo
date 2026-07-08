import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fire_todo/features/home/domain/usecase/task/get_all_tasks.dart';
import 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  final GetAllTasksUsecase getAllTasks;

  GraphCubit({required this.getAllTasks}) : super(const GraphState());

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllTasks();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (tasks) => emit(state.copyWith(isLoading: false, tasks: tasks)),
    );
  }

  void changeFilter(GraphFilter filter) {
    emit(state.copyWith(filter: filter, touchedBarIndex: null));
  }

  void touchBar(int? index) {
    emit(state.copyWith(touchedBarIndex: index));
  }
}

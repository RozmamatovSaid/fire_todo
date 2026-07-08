import 'package:fire_todo/features/search/presentation/bloc/bloc/search_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../features/search/data/repository/search_repository_impl.dart';
import '../../features/search/domain/repository/search_repo.dart';
import '../../features/search/domain/usecase/search_usecase.dart';
import '../../shared/global/data/datasource/category_local_datasource.dart';
import '../../shared/global/data/datasource/task_local_datasource.dart';
import '../../features/home/data/repository/category_repository_impl.dart';
import '../../features/home/data/repository/task_repository_impl.dart';
import '../../features/home/domain/repository/category_repository.dart';
import '../../features/home/domain/repository/task_repository.dart';
import '../../features/home/domain/usecase/add_category.dart';
import '../../features/home/domain/usecase/delete_category.dart';
import '../../features/home/domain/usecase/get_all_categories.dart';
import '../../features/home/domain/usecase/update_category.dart';
import '../../features/home/domain/usecase/task/add_task.dart';
import '../../features/home/domain/usecase/task/delete_task.dart';
import '../../features/home/domain/usecase/task/get_all_tasks.dart';
import '../../features/home/domain/usecase/task/get_tasks_by_category.dart';
import '../../features/home/domain/usecase/task/get_tasks_by_date.dart';
import '../../features/home/domain/usecase/task/update_task.dart';
import '../../features/home/presentation/bloc/category/category_bloc.dart';
import '../../features/home/presentation/bloc/tasks/task_bloc.dart';
import '../services/database_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  //  Database ni birinchi bo'lib init qilamiz
  await IsarService.getInstance();

  // category local datasource
  final categoryLocalDatasource = CategoryLocalDataSourceImpl();
  await categoryLocalDatasource.init();
  getIt.registerLazySingleton<CategoryLocalDataSource>(
    () => categoryLocalDatasource,
  );

  // category repository
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      localDatasource: getIt<CategoryLocalDataSource>(),
    ),
  );

  // category usecases
  getIt.registerLazySingleton<AddCategoryUseCase>(
    () => AddCategoryUseCase(repo: getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase(repo: getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<GetAllCategoriesUseCase>(
    () => GetAllCategoriesUseCase(repo: getIt<CategoryRepository>()),
  );
  getIt.registerLazySingleton<UpdateCategoryUseCase>(
    () => UpdateCategoryUseCase(repo: getIt<CategoryRepository>()),
  );

  // category bloc
  getIt.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      addCategory: getIt<AddCategoryUseCase>(),
      deleteCategory: getIt<DeleteCategoryUseCase>(),
      getAllCategories: getIt<GetAllCategoriesUseCase>(),
      updateCategory: getIt<UpdateCategoryUseCase>(),
    ),
  );

  //================Task Injection=====================
  // task local datasource
  final taskLocalDatasource = TaskLocalDatasourceImpl();
  await taskLocalDatasource.init();
  getIt.registerLazySingleton<TaskLocalDatasource>(() => taskLocalDatasource);

  // task repository
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: getIt<TaskLocalDatasource>()),
  );

  // task usecases
  getIt.registerLazySingleton<AddTaskUsecase>(
    () => AddTaskUsecase(repo: getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<DeleteTaskUsecase>(
    () => DeleteTaskUsecase(repo: getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<GetAllTasksUsecase>(
    () => GetAllTasksUsecase(repo: getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<GetTasksByCategoryIdUsecase>(
    () => GetTasksByCategoryIdUsecase(repo: getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<GetTasksByDateUsecase>(
    () => GetTasksByDateUsecase(repo: getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<UpdateTaskUsecase>(
    () => UpdateTaskUsecase(repo: getIt<TaskRepository>()),
  );

  // Task Bloc
  getIt.registerFactory<TaskBloc>(
    () => TaskBloc(
      addTask: getIt<AddTaskUsecase>(),
      deleteTask: getIt<DeleteTaskUsecase>(),
      getAllTasks: getIt<GetAllTasksUsecase>(),
      getByCategoryId: getIt<GetTasksByCategoryIdUsecase>(),
      getByDate: getIt<GetTasksByDateUsecase>(),
      updateTask: getIt<UpdateTaskUsecase>(),
    ),
  );
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(localDatasource: getIt<TaskLocalDatasource>()),
  );
  getIt.registerLazySingleton(
    () => SearchUsecase(repo: getIt<SearchRepository>()),
  );
  getIt.registerFactory<SearchBloc>(
    () => SearchBloc(searchUsecase: getIt<SearchUsecase>()),
  );
}

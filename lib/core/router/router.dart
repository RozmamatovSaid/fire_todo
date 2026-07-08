import 'package:fire_todo/core/router/router_paths.dart';
import 'package:fire_todo/features/entrance/presentation/screens/entrance_screen.dart';
import 'package:fire_todo/features/search/presentation/screen/search_screen.dart';
import 'package:fire_todo/features/settings/presentation/screens/settings_screen.dart';
import 'package:fire_todo/features/task_info/presentation/screen/task_info_screen.dart';
import 'package:fire_todo/features/main/presentation/screens/main_screen.dart';
import 'package:fire_todo/features/main/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import '../../shared/global/domain/entity/task_entity.dart';

GoRouter router = GoRouter(
  initialLocation: RouterPaths.splashScreen,
  routes: [
    GoRoute(
      path: RouterPaths.entrance,
      builder: (context, state) => EntranceScreen(),
    ),
    GoRoute(path: RouterPaths.home, builder: (context, state) => MainScreen()),
    GoRoute(
      path: RouterPaths.splashScreen,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: RouterPaths.taskInfo,
      builder: (context, state) {
        // ✅ Map obyektini parse qilish
        final extra = state.extra as Map<String, dynamic>;
        final task = extra['task'] as TaskEntity;
        final categoryName = extra['categoryName'] as String?;

        return TaskInfo(
          task: task, // To'liq TaskEntity obyekti
          categoryName: categoryName,
        );
      },
    ),
    GoRoute(
      path: RouterPaths.searchScreen,
      builder: (context, state) => SearchScreen(),
    ),
    GoRoute(
      path: RouterPaths.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

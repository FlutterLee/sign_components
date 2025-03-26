import 'package:go_router/go_router.dart';
import 'package:onestep/feature/splash/presentation/pages/splash.dart';

final router = GoRouter(
  initialLocation: '/', // 초기 경로
  routes: [GoRoute(path: '/', builder: (context, state) => const Splash())],
);

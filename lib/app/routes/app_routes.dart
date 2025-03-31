import 'package:go_router/go_router.dart';
import 'package:onestep/feature/sign_test/sign_test.dart';
import 'package:onestep/feature/splash/presentation/pages/splash.dart';

final router = GoRouter(
  initialLocation: '/sign-test',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Splash()),
    GoRoute(
      path: '/sign-test',
      builder: (context, state) => const SignTestScreen(),
    ),
  ],
);

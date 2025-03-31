import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onestep/app/di/injection_contatiner.dart';
import 'package:onestep/app/routes/app_routes.dart';
import 'package:onestep/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  try {
    debugPrint('[DEBUG] 앱 초기화 시작');

    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('[DEBUG] Flutter 바인딩 초기화 완료');

    await initDependencies();
    debugPrint('[DEBUG] 의존성 초기화 완료');

    if (kReleaseMode) {
      await Firebase.initializeApp(
        name: 'onestepRelease',
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await Supabase.initialize(
        url: 'YOUR_RELEASE_SUPABASE_URL',
        anonKey: 'YOUR_RELEASE_ANON_KEY',
      );
    } else if (kDebugMode) {
      try {
        debugPrint('[DEBUG] Firebase 초기화 시작');
        final firebaseApp = await Firebase.initializeApp(
          // name: 'onestepDebug',
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('[DEBUG] Firebase 초기화 완료: ${firebaseApp.options.projectId}');
      } catch (e, stackTrace) {
        debugPrint('[ERROR] Firebase 초기화 실패');
        debugPrint('[ERROR] 메시지: $e');
        debugPrint('[ERROR] 스택트레이스:\n$stackTrace');
      }

      try {
        debugPrint('[DEBUG] Supabase 초기화 시작');
        await Supabase.initialize(
          url: '',
          anonKey:
              '',
        );
        debugPrint('[DEBUG] Supabase 초기화 완료');
      } catch (e, stackTrace) {
        debugPrint('[ERROR] Supabase 초기화 실패');
        debugPrint('[ERROR] 메시지: $e');
        debugPrint('[ERROR] 스택트레이스:\n$stackTrace');
      }
    }

    debugPrint('[DEBUG] runApp 실행');
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('[ERROR] 앱 초기화 중 예상치 못한 에러 발생');
    debugPrint('[ERROR] 메시지: $e');
    debugPrint('[ERROR] 스택트레이스:\n$stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router, title: 'OneStep');
  }
}

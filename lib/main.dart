import 'package:flutter/material.dart';
import 'package:onestep/app/di/injection_contatiner.dart';
import 'package:onestep/app/routes/app_routes.dart';

void main() async {
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router, title: 'OneStep');
  }
}

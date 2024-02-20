import 'package:admission/provider/admission_provider.dart';
import 'package:admission/widget/screen/admission/admission_dashboard.dart';
import 'package:admission/widget/screen/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AdmissionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Login(),
        routes: {
          '/login': (context) => const Login(),
          '/admissiondashboard': (context) => const AdmissionDashboard(),
        });
  }
}

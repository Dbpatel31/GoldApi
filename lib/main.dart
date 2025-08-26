import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:goldapi/routes/app_pages.dart';
import 'package:goldapi/view/expense_screen.dart';
import 'package:goldapi/view/player_screen.dart';

import 'app_bindings.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await AppBindings.initService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // showPerformanceOverlay: true,
      // initialRoute: AppPages.initial,
      // getPages: AppPages.pages,
      initialBinding: AppBindings(),
      home:  ExpenseScreen(),
    );
  }
}




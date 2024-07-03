import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remove_background/main_menu/view/main_menu_view.dart';
import 'package:remove_background/uplode/remove_background_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RemoveBackgroundView(),
    );
  }
}

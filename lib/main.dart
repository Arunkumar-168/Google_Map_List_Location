import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap_list/Src/View/Widget_UI/splash_Screen.dart';
import 'package:googlemap_list/Utils/Common_Widget/Colors.dart';
import 'package:googlemap_list/Utils/Common_Widget/Route_Pages.dart';
import 'package:googlemap_list/Utils/Initial_Binding/Initial_Binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Location Manager',
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.grey,
          selectionColor: backgroundColor,
          selectionHandleColor: backgroundColor,
        ),
      ),
      initialBinding: LocationBinding(),
      initialRoute: RoutePages.getSplashRoute(),
      getPages: RoutePages.routes,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

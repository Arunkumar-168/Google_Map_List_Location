import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap_list/Src/View/Widget_UI/home_Page.dart';
import 'package:googlemap_list/Src/View/Widget_UI/location_list_Details_Page.dart';
import 'package:googlemap_list/Src/View/Widget_UI/splash_Screen.dart';

class RoutePages {
  static const String splash = '/splash';
  static const String homePage = '/homePage';
  static const String locationDetails = '/locationDetailsPage';

  static String getSplashRoute() => splash;

  static String getHomeRoute() => homePage;

  static String getLocationDetailsRoute() => locationDetails;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: homePage, page: () => const HomePage()),
    GetPage(name: locationDetails, page: () =>  LocationListPage()),
  ];
}

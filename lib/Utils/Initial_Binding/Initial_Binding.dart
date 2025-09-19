import 'package:get/get.dart';
import 'package:googlemap_list/Src/Controller/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}

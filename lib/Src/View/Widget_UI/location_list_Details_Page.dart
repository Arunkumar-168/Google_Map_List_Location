// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:googlemap_list/Src/Controller/location_controller.dart';
// import 'package:googlemap_list/Src/View_Model/Widgets/confirm_dialog.dart';
// import 'package:googlemap_list/Src/View_Model/Widgets/Add_Location_Page.dart';
// import 'package:googlemap_list/Src/View_Model/Widgets/location_tile.dart';
// import 'package:googlemap_list/Utils/Common_Widget/Colors.dart';
//
// class LocationListPage extends StatelessWidget {
//   const LocationListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final LocationController controller = Get.find();
//
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.purple,
//           elevation: 0,
//           title: const Text(
//             "Locations Details",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           )),
//       floatingActionButton: FloatingActionButton(
//           backgroundColor: backgroundColor,
//           child: const Icon(Icons.add, color: Colors.white),
//           onPressed: () => Get.to(() => const AddLocationPage())),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (controller.locations.isEmpty) {
//           return const Center(
//               child: Text(
//             "No locations found.",
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ));
//         }
//         return ListView.builder(
//           itemCount: controller.locations.length,
//           itemBuilder: (context, index) {
//             final loc = controller.locations[index];
//             return LocationTile(
//               index: index,
//               location: loc,
//               onEdit: () => Get.to(
//                 () => const AddLocationPage(),
//                 arguments: {
//                   "id": loc.id,
//                   "name": loc.name,
//                   "latitude": loc.latitude,
//                   "longitude": loc.longitude,
//                 },
//               ),
//               onDelete: () async {
//                 bool? confirmed = await showDialog<bool>(
//                   context: context,
//                   builder: (_) => ConfirmDialog(
//                     title: 'Delete Location',
//                     content: 'Delete "${loc.name}"?',
//                   ),
//                 );
//                 if (confirmed ?? false) {
//                   await controller.deleteLocation(loc.id!);
//                   Get.snackbar(
//                     'Deleted',
//                     'Location "${loc.name}" deleted',
//                     snackPosition: SnackPosition.BOTTOM,
//                     snackStyle: SnackStyle.FLOATING,
//                     backgroundColor: Colors.purple,
//                     colorText: Colors.white,
//                   );
//                 }
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap_list/Src/Controller/location_controller.dart';
import 'package:googlemap_list/Src/View_Model/Widgets/Add_Location_Page.dart';
import 'package:googlemap_list/Src/View_Model/Widgets/confirm_dialog.dart';
import 'package:googlemap_list/Src/View_Model/Widgets/location_tile.dart';
import 'package:googlemap_list/Utils/Common_Widget/Route_Pages.dart';

class LocationListPage extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());

  LocationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Locations Details",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.offAllNamed(RoutePages.getHomeRoute());
          },
        ),
        backgroundColor: Colors.purple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.locations.isEmpty) {
          return const Center(child: Text("No Locations"));
        }

        return ListView.builder(
          itemCount: controller.locations.length,
          itemBuilder: (context, index) {
            final loc = controller.locations[index];
            return LocationTile(
              index: index,
              location: loc,
              onEdit: () {
                controller.animateCameraTo(
                  LatLng(loc.latitude, loc.longitude),
                );
                Get.to(() => const AddLocationPage(), arguments: {
                  "id": loc.id,
                  "name": loc.name,
                  "latitude": loc.latitude,
                  "longitude": loc.longitude,
                });
              },
              onDelete: () async {
                bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => ConfirmDialog(
                    title: 'Delete Location',
                    content: 'Delete "${loc.name}"?',
                  ),
                );
                if (confirmed ?? false) {
                  controller.deleteLocation(loc.id);
                  Get.snackbar(
                    'Deleted',
                    'Location "${loc.name}" deleted',
                    snackPosition: SnackPosition.BOTTOM,
                    snackStyle: SnackStyle.FLOATING,
                    backgroundColor: Colors.purple,
                    colorText: Colors.white,
                  );
                }
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Get.to(() => const AddLocationPage());
        },
      ),
    );
  }
}

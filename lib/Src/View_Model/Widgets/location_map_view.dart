import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap_list/Src/Controller/location_controller.dart';
import 'package:googlemap_list/Src/View_Model/Widgets/Add_Location_Page.dart';

class LocationsMapPage extends StatelessWidget {
  LocationsMapPage({super.key});

  final LocationController controller = Get.put(LocationController());
  final TextEditingController searchCtrl = TextEditingController();
  DateTime timeBackPressed = DateTime.now();
  bool warningShown = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= Duration(seconds: 1);
          timeBackPressed = DateTime.now();
          if (isExitWarning) {
            warningShown = false;
          }
          if (!warningShown) {
            warningShown = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
              ),
            );
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.purple,
            title: const Text("Locations Map",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          body: Stack(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.locations.isEmpty) {
                  return const Center(child: Text("No Locations"));
                }
                List<LatLng> polyPoints = controller.locations
                    .map((loc) => LatLng(loc.latitude, loc.longitude))
                    .toList();

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(controller.locations.first.latitude,
                        controller.locations.first.longitude),
                    zoom: 6,
                  ),
                  markers: controller.markers.value,
                  polylines: polyPoints.length > 1
                      ? {
                          Polyline(
                            polylineId: const PolylineId('polyline'),
                            points: polyPoints,
                            color: Colors.blue,
                            width: 4,
                          )
                        }
                      : {},
                  onMapCreated: (mapCtrl) => controller.mapController = mapCtrl,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                );
              }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: () {
              final loc = controller.selectedLocation.value;
              if (loc != null) {
                controller.animateCameraTo(LatLng(loc.latitude, loc.longitude));
                Get.to(() => const AddLocationPage(), arguments: {
                  "id": loc.id,
                  "name": loc.name,
                  "latitude": loc.latitude,
                  "longitude": loc.longitude,
                });
              } else {
                Get.to(() => const AddLocationPage());
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ));
  }
}

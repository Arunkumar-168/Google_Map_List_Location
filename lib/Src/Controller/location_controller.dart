import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap_list/Src/Model/location_model.dart';
import 'package:googlemap_list/Utils/DataBase/location_database.dart';

class LocationController extends GetxController {
  var selectedLocation = Rxn<LocationModel>();
  var locations = <LocationModel>[].obs;
  var markers = <Marker>{}.obs;
  late GoogleMapController mapController;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLocations();
  }

  void loadLocations() async {
    isLoading(true);
    try {
      isLoading(true);
      final data = await LocationDatabase.instance.readAll();
      locations.assignAll(data);
    } finally {
      isLoading(false);
    }
    locations.value = [
      LocationModel(id: 1, name: 'Coimbatore', latitude: 11.0083379, longitude: 76.9432796),
      LocationModel(id: 2, name: 'Chennai', latitude: 13.0913357, longitude: 80.2807710),
      LocationModel(id: 3, name: 'Bangalore', latitude: 12.9780346, longitude: 77.5945322),
    ];
    updateMarkers();
    isLoading(false);
  }

  void updateMarkers() {
    final Set<Marker> newMarkers = {};
    for (var loc in locations) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(loc.id.toString()),
          position: LatLng(loc.latitude, loc.longitude),
          infoWindow: InfoWindow(title: loc.name),
          onTap: () {
            selectedLocation.value = loc;
          },
        ),
      );
    }
    markers.value = newMarkers;
  }

  void animateCameraTo(LatLng latLng) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 14),
      ),
    );
    }

  void searchAddress(String query) {
    if (query.isEmpty) {
      loadLocations();
      return;
    }
    final filtered = locations.where((loc) =>
        loc.name.toLowerCase().contains(query.toLowerCase())).toList();
    locations.value = filtered;
    updateMarkers();
  }

  void addLocation(LocationModel loc) {
    locations.add(loc);
    selectedLocation.value = loc;
    updateMarkers();
  }

  void updateLocation(LocationModel loc) {
    final index = locations.indexWhere((l) => l.id == loc.id);
    if (index != -1) {
      locations[index] = loc;
    } else {
      locations.add(loc);
    }
    selectedLocation.value = loc;
    updateMarkers();
  }

  void deleteLocation(int? id) {
    if (id == null) return;
    locations.removeWhere((e) => e.id == id);
    if (selectedLocation.value != null && selectedLocation.value!.id == id) {
      selectedLocation.value = null;
    }
    updateMarkers();
  }

















  // Future<void> addLocation(LocationModel loc) async {
  //   await LocationDatabase.instance.create(loc);
  //   fetchLocations();
  // }
  //
  // Future<void> updateLocation(LocationModel loc) async {
  //   await LocationDatabase.instance.update(loc);
  //   fetchLocations();
  // }

  // Future<void> deleteLocation(int id) async {
  //   await LocationDatabase.instance.delete(id);
  //   fetchLocations();
  // }
}






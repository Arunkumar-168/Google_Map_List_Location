import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googlemap_list/Src/Controller/location_controller.dart';
import 'package:googlemap_list/Src/Model/location_model.dart';
import 'package:googlemap_list/Src/View/Widget_UI/location_list_Details_Page.dart';
import 'package:googlemap_list/Utils/Common_Widget/Colors.dart';
import 'package:googlemap_list/Utils/Common_Widget/Route_Pages.dart';
import 'package:googlemap_list/Utils/Common_Widget/Style.dart';


class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});
  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final locationName = TextEditingController();
  final latitute = TextEditingController();
  final langititute = TextEditingController();
  int? locationId;
  bool isDataLoaded = false; // to avoid reloading multiple times

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isDataLoaded) {
      final args = Get.arguments ?? {};
      if (args.isNotEmpty) {
        locationId = args["id"];
        locationName.text = args["name"] ?? "";
        latitute.text = args["latitude"]?.toString() ?? "";
        langititute.text = args["longitude"]?.toString() ?? "";
      }
      isDataLoaded = true;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<LocationController>();
      final name = locationName.text.trim();
      final latitude = double.parse(latitute.text.trim());
      final longitude = double.parse(langititute.text.trim());
      if (locationId == null) {
        final newId = DateTime.now().millisecondsSinceEpoch;
        controller.addLocation(LocationModel(
          id: newId,
          name: name,
          latitude: latitude,
          longitude: longitude,
        ));
        Get.off(() =>  LocationListPage());
        Get.snackbar(
          "Added",
          "Location added successfully",
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.purple,
          colorText: Colors.white,
        );
      } else {
        controller.updateLocation(LocationModel(
          id: locationId,
          name: name,
          latitude: latitude,
          longitude: longitude,
        ));
        Get.off(() =>  LocationListPage());
        Get.snackbar(
          "Updated",
          "Location updated successfully",
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.purple,
          colorText: Colors.white,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isEditing = locationId != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(isEditing ? 'Edit Location' : 'Add Location',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.offAllNamed(RoutePages.getHomeRoute());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Enter your Location Name", "Location Name",
                  locationName, _validateName),
              const SizedBox(height: 10),
              _buildTextField("Enter the Latitude", "Latitude", latitute,
                  _validateLatitude,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField("Enter the Longitude", "Longitude", langititute,
                  _validateLongitude,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white),
                onPressed: _submit,
                child: Text(isEditing ? "Update" : "Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateName(String? v) =>
      v == null || v.trim().isEmpty ? 'Enter your Location Name' : null;
  String? _validateLatitude(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter the Latitude';
    final d = double.tryParse(v);
    if (d == null) return 'Latitude must be a number';
    if (d < -90 || d > 90) return 'Latitude must be between -90 and 90';
    return null;
  }
String? _validateLongitude(String? v) {
  if (v == null || v.trim().isEmpty) return 'Enter the Longitude';
  final d = double.tryParse(v);
  if (d == null) return 'Longitude must be a number';
  if (d < -180 || d > 180) return 'Longitude must be between -180 and 180';
  return null;
}
}


Widget _buildTextField(
  String hint,
  String label,
  TextEditingController controller,
  String? Function(String?)? validator, {
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: textBold,
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: textMedium1,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: blackColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: backgroundColor, width: 1.5),
          ),
        ),
        validator: validator,
      ),
    ],
  );
}
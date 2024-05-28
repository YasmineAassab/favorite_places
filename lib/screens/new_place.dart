import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:favorite_places/core/utils/location_utils.dart';
import 'package:favorite_places/service/location_service.dart';
import 'package:favorite_places/widget/image_input.dart';
import '../widget/location_input.dart';

final addressProvider =
    StateNotifierProvider<Address, String?>((ref) => Address());
final latLng = StateProvider<LatLng>((ref) => const LatLng(0, 0));

class Address extends StateNotifier<String> {
  Address() : super('');

  Future<String> getAddress(latitude, longitude) async {
    await placemarkFromCoordinates(latitude, longitude).then((placemarks) {
      if (placemarks.isNotEmpty) {
        final fullAddress = placemarks[0];
        state =
            '${fullAddress.name}, ${fullAddress.street}, ${fullAddress.country}, ${fullAddress.postalCode}';
      }
    });
    return state;
  }
}

class NewPlace extends ConsumerStatefulWidget {
  const NewPlace({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPlaceState();
}

class _NewPlaceState extends ConsumerState<NewPlace> {
  final TextEditingController _textEditingController = TextEditingController();
  LocationService? locationService;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    locationService = LocationService();
  }

  Future<void> addPicture() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              ImageInput(
                takePicture: () => addPicture(),
                imagePath: _selectedImage,
              ),
              const SizedBox(
                height: 20,
              ),
              LocationInput(
                getLocation: () => locationService!.getCurrentLocation(),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton.icon(
                onPressed: () {
                  LocationUtils.addNewPlace(
                    ref,
                    context,
                    _textEditingController,
                    _selectedImage,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
